


def init_module(model_name='model'):
    import os

    # I tried, but it doesn't work...
    # os.environ['THEANO_FLAGS'] = 'base_compiledir=~/.theano/' + model_name + str(os.getppid())
    # print(os.environ['THEANO_FLAGS'])

    from importlib import reload

    global pm
    import pymc3 as pm
    pm = reload(pm)

    global theano
    import theano
    theano = reload(theano)
    global floatX
    floatX = theano.config.floatX
    global T
    import theano.tensor as T

    global np
    import numpy as np
    global stats
    from scipy import stats
    global warnings
    import warnings

    pm._log.setLevel('CRITICAL')



class LinearRegression:

    def __init__(self, num_samples_fit=1000, num_tune_iter=500, advi_n_init=5000, num_samples_predict=1000, progressbar=False, previous_trace=None):
        self.num_samples_fit     = num_samples_fit
        self.num_tune_iter       = num_tune_iter
        self.advi_n_init         = advi_n_init
        self.num_samples_predict = num_samples_predict
        self.progressbar         = progressbar
        self.previous_trace      = previous_trace

    def fit(self, X, y):
        self.X = theano.shared(X)
        
        self.model = pm.Model()

        # Make sure y is a 2D vector with 1 column per output
        if y.ndim < 2:
            y = np.atleast_2d(y).T

        with self.model:
            with warnings.catch_warnings():
                warnings.simplefilter("ignore", FutureWarning)
                warnings.simplefilter("ignore", UserWarning)

                #mu_a_init = 0.
                #mu_b_init = 0.

                #if self.previous_trace is not None:
                #    mu_a_init = self.previous_trace['mu_a'].mean(axis=0)
                #    mu_b_init = self.previous_trace['mu_b'].mean(axis=0)

                ## Hyperpriors for group nodes
                #mu_a    = pm.Normal('mu_a', mu=mu_a_init, sd=10000, shape=y.shape[1])
                #sigma_a = pm.HalfCauchy('sigma_a', 5, shape=y.shape[1])
                #mu_b    = pm.Normal('mu_b', mu=mu_b_init, sd=10000, shape=(X.shape[1],y.shape[1]))
                #sigma_b = pm.HalfCauchy('sigma_b', 5, shape=(X.shape[1],y.shape[1]))

                alpha_init = 0.
                beta_init  = 0.
                alpha_init_std = 10000.0
                beta_init_std  = 10000.0

                if self.previous_trace is not None:
                    alpha_init = self.previous_trace['alpha'].mean(axis=0)
                    beta_init  = self.previous_trace['beta'].mean(axis=0)
                    alpha_init_std = self.previous_trace['alpha'].std(axis=0) * 1.5
                    beta_init_std  = self.previous_trace['beta'].std(axis=0) * 1.5

                # Priors for unknown model parameters
                #alpha_d = pm.Normal('alpha', mu=mu_a, sd=sigma_a, shape=y.shape[1])
                #beta_d  = pm.Normal('beta', mu=mu_b, sd=sigma_b, shape=(X.shape[1],y.shape[1]))
                alpha_d = pm.Normal('alpha', mu=alpha_init, sd=alpha_init_std, shape=y.shape[1])
                beta_d  = pm.Normal('beta',  mu=beta_init,  sd=beta_init_std, shape=(X.shape[1],y.shape[1]))
                sigma_d = pm.HalfNormal('sigma', sd=10000)

                # Expected value of outcome
                mu_d = alpha_d + pm.math.dot(self.X, beta_d)

                # Likelihood (sampling distribution) of observations
                Y = pm.Normal('Y', mu=mu_d, sd=sigma_d, observed=y)

                #print("sample")
                self.trace = pm.sample(
                        self.num_samples_fit,
                        init='advi',
                        n_init=self.advi_n_init,
                        progressbar=self.progressbar,
                        cores=4,
                        tune=self.num_tune_iter)
    
    def predict(self, X, return_std=False):

        self.X.set_value(X)
        ppc = pm.sample_posterior_predictive(self.trace, model=self.model, samples=self.num_samples_predict, progressbar=self.progressbar)
        y   = ppc['Y'].mean(axis=0)
        std = ppc['Y'].std(axis=0)
        if return_std:
            if std.ndim > 1:
                std = std.mean(axis=1)
            return y, std
        else:
            return y

    #def update(self, X, y):
    #    self.model = Model()
    #    with model:
    #        # Priors are posteriors from previous iteration

    #        mu_a    = from_posterior('mu_a', self.trace['mu_a'])
    #        sigma_a = from_posterior('sigma_a', self.trace['sigma_a'])
    #        mu_b    = from_posterior('mu_b', self.trace['mu_b'])
    #        sigma_b = from_posterior('sigma_b', self.trace['sigma_b'])
    #            
    #        alpha_d = pm.Normal('alpha', mu=mu_a, sd=sigma_a, shape=y.shape[1])
    #        beta_d  = pm.Normal('beta', mu=mu_b, sd=sigma_b, shape=(X.shape[1],y.shape[1]))
    #        sigma_d = from_posterior('sigma_d', self.trace['sigma_d'])


    #        # Expected value of outcome
    #        mu_d = alpha_d + pm.math.dot(self.X, beta_d)

    #        # Likelihood (sampling distribution) of observations
    #        Y = pm.Normal('Y', mu=mu_d, sd=sigma_d, observed=y)

    #        # Draw posterior samples
    #        self.trace = pm.sample(self.num_samples_fit, progressbar=self.progressbar, cores=4, tune=self.num_tune_iter)


