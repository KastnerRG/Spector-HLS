import sys, os
import logging

from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import Matern, RationalQuadratic
from scipy.stats import entropy

from pygmo import hypervolume

from SampleSelection import TED
from utils import adrs, prpt, approximate_pareto, compute_scores
from RBF import *
from MAB import MultiArmedBandit

import multiprocessing as mp
import warnings

import gc



logger = logging.getLogger(__name__)



def model_predict(X, y, y_hint, surrogate_type, kernel, num_restarts, ted_scale,
                  known_inputs, known_outputs_modified,
                  previous_trace=None,
                  queue = None):


    hint_idx_to_use = np.arange(X.shape[0])

    use_hint = surrogate_type.endswith('_hint')

    if use_hint:
        surrogate_type = surrogate_type[:-5]


    # Using GPy
    if surrogate_type.startswith('gpy'):

        import GPy

        ndims = X.shape[1]

        separate_dims = 'multi' in surrogate_type
        use_sparsegp = 'sparse' in surrogate_type

        # Number of output
        noutputs = 1
        if use_hint:
            noutputs = y.shape[1] * 2 if separate_dims else 2
        elif separate_dims:
            noutputs = y.shape[1]

        # Initialize kernel
        K1 = GPy.kern.Bias(ndims)

        kernel_variance = 1
        kernel_lengthscale = 1

        if kernel == "matern":
            K2 = GPy.kern.Matern32(input_dim=ndims, ARD=True, variance=kernel_variance,
                                   lengthscale=kernel_lengthscale)
        elif kernel == "rbf":
            K2 = GPy.kern.RBF(input_dim=ndims, ARD=True, variance=kernel_variance, lengthscale=kernel_lengthscale)
        else:
            K2 = kernel

        if noutputs > 1:
            final_kernel = GPy.util.multioutput.ICM(input_dim=ndims, num_outputs=noutputs, kernel=K1, W_rank=1,
                                                    kappa=100.0 * np.ones(noutputs), name='ICM0') + \
                           GPy.util.multioutput.ICM(input_dim=ndims, num_outputs=noutputs, kernel=K2, W_rank=1,
                                                    kappa=100.0 * np.ones(noutputs), name='ICM1')
        else:
            final_kernel = K1 + K2

        with warnings.catch_warnings():
            warnings.simplefilter("ignore")

            # - Simple GP
            if noutputs == 1:
                if use_sparsegp:
                    surrogate_f = GPy.models.SparseGPRegression(known_inputs, known_outputs_modified,
                                                                final_kernel)
                else:
                    surrogate_f = GPy.models.GPRegression(known_inputs, known_outputs_modified, kernel=final_kernel)

                if num_restarts > 0:
                    surrogate_f.optimize_restarts(num_restarts=num_restarts, verbose=False, robust=True,
                                                  parallel=False)
                else:
                    surrogate_f.optimize()

                ypredict, ypredict_std = surrogate_f.predict(X)

            # - Multioutput GP
            else:
                if separate_dims:
                    multiple_inputs = [known_inputs for _ in range(y.shape[1])]
                    multiple_outputs = [known_outputs_modified[:, i][:, np.newaxis] for i in range(y.shape[1])]
                else:
                    multiple_inputs = [known_inputs]
                    multiple_outputs = [known_outputs_modified]

                if use_hint:
                    if separate_dims:
                        multiple_inputs += [X[hint_idx_to_use, :] for _ in range(y.shape[1])]
                        multiple_outputs += [y_hint[hint_idx_to_use, i][:, np.newaxis] for i in
                                             range(y.shape[1])]
                    else:
                        multiple_inputs.append(X[hint_idx_to_use, :])
                        multiple_outputs.append(y_hint[hint_idx_to_use, :])

                if use_sparsegp:
                    surrogate_f = GPy.models.SparseGPCoregionalizedRegression(multiple_inputs, multiple_outputs,
                                                                              kernel=final_kernel)
                else:
                    surrogate_f = GPy.models.GPCoregionalizedRegression(multiple_inputs, multiple_outputs,
                                                                        kernel=final_kernel)
                surrogate_f['.*ICM.*var'].constrain_fixed(1.)
                # Constrain bias kernel
                surrogate_f['.*ICM0.*var'].constrain_fixed(1.)
                surrogate_f['.*ICM0.*W'].constrain_fixed(0)

                if num_restarts > 0:
                    surrogate_f.optimize_restarts(num_restarts=num_restarts, verbose=False, robust=True,
                                                  parallel=False)
                else:
                    surrogate_f.optimize()

                ypredict = []
                ypredict_std = []
                for i in range(y.shape[1] if separate_dims else 1):
                    newX = np.c_[X, np.ones(X.shape[0]) * i]
                    noise_dict = {'output_index': newX[:, -1].astype(int)}
                    ypredict_i, ypredict_std_i = surrogate_f.predict(newX, Y_metadata=noise_dict)
                    ypredict.append(ypredict_i.squeeze())
                    ypredict_std.append(ypredict_std_i)

                if separate_dims:
                    ypredict = np.array(ypredict).T
                    ypredict_std = np.array(ypredict_std).sum(axis=0)
                else:
                    ypredict = ypredict[0]
                    ypredict_std = ypredict_std[0]


    # Using GPflow
    elif surrogate_type == "gpflow":

        warnings.warn("Sherlock does not work well with GPflow at this time.")

        import gpflow

        ndims = X.shape[1]

        # Initialize kernel
        K1 = gpflow.kernels.Bias(ndims)
        if kernel == "matern":
            K2 = gpflow.kernels.Matern32(input_dim=ndims, ARD=True)
        elif kernel == "rbf":
            K2 = gpflow.kernels.RBF(input_dim=ndims, ARD=True)
        else:
            K2 = kernel

        final_kernel = K1 + K2

        if use_hint:
            Kcoreg = gpflow.kernels.Coregion(1, output_dim=2, rank=1, active_dims=[ndims])
            coreg_kern = (K1 + K2) * Kcoreg

        if not use_hint:

            surrogate_f = gpflow.models.GPR(known_inputs, known_outputs_modified, kern=final_kernel)
            gpflow.train.ScipyOptimizer().minimize(surrogate_f)

            # unknown_output_predictions, p_std = surrogate_f.predict_y(X_mysterious)
            ypredict, ypredict_std = surrogate_f.predict_y(X)

        else:

            # build a variational model. This likelihood switches between Student-T noise with different variances:
            lik = gpflow.likelihoods.SwitchedLikelihood(
                [gpflow.likelihoods.StudentT(), gpflow.likelihoods.StudentT()])

            # Augment the time data with ones or zeros to indicate the required output dimension
            X_augmented = np.vstack((np.hstack((known_inputs, np.zeros((known_inputs.shape[0], 1)))),
                                     np.hstack((X[hint_idx_to_use, :], np.ones((len(hint_idx_to_use), 1))))))

            # Augment the Y data to indicate which likelihood we should use
            Y_augmented = np.vstack((np.hstack((known_outputs_modified, np.zeros((known_inputs.shape[0], 1)))),
                                     np.hstack(
                                         (y_hint[hint_idx_to_use, :], np.ones((len(hint_idx_to_use), 1))))))

            # now buld the GP model as normal
            surrogate_f = gpflow.models.VGP(X_augmented, Y_augmented, kern=coreg_kern, likelihood=lik,
                                            num_latent=None)

            surrogate_f.kern.coregion.W = np.random.randn(surrogate_f.kern.coregion.W.shape[0],
                                                          surrogate_f.kern.coregion.W.shape[1])

            gpflow.train.ScipyOptimizer().minimize(surrogate_f)

            # unknown_output_predictions, p_std = surrogate_f.predict_y(X_mysterious)
            ypredict, ypredict_std = surrogate_f.predict_y(X)

        # if p_std.ndim > 1: p_std = np.sum(p_std, axis=1)

    elif surrogate_type == "only":
        surrogate_f = None
        ypredict = np.copy(y_hint)
        ypredict_std = np.ones(ypredict.shape[0], dtype=np.float)

    # Other surrogate models
    else:

        if surrogate_type.startswith("rbf"):
            if len(surrogate_type) > 3:
                rbf_basis = surrogate_type[3:].strip('_ ')
            else:
                rbf_basis = 'linear'
            rbf_basis = bases(rbf_basis)
            if rbf_basis.__code__.co_argcount == 2:  # then basis requires a scale param
                well_formed_basis = lambda x: rbf_basis(x, ted_scale)
            else:  # the basis is already well-formed
                well_formed_basis = rbf_basis
            surrogate_f = RBFConsensus(radial_basis_function=well_formed_basis, norm='euclidean')
        elif surrogate_type == "gp":
            if kernel == "matern":
                final_kernel = Matern(length_scale_bounds=[0.01, 100], nu=1.5)
            elif kernel == "rationalquadratic":
                final_kernel = RationalQuadratic()
            else:
                final_kernel = kernel
            surrogate_f = GaussianProcessRegressor(kernel=final_kernel, normalize_y=True)  # , random_state=7
        elif surrogate_type == "gphodlr":
            import hodlr.hodler_gp as hodlr
            if kernel == "matern":
                final_kernel = hodlr.matern32
            else:
                raise RuntimeError("HODLR GP is only compatible with Matern32 kernel right now.")
            surrogate_f = hodlr.GP(kernel=final_kernel)
        elif surrogate_type == "randomforest":
            import RandomForest
            surrogate_f = RandomForest.RandomForestRegressor2(n_estimators=100)
        elif surrogate_type.startswith("pymc3"):
            import pymc3_models
            pymc3_models.init_module(surrogate_type)
            if surrogate_type == "pymc3gp":
                surrogate_f = pymc3_models.SimpleGP(y.shape[1])
            elif surrogate_type == "pymc3linear":
                surrogate_f = pymc3_models.LinearRegression(num_samples_fit=10, num_tune_iter=10,
                                                            num_samples_predict=100, progressbar=False,
                                                            previous_trace=previous_trace)
            elif surrogate_type.startswith("pymc3nn"):
                num_layers = surrogate_type[7:]
                if num_layers:
                    num_layers = int(num_layers)
                else:
                    num_layers = 0
                surrogate_f = pymc3_models.NeuralNet(progressbar=False, n_layers=num_layers, hidden_size=X.shape[1],
                                                     num_fit_iter=100000,
                                                     num_samples_fit=100, num_tune_iter=100,
                                                     num_samples_predict=100)
            else:
                raise RuntimeError("Unknown surrogate type " + surrogate_type)

        else:
            raise RuntimeError("Unknown surrogate type " + surrogate_type)

        if use_hint:
            X_augmented = np.vstack((np.hstack((known_inputs, np.zeros((known_inputs.shape[0], 1)))),
                                     np.hstack((X[hint_idx_to_use, :], np.ones((len(hint_idx_to_use), 1))))))
            Y_augmented = np.vstack((np.hstack((known_outputs_modified, np.zeros((known_inputs.shape[0], 1)))),
                                     np.hstack(
                                         (y_hint[hint_idx_to_use, :], np.ones((len(hint_idx_to_use), 1))))))

            surrogate_f.fit(X_augmented, Y_augmented)

            X_predict = np.hstack((X, np.zeros((X.shape[0], 1))))
        else:
            surrogate_f.fit(known_inputs, known_outputs_modified)
            X_predict = X

        ypredict, ypredict_std = surrogate_f.predict(X_predict, return_std=True)


        if ypredict.shape[1] > y.shape[1]:
            ypredict = ypredict[:, :-1]
    
    if ypredict_std.ndim > 1: ypredict_std = np.squeeze(ypredict_std)
    if ypredict_std.ndim < 1: ypredict_std = np.array([ypredict_std])



    if queue is not None:
        queue.put(ypredict)
        queue.put(ypredict_std)
        queue.put(surrogate_f if not surrogate_type.startswith("rbf") else None)

    return ypredict, ypredict_std, surrogate_f