class SimpleGP:

    def __init__(self, n_out=1):
        self.n_out = n_out

    def fit(self, X, y):

        # Make sure y is a 2D vector with 1 column per output
        if y.ndim < 2:
            y = np.atleast_2d(y).T
        assert(y.shape[1] == self.n_out)


        with pm.Model() as model:
            with warnings.catch_warnings():
                warnings.simplefilter("ignore", FutureWarning)
                warnings.simplefilter("ignore", UserWarning)
                
                ls   = [pm.Gamma("l"+str(i), alpha=2, beta=1) for i in range(self.n_out)]
                #etas = [pm.HalfCauchy("eta"+str(i), beta=5) for i in range(self.n_out)]
                
                means = [pm.gp.mean.Constant(pm.Normal("gp_mu"+str(i), 1, 3)) for i in range(self.n_out)]
                #covs = [etas[i]**2 * pm.gp.cov.Matern52(X.shape[1], ls[i]) for i in range(self.n_out)]
                covs = [pm.gp.cov.Matern52(X.shape[1], ls[i]) for i in range(self.n_out)]
                
                self.gps = [pm.gp.Marginal(mean_func=means[i], cov_func=covs[i]) for i in range(self.n_out)]
                sigmas   = [pm.HalfCauchy("sigma" + str(i), beta=5) for i in range(self.n_out)]

                self.ys = [self.gps[i].marginal_likelihood("y"+str(i), X=X, y=y[:,i], noise=sigmas[i]) for i in range(self.n_out)]
                
                # "mp" stands for marginal posterior
                self.mp = pm.find_MAP(progressbar=False) # sample(1, njobs=1, progressbar=True) #


    def predict(self, X, return_std=False):
        y   = np.empty((X.shape[0], self.n_out))
        std = np.empty((X.shape[0], self.n_out))

        with warnings.catch_warnings():
            warnings.simplefilter("ignore", FutureWarning)
        
            for i in range(self.n_out):
                mu, var = self.gps[i].predict(X, point=self.mp, diag=True) #, pred_noise=True)
                sd = np.sqrt(var)
                y[:,i]   = mu
                std[:,i] = sd

        if return_std:
            return y, std.mean(axis=1)
        else:
            return y
       