class Sherlock:

    def __init__(self,
                 n_init=5,
                 budget=None,
                 surrogate_type="rbfthin_plate",
                 kernel="matern",
                 num_restarts=0,
                 pareto_margin=0,
                 y_hint=None,
                 output_stats="",
                 output_filename=None,
                 plot_design_space=False,
                 use_ted_in_loop=False,
                 request_output=lambda y, idx: None,
                 action_only=None,
                 scale_output=False,
                 n_hint_init=0,
                 use_trace_as_prior=True,
                 model_selection_type="mab10",
                 ):
        self.n_init = n_init
        self.budget = budget
        self.surrogate_type = surrogate_type
        self.kernel = kernel
        self.num_restarts = num_restarts
        self.pareto_margin = pareto_margin
        self.y_hint = y_hint
        if self.y_hint is not None:
            self.y_hint = self.y_hint.copy()
            self.y_hint = np.nan_to_num(self.y_hint)
        self.output_stats = output_stats
        self.output_filename = output_filename
        self.plot_design_space = plot_design_space
        self.use_ted_in_loop = use_ted_in_loop
        self.request_output = request_output
        self.action_only = action_only
        self.do_scale_output = scale_output
        self.n_hint_init = n_hint_init
        self.models = self.surrogate_type.split("-")
        self.use_trace_as_prior = use_trace_as_prior
        self.model_selection_type = model_selection_type
        self.pool = mp.Pool()


    def fit(self, X):

        # Initial sampling
        self.known_idx, self.ted_scale = TED().fit(X).predict(self.n_init, return_scale=True)

        return self


    def predict(self, X, y, input_known_idx=None):

        # Import optional libs
        if self.plot_design_space:
            try:
                import matplotlib.pyplot as plt
                from mpl_toolkits.mplot3d import axes3d
                from IPython import display
            except:
                logger.warning("Plotting libraries not found!")
                self.plot_design_space = False
            plot_dcor = False
            try:
                import dcor
                plot_dcor = True
            except: pass

        self.traces = [None] * len(self.models)

        if "dcor" in self.output_stats or "model" in self.output_stats:
            import dcor
            from dcor._dcor_internals import _distance_matrix
            import scipy.cluster.hierarchy as sch
            from sklearn.cluster import KMeans
        

        # Known indexes at start
        known_idx = self.known_idx

        if self.y_hint is not None and self.n_hint_init > 0:
            hint_pareto, hint_pareto_idx, hint_pareto_scores = approximate_pareto(self.y_hint)
            known_idx = np.union1d(known_idx, hint_pareto_idx[np.argsort(hint_pareto_scores)[-self.n_hint_init:]])

        if input_known_idx is not None:
            known_idx = np.union1d(known_idx, input_known_idx)
            self.known_idx = known_idx

        # Request output values of known indexes
        self.request_output(y, known_idx)
        known_inputs = X[known_idx, :]
        known_outputs = y[known_idx, :].__array__()


        do_center_output = self.surrogate_type == "gphodlr"
        if do_center_output:
            current_output_mean = known_outputs.mean(axis=0)
        else:
            current_output_mean = 0
        known_outputs_modified = known_outputs - current_output_mean

        if self.do_scale_output:
            output_scaling_factor = known_outputs.std(axis=0)
            if np.any(output_scaling_factor <= 0): output_scaling_factor = [1.0] * y.shape[1]
        else:
            output_scaling_factor = [1.0] * y.shape[1]
        known_outputs_modified = known_outputs_modified / output_scaling_factor


        # Define possible actions
        action_list = ["exploit", "explore"]
        if self.use_ted_in_loop:
            action_list.append("expand")

        # Starting action
        action_idx = action_list.index("exploit")

        if self.action_only is not None:
            action_list = [self.action_only]
            action_idx = 0


        if self.budget is None:
            self.budget = int(np.ceil(X.shape[0] * .31))
        self.budget = min(self.budget, X.shape[0])


        if self.plot_design_space:
            fig = plt.figure()
            if X.shape[1] == 2 and y.shape[1] == 1:
                ax = fig.gca(projection='3d')
            else:
                ax = fig.gca()



        if "adrs" in self.output_stats:
            n_known = len(known_idx)
            adrs_start_i = adrs(y, known_idx, approximate=True)

        if self.output_filename:
            output_file = open(self.output_filename, 'at')


        ypredict = None
        ypredict_std = None


        score_all_models        = np.zeros((self.budget,len(self.models)))
        score_smooth_all_models = np.zeros((self.budget,len(self.models)))

        previous_hv = None

        model_idx = 0
        model_weights = np.ones(len(self.models))
        model_score_factor = 0.5

        if self.model_selection_type.startswith("mab"):
            factor = 1
            boltzmann = False
            if self.model_selection_type.startswith("mabboltzmann"):
                str_len = 12
                boltzmann = True
            else:
                str_len = 3
            if len(self.model_selection_type) > str_len:
                factor = float(self.model_selection_type[str_len:])

            bandits = MultiArmedBandit(len(self.models), factor, boltzmann=boltzmann)

        if "time" in self.output_stats:
            from timeit import default_timer as timer
            time = timer()

        start_i = len(known_idx)
        i_sample = start_i-1

        ##################
        # Active learning
        ##################
        while len(known_idx) < self.budget:
            i_sample += 1

            unknown_mask = np.ones(X.shape[0], np.bool)
            unknown_mask[known_idx] = 0
            X_mysterious = X[unknown_mask, :]
            y_mysterious = y[unknown_mask, :]


            ## Surrogate model

            train_idx = np.arange(known_outputs_modified.shape[0])


            queues = [mp.SimpleQueue() for _ in self.models]
            jobs = [mp.Process(target=model_predict, args=(X, y, self.y_hint,
                                                           model, self.kernel, self.num_restarts, self.ted_scale,
                                                           known_inputs[train_idx], known_outputs_modified[train_idx],
                                                           trace if self.use_trace_as_prior else None, queue))
                    for model,trace,queue in zip(self.models, self.traces, queues)]

            for j in jobs:
                j.start()

            ypredict_all     = [q.get() for q in queues]
            ypredict_std_all = [q.get() for q in queues]
            surrogate_all    = [q.get() for q in queues]

            for j in jobs:
                j.join()


            for i, model_name in enumerate(self.models):
                if model_name.startswith('pymc3'):
                    self.traces[i] = surrogate_all[i].trace




            ## Calculate Pareto score
            pareto_margin = 1e-9 if self.pareto_margin==0 else self.pareto_margin

            pareto_models            = [approximate_pareto(ypredict_i, margin=pareto_margin) for ypredict_i in ypredict_all]
            pareto_hypothesis_models = [approximate_pareto(ypredict_i[unknown_mask], margin=pareto_margin) for ypredict_i in ypredict_all]


            # This is computed only to gather statistics
            hypervol_models = [hypervolume(-ypredict_pareto_i[np.all(ypredict_pareto_i >= 0, axis=1)]).compute(np.zeros(ypredict_pareto_i.shape[1])) for ypredict_pareto_i,_,_ in pareto_models]

            # This is the actual hypervolume of the known data
            current_hv = hypervolume(-known_outputs[np.all(known_outputs >= 0, axis=1)]).compute(np.zeros(known_outputs.shape[1]))


            score_all_models[i_sample,:] = [np.max(ypredict_pareto_scores_i) for _,_,ypredict_pareto_scores_i in pareto_models]
            score_smooth_all_models[i_sample,:] = score_all_models[i_sample-5:,:].mean(axis=0)



            ## Choose model based on best improvement

            if self.model_selection_type.startswith("mab"):
                if previous_hv is not None:
                    bandits.update_posterior(current_hv > previous_hv)

                model_idx = bandits.choose_bandit()

                model_weights = bandits.get_empirical_probs()


            else:

                exploit_to_explore = (action_list[action_idx] == "exploit" and score_smooth_all_models[i_sample - 1, model_idx] > score_smooth_all_models[i_sample, model_idx])


                if self.model_selection_type != "no_exploit_to_explore" or not exploit_to_explore:
                    probs = model_weights / np.sum(model_weights)
                    model_idx = np.random.choice(len(self.models), p=probs)

                if previous_hv is not None:
                    if current_hv <= previous_hv:
                        pass
                    else:
                        if self.model_selection_type != 'random':
                            model_weights[model_idx] += model_score_factor
                            model_score_factor *= 1 + 100 / X.shape[0]


            previous_hv = current_hv


            ypredict_pareto, ypredict_pareto_idx, ypredict_pareto_scores          = pareto_models[model_idx]
            hyptothesis_pareto, hyptothesis_pareto_idx, hyptothesis_pareto_scores = pareto_hypothesis_models[model_idx]

            ypredict, ypredict_std = ypredict_all[model_idx], ypredict_std_all[model_idx]

            unknown_output_predictions = ypredict_all[model_idx][unknown_mask]
            p_std                      = ypredict_std_all[model_idx][unknown_mask]




            ## Choose next action: Markov descision rule with assumption that diminishing returns are very bad

            if score_smooth_all_models[i_sample-1,model_idx] > score_smooth_all_models[i_sample,model_idx]:
                action_idx = (action_idx + 1) % len(action_list)



            if action_list[action_idx] == "explore":
                # Select based on maximum uncertainty. Improves the model wrt the Pareto front
                # Note: similar to "On Learning-Based Methods for Design-Space Exploration with High-Level Synthesis" criteria
                new_samples = [hyptothesis_pareto_idx[np.argmax(p_std[hyptothesis_pareto_idx])]]
            elif action_list[action_idx] == "explore_all":
                new_samples = [np.argmax(p_std)]
            elif action_list[action_idx] == "exploit":
                # Select based on Pareto dominance. This pushes the hypervolume aggressively based on the model
                # Note: similar to PoI criteria of "Multiobjective Optimization on a Limited Budget of Evaluations Using Model-Assisted S-Metric Selection"
                new_samples = [hyptothesis_pareto_idx[np.argmax(hyptothesis_pareto_scores)]]
            elif action_list[action_idx] == "expand":
                # Just TED the next point
                new_samples = [TED().fit(X_mysterious).predict(1)]
            else:
                raise ValueError("Unknown action: " + str(action_list[action_idx]))

            sample_idx = np.where(unknown_mask)[0][new_samples]



            ## Add a new point to the known set
            known_idx = np.r_[known_idx, sample_idx]
            self.known_idx = known_idx
            known_inputs = np.r_[known_inputs, X[sample_idx, :]]

            ## Query the label for the new data point
            self.request_output(y, sample_idx)
            known_outputs = np.r_[known_outputs, y[sample_idx, :].__array__()]

            # Center/scale output data
            if do_center_output:
                current_output_mean = known_outputs.mean(axis=0)
            else:
                current_output_mean = 0
            known_outputs_modified = known_outputs - current_output_mean

            known_outputs_modified = known_outputs_modified / output_scaling_factor

            # Set hypothesis pareto idx back to global idx
            hyptothesis_pareto_idx = np.where(unknown_mask)[0][hyptothesis_pareto_idx]


            ###### Plotting/printout only below

            unknown_output_predictions += current_output_mean  # For plotting
            unknown_output_predictions *= output_scaling_factor

            ypredict += current_output_mean  # For plotting
            ypredict *= output_scaling_factor


            if self.output_stats:
                str_to_print = ""

                n_known = len(known_idx)
                header_to_print = "n,%"
                firstline_to_print = str(start_i) + ',' + str(start_i / X.shape[0])
                str_to_print += str(n_known) + ',' + str(n_known / X.shape[0])

                
                for stat in self.output_stats.split(','):

                    if stat == "adrs":
                        err = adrs(y, known_idx, approximate=True)
                        str_to_print += ',' + str(err)
                        if i_sample == start_i:
                            firstline_to_print += ',' + str(adrs_start_i)
                            header_to_print += ',adrs'

                    if stat == "adrs_predict":
                        ypredict_pareto, ypredict_pareto_idx, ypredict_pareto_scores = approximate_pareto(ypredict, margin=0.0)
                        err = adrs(y, ypredict_pareto_idx, approximate=True)
                        str_to_print += ',' + str(err)
                        if i_sample == start_i:
                            firstline_to_print += ','
                            header_to_print += ',adrs_predict'

                    if stat == "hypervolume":
                        hv2 = hypervolume(-known_outputs[np.all(known_outputs >= 0, axis=1)]).compute(np.zeros(known_outputs.shape[1]))
                        str_to_print += ',' + str(hv2)
                        if i_sample == start_i:
                            firstline_to_print += ','
                            header_to_print += ',hypervolume_known'

                    if stat == "dcor":
                        with warnings.catch_warnings():
                            warnings.simplefilter("ignore")
                            dcor_y_ypredict = dcor.u_distance_correlation_sqr(y, ypredict)
                            str_to_print += "," + str(dcor_y_ypredict)
                        if i_sample == start_i:
                            firstline_to_print += ','
                            header_to_print += ',dcor_y_ypredict'

                    if stat == "entropy":
                        for j in range(y_mysterious.shape[1]):
                            offset = max(-y_mysterious[:, j].min(), -unknown_output_predictions[:, j].min()) + 0.001
                            str_to_print += "," + str(entropy(y_mysterious[:, j] + offset, unknown_output_predictions[:, j] + offset))
                        if i_sample == start_i:
                            firstline_to_print += ','
                            header_to_print += ',' + ','.join(['entropy' + str(j) for j in range(y_mysterious.shape[1])])

                    if stat == "dcor_energy":
                        with warnings.catch_warnings():
                            warnings.simplefilter("ignore")
                            str_to_print += "," + str(dcor.energy_distance(y, ypredict))
                        if i_sample == start_i:
                            firstline_to_print += ','
                            header_to_print += ',energy'

                    if stat == "pareto_score":
                        str_to_print += "," + str(score_all_models[i_sample,model_idx])
                        if i_sample == start_i:
                            firstline_to_print += ','
                            header_to_print += ',pareto_score'

                    if stat == "next_action":
                        str_to_print += "," + str(action_list[action_idx])
                        if i_sample == start_i:
                            firstline_to_print += ','
                            header_to_print += ',next_action'

                    if stat == "std":
                        str_to_print += "," + str(np.max(p_std)) + "," + str(np.min(p_std[hyptothesis_pareto_idx])) + "," + str(np.max(p_std[hyptothesis_pareto_idx])) + "," + str(np.sum(p_std))
                        if i_sample == start_i:
                            firstline_to_print += ',,,,'
                            header_to_print += ',max_std,min_std_pareto,max_std_pareto,total_std'

                    if stat == "scale":
                        str_to_print += "," + str(current_output_mean) + "," + str(output_scaling_factor)
                        if i_sample == start_i:
                            firstline_to_print += ',,'
                            header_to_print += ',shift,scale'

                    if stat == "time":
                        newtime = timer()
                        str_to_print += "," + str(newtime - time)
                        time = newtime
                        if i_sample == start_i:
                            firstline_to_print += ','
                            header_to_print += ',timer'

                    if stat == "model":
                        hyp_max_std = []
                        for i in range(len(self.models)):
                            p_std_i = ypredict_std_all[i][unknown_mask]
                            _, hyptothesis_pareto_idx_i, _ = pareto_hypothesis_models[i]
                            hyp_max_std.append(np.max(p_std_i[hyptothesis_pareto_idx_i]))

                        adrs_predict_models = [str(adrs(y, approximate_pareto(yp, margin=0.0)[1], approximate=True)) for yp in ypredict_all]

                        with warnings.catch_warnings():
                            warnings.simplefilter("ignore")
                            dcor_y_ypredict_models = [str(dcor.u_distance_correlation_sqr(y, yp)) for yp in ypredict_all]

                        str_to_print += "," + str(model_idx) + \
                                        "," + ",".join([str(score) for score in score_all_models[i_sample,:]]) + \
                                        "," + ",".join([str(hv) for hv in hypervol_models]) + \
                                        "," + ",".join([str(std) for std in hyp_max_std]) + \
                                        "," + ",".join(adrs_predict_models) + \
                                        "," + ",".join(dcor_y_ypredict_models) + \
                                        "," + ",".join(list(map(str, model_weights)))
                        if i_sample == start_i:
                            firstline_to_print += "," + "," * len(self.models)*6
                            header_to_print += "," + "model_idx" + \
                                               "," + ",".join([model+"_score" for model in self.models]) + \
                                               "," + ",".join([model+"_hypervolume" for model in self.models]) + \
                                               "," + ",".join([model+"_maxstd" for model in self.models]) + \
                                               "," + ",".join([model+"_adrspredict" for model in self.models]) + \
                                               "," + ",".join([model+"_dcor_y_ypred" for model in self.models]) + \
                                               "," + ",".join([model+"_weight" for model in self.models])



                if i_sample == start_i:
                    if self.output_filename:
                        output_file.write(header_to_print + "\n")
                        output_file.write(firstline_to_print + "\n")
                        output_file.flush()
                    else:
                        print(header_to_print)
                        print(firstline_to_print)
                        sys.stdout.flush()
                if str_to_print:
                    if self.output_filename:
                        output_file.write(str_to_print + "\n")
                        output_file.flush()
                    else:
                        print(str_to_print)
                        sys.stdout.flush()


            if self.plot_design_space:
                ax.clear()
                if np.isnan(y).any():
                    err = -1
                    err_pred = -1
                else:
                    err = adrs(y, known_idx, approximate=True)
                    err_pred = adrs(y, approximate_pareto(ypredict)[1], approximate=True)

                dcor_y_ypredict = -1

                # Pareto front of known points
                kpareto, kpareto_idx, _ = approximate_pareto(known_outputs)

                if X.shape[1] == 1 and y.shape[1] == 1:
                    # True output space
                    ax.scatter(X[:, 0], y[:, 0], c=(0.8, 0.8, 0.8), marker='o', facecolor='none')
                    ax.text(0.3, 0.3, str(round(100 * i_sample / X.shape[0])) + '% ' + str(err), horizontalalignment='center', verticalalignment='center', transform=ax.transAxes)
                    ax.scatter(X_mysterious, unknown_output_predictions[:, 0], c=p_std, marker='.')
                    ax.scatter(known_inputs, known_outputs[:, 0], c='orange', marker='^')
                    ax.scatter(known_inputs[kpareto_idx], kpareto[:, 0], c='red')
                elif X.shape[1] == 2 and y.shape[1] == 1:
                    # True output space
                    ax.scatter(X[:, 0], X[:, 1], y[:, 0], c=(0.8, 0.8, 0.8), marker='o', facecolor='none')
                    ax.scatter(X_mysterious[:, 0], X_mysterious[:, 1], unknown_output_predictions[:, 0], c=p_std, marker='.')
                    ax.scatter(known_inputs[:, 0], known_inputs[:, 1], known_outputs, c='orange', marker='^')
                    ax.scatter(known_inputs[kpareto_idx, 0], known_inputs[kpareto_idx, 1], kpareto, c='red')
                elif y.shape[1] == 2:
                    # True output space
                    ax.scatter(y[:, 0], y[:, 1], c=(0.8, 0.8, 0.8), marker='o', facecolor='none', label='Unknown designs')

                    # ax.scatter(avg_predictions[:, 0], avg_predictions[:, 1], marker='.')

                    if plot_dcor:
                        with warnings.catch_warnings():
                            warnings.simplefilter("ignore")
                            dcor_y_ypredict = dcor.u_distance_correlation_sqr(y[unknown_mask], unknown_output_predictions)


                    ax.text(-0.001, -0.1,
                            '{:.1%}'.format(len(known_idx) / X.shape[0])
                            + ' ADRS: ' + str(err)
                            + ' ADRS pred: ' + str(err_pred)
                            + ' dcor: {:.2f}'.format(dcor_y_ypredict)
                            + ' score: {:.2f}'.format(score_all_models[i_sample,model_idx])
                            + ' ' + self.models[model_idx]
                            + ' next: ' + action_list[action_idx]
                            + ' model_rel_weight: ' + str(list(map(int,100*model_weights/np.sum(model_weights)))) + "%",
                            horizontalalignment='center', verticalalignment='center', transform=ax.transAxes)
                    # Predicitions, colored by model standard deviation
                    ax.scatter(ypredict[:,0], ypredict[:,1], c=ypredict_std, marker='.')

                    # Known (sampled) points
                    ax.scatter(known_outputs[:, 0], known_outputs[:, 1], c='blue', marker='^', label='Sampled designs')
                    ax.scatter(kpareto[:, 0], kpareto[:, 1], c='red', label='Pareto optimal designs')
                    ax.legend(bbox_to_anchor=(1.05, 1.05))
                    ax.set_xlim(y[:, 0].min(), y[:, 0].max())
                    ax.set_ylim(y[:, 1].min(), y[:, 1].max())
                else:
                    raise ValueError('Too many dimensions to plot. Plotting n_targets > 2 not implemented.')

                # Update scatter plot
                display.display(plt.gcf())
                display.clear_output(wait=True)

            # Seems to help with some memory issues
            gc.collect(2)


            ######

        return known_inputs, known_outputs, known_idx