class NeuralNet:

    def __init__(self, n_layers=2, hidden_size=5,
                 num_fit_iter=30000, # only when advi is not commented out
                 num_samples_fit=1000,
                 num_tune_iter=500,
                 num_samples_predict=1000,
                 progressbar=False,
                 previous_trace=None):
        self.n_layers = n_layers
        self.hidden_size = hidden_size
        self.num_fit_iter = num_fit_iter
        self.num_samples_fit = num_samples_fit
        self.num_tune_iter = num_tune_iter
        self.num_samples_predict = num_samples_predict
        self.progressbar = progressbar
        self.previous_trace = previous_trace


    def construct_regr_nn(nn_input, nn_output,
                          Xtrain, ytrain,
                          n_layers = 2,
                          hidden_size = 5,
                          previous_trace=None):

        if n_layers <= 0:
            hidden_size = Xtrain.shape[1]

        # Initialize random weights between each layer
        init_i = []
        for i in range(n_layers):
            if i == 0:
                init_i.append(np.random.randn(Xtrain.shape[1], hidden_size).astype(floatX))
            else:
                init_i.append(np.random.randn(hidden_size, hidden_size).astype(floatX))

        init_out = np.random.randn(hidden_size, ytrain.shape[1]).astype(floatX)

        # Initialize random biases in each layer
        init_b_i = [np.random.randn(hidden_size).astype(floatX) for _ in range(n_layers)]
        init_b_out = np.random.randn(ytrain.shape[1]).astype(floatX)

        weights_mu_init = [0. for _ in range(n_layers+1)]
        bias_mu_init    = [0. for _ in range(n_layers+1)]
        if previous_trace is not None:
            weights_mu_init = [previous_trace['w_'+str(i)+'_'+str(i+1)].mean(axis=0) for i in range(n_layers+1)]
            bias_mu_init    = [previous_trace['b_'+str(i+1)].mean(axis=0) for i in range(n_layers+1)]

        with pm.Model() as neural_network:
 
            # Weights from input to hidden layer
            # Weights from ith to jth layer
            weights_i_j = []
            bias_i      = []
            for i in range(n_layers):
                if i == 0:
                    weights_i_j.append( pm.Normal('w_0_1', mu=weights_mu_init[i], sd=10000,
                        shape=(Xtrain.shape[1], hidden_size),
                        testval=init_i[i]) )
                else:
                    weights_i_j.append( pm.Normal('w_'+str(i)+'_'+str(i+1), mu=weights_mu_init[i], sd=10000,
                        shape=(hidden_size, hidden_size),
                        testval=init_i[i]) )
                bias_i.append( pm.Normal('b_'+str(i+1), mu=bias_mu_init[i], sd=10000, shape=(hidden_size), testval=init_b_i[i]) )

            
            # Weights from hidden layer to output
            weights_j_out = pm.Normal('w_'+str(n_layers)+'_'+str(n_layers+1), mu=weights_mu_init[-1], sd=10000,
                                      shape=(hidden_size,ytrain.shape[1]),
                                      testval=init_out)

            bias_out = pm.Normal('b_'+str(n_layers+1), mu=bias_mu_init[-1], sd=10000, shape=(ytrain.shape[1]), testval=init_b_out)
            
            
            # Build neural-network using relu activation function
            
            act_i   = []
            for i in range(n_layers):
                if i == 0:
                    act_i.append(pm.math.maximum(0, pm.math.dot(nn_input, weights_i_j[i]) + bias_i[i]))
                else:
                    act_i.append(pm.math.maximum(0, pm.math.dot(act_i[i-1], weights_i_j[i]) + bias_i[i]))
            
            if len(act_i) == 0:
                act_i.append(nn_input)

            act_out = pm.math.dot(act_i[-1], weights_j_out) + bias_out

            sigma_d = pm.HalfNormal('sigma', sd=10000, shape=ytrain.shape[1])
            
            out = pm.Normal('out', mu=act_out, sd=sigma_d, observed=nn_output, total_size=ytrain.shape)
        
        return neural_network


    def fit(self, X, y):
        self.ann_input  = theano.shared(X)
        self.ann_output = theano.shared(y)
        self.neural_network = NeuralNet.construct_regr_nn( self.ann_input, self.ann_output, X, y, self.n_layers, self.hidden_size, self.previous_trace )

        with self.neural_network:
            with warnings.catch_warnings():
                warnings.simplefilter("ignore", FutureWarning)
                warnings.simplefilter("ignore", UserWarning)
            
                #self.inference = pm.ADVI()
                #tracker = pm.callbacks.Tracker(
                #        mean=self.inference.approx.mean.eval,  # callable that returns mean
                #        std=self.inference.approx.std.eval  # callable that returns std
                #        )
                #self.approx = pm.fit(n=self.num_fit_iter,
                #        method=self.inference,
                #        progressbar=self.progressbar,
                #        callbacks=[pm.callbacks.CheckParametersConvergence(diff='absolute',tolerance=0.001), tracker])
                #
                ##self.approx = pm.fit(300, method='svgd', inf_kwargs=dict(n_particles=1000), obj_optimizer=pm.sgd(learning_rate=0.01))

                #self.trace = self.approx.sample(draws=5000)

                self.trace = pm.sample(
                        self.num_samples_fit,
                        init='advi',
                        n_init=5000,
                        progressbar=self.progressbar,
                        cores=4,
                        tune=self.num_tune_iter)


    def predict(self, X, return_std=False):
        
        ## create symbolic input
        #x = T.matrix('X')
        ## symbolic number of samples is supported, we build vectorized posterior on the fly
        #n = T.iscalar('n')
        ## Do not forget test_values or set theano.config.compute_test_value = 'off'
        #x.tag.test_value = np.empty_like(X[:10])
        #n.tag.test_value = 100
        #
        #_sample_proba = self.approx.sample_node(
        #        self.neural_network.out.distribution.mu,
        #        size=n,
        #        more_replacements={self.ann_input: x})
        #
        #sample_proba = theano.function([x, n], _sample_proba)
        #
        #y = sample_proba(X, 500).mean(0)
        #y_std = sample_proba(X, 500).std(0)
        #
        #if return_std:
        #    return y, y_std.mean(axis=1) # Mean? or sqrt((sd1^2+sd2^2)/n)?
        #else:
        #    return y


        self.ann_input.set_value(X)
        ppc = pm.sample_posterior_predictive(self.trace, model=self.neural_network, samples=self.num_samples_predict, progressbar=self.progressbar)
        y   = ppc['out'].mean(axis=0)
        std = ppc['out'].std(axis=0)
        if return_std:
            if std.ndim > 1:
                std = std.mean(axis=1)
            return y, std
        else:
            return y



def test1():

    n = 500 # The number of data points
    # X = np.linspace(0, 10, n)[:, None] # The inputs to the GP, they must be arranged as a column vector
    X = np.random.rand(n, 2)
    
    # Define the true covariance function and its parameters
    l_true = 1.0
    eta_true = 3.0
    cov_func = eta_true**2 * pm.gp.cov.Matern52(X.shape[1], l_true)
    
    # A mean function that is zero everywhere
    mean_func = pm.gp.mean.Zero()
    
    # The latent function values are one sample from a multivariate normal
    # Note that we have to call `eval()` because PyMC3 built on top of Theano
    f_true = np.random.multivariate_normal(mean_func(X).eval(), cov_func(X).eval() + 1e-8*np.eye(n), 2).T
    
    # The observed data is the latent function plus a small amount of IID Gaussian noise
    # The standard deviation of the noise is `sigma`
    sigma_true = 1.0
    y = f_true + sigma_true * np.random.randn(n, 2)
    
    
    X_new = np.random.rand(600, X.shape[1]) * 1.0
    
    
    gp = SimpleGP(y.shape[1])
    print("fit")
    gp.fit(X, y)
    print("predict")
    ypred, ypred_std = gp.predict(X_new)
    
    print(ypred)
    print(ypred_std)


def test2():
    n = 500 # The number of data points
    # X = np.linspace(0, 10, n)[:, None] # The inputs to the GP, they must be arranged as a column vector
    X = np.random.rand(n, 2)
    
    y = X.dot([[2,3],[4,5]]) + 6 + np.random.random((X.shape[0],2))
    ynew = X_new.dot([[2,3],[4,5]]) + 6 + np.random.random((X_new.shape[0],2))
    model = LinearRegression(progressbar=True)
    model.fit(X, y)
    print([(n,model.trace[n].mean(axis=0)) for n in model.trace.varnames])
    ypred, std = model.predict(X_new, return_std=True)

    #print(std.shape)
    #print(std)

    plt.figure()
    plt.scatter(X_new[:,0], ynew[:,0])
    plt.scatter(X_new[:,0], ypred[:,0])
    plt.figure()
    plt.scatter(X_new[:,0], ynew[:,1])
    plt.scatter(X_new[:,0], ypred[:,1])
    plt.figure()
    plt.scatter(X_new[:,1], ynew[:,0])
    plt.scatter(X_new[:,1], ypred[:,0])
    plt.figure()
    plt.scatter(X_new[:,1], ynew[:,1])
    plt.scatter(X_new[:,1], ypred[:,1])
    plt.show()


def test3():

    Xtrain = np.random.rand(100,5)
    Xtest  = np.random.rand(100,5)
    
    beta = -np.random.rand(5,2)
    
    ytrain = Xtrain.dot(beta) + np.random.rand(100,2)*0.05
    ytest  = Xtest.dot(beta)

    model = NeuralNet(n_layers=0, hidden_size=5, num_fit_iter=30000, progressbar=True)
    model.fit(Xtrain, ytrain)
    ypred = model.predict(Xtest)

    plt.scatter(ypred[:,0], ypred[:,1])
    plt.scatter(ytest[:,0], ytest[:,1])
    plt.show()



if __name__ == "__main__":

    import matplotlib.pyplot as plt
    
    
    test3()


