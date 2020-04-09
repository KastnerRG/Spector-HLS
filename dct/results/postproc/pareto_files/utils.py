
import numpy as np
import os
import pareto



def compute_scores(y, rows, margin=0):
    ndrange = np.ptp(y, axis=0) * margin
    total_sum = np.sum(y, axis=0)
    nrows = y.shape[0]
    scores = np.empty(len(rows), dtype=np.float)
    for i, r in enumerate(rows):
        scores[i] = np.sum(r * nrows - total_sum + ndrange * (nrows - 1))
    return scores


def approximate_pareto(y, epsilons=None, margin=0):
    """
    Uses pareto.py from https://github.com/matthewjwoodruff/pareto.py
    Returns the same data as prpt.
    """
    tagalongs = np.array(pareto.eps_sort(y, epsilons=epsilons, maximize_all=True, attribution=True))
    pareto_solutions = tagalongs[:, :y.shape[1]]
    pareto_idx = tagalongs[:, y.shape[1] + 1].astype(int)
    if margin > 0:
        miny = np.min(y, axis=0)
        ptp = pareto_solutions - miny
        margin = ptp * margin
        pareto_idx = range(y.shape[0])
        for s, m in zip(pareto_solutions, margin):
            pareto_idx = np.intersect1d(pareto_idx, np.where(np.any(y >= s - m, axis=1))[0], assume_unique=True)
        pareto_solutions = y[pareto_idx, :]
    pareto_scores = compute_scores(y, pareto_solutions)
    return pareto_solutions, pareto_idx, pareto_scores


def prpt(y, margin=0, strict=True):
    """
    Get Pareto optimal set of points in y with optional margin
    Return Pareto points, their indexes, and the "dominance" sum
    strict == False replaces > with >= (i.e. actual Pareto points with convex hull in the "good" direction)
    """
    # So we can get a group that is margin-percent-close to the Pareto front
    ndrange = np.ptp(y, axis=0)
    margin = ndrange * margin

    kk = np.zeros(y.shape[0])
    score = np.zeros(y.shape[0])
    c = np.zeros(y.shape)
    bb = np.zeros(y.shape)

    jj = 0

    if not strict:
        cmp = lambda x1, x2: x1 >= x2
    else:
        cmp = lambda x1, x2: x1 > x2

    for k in range(y.shape[0]):
        j = 0
        ak = y[k, :]  # Get k-th output datum
        for i in range(y.shape[0]):
            if i != k:
                bb[j, :] = ak - y[i, :] + margin
                j += 1

        if np.all(np.any(cmp(bb[:j, :], 0), axis=1)):
            c[jj, :] = ak
            kk[jj] = k
            score[jj] = np.sum(bb[:j, :])
            jj += 1

    pareto_values = c[:jj, :]
    pareto_idx = kk[:jj].astype(int)
    score = score[:jj]

    return pareto_values, pareto_idx, score


def drs(allDesigns, sampledIndexes, accumFunc, approximate=False):
    """
    Calculate the distances to reference set.
    Accumulate the distances using the given function: (numpy_1d_array -> result)
    """

    # Get ground truth and estimated Pareto designs

    sampledDesigns = allDesigns[sampledIndexes]

    if approximate:
        paretoGt = approximate_pareto(allDesigns)[0]
        paretoEst = approximate_pareto(sampledDesigns)[0]
    else:
        paretoGt = prpt(allDesigns)[0]
        paretoEst = prpt(sampledDesigns)[0]

    # Calculate the ADRS

    # Note: The sign is flipped compared to the paper because
    #       we consider that higher is better for design outputs
    #       (in the paper, lower is better)

    distances = np.empty(len(paretoGt))

    for i, x_r in enumerate(paretoGt):
        distances[i] = np.min(np.maximum(np.max((x_r - paretoEst) / x_r, 1), 0.0))

    return accumFunc(distances)


def adrs(allDesigns, sampledIndexes, approximate=False):
    return drs(allDesigns, sampledIndexes, np.mean, approximate)



def read_design_space(
        fn,
        random_factor=0.0,
        use_hint=False,
        hint_type="gpu",
        hint_random_factor=0.0,
        mult_factor=None,
        hint_mult_factor=None,
        return_names=False):

    extension = os.path.splitext(fn)[1].lower()

    hint_type = hint_type.lower()

    X  = None
    y  = None
    yh = None
    names = None
    types = None

    if extension == ".mat":
        from scipy import io

        tmp = io.loadmat(fn)
        X = tmp['knob_settings']
        t = 1 / tmp['run_results_timing'] # 10
        #     t /= np.max(t)
        l = 1 / tmp['logic_util'] # 10000000 # 100000
        #     l /= np.max(l)
        y = np.c_[t, l]

        if mult_factor is None:
            # mult_factor = [10, 10000000]
            mult_factor = [1, 1]

        y *= mult_factor

        if random_factor > 0.0:
            ynoise = np.random.normal(scale=random_factor * y.std(axis=0), size=y.shape)
            y += ynoise - ynoise.min(axis=0)

        if use_hint:
            gpu_filename   = fn[:-4] + '_wGPU_k20c.mat'
            esttp_filename = fn[:-4] + '_est_tp.mat'
            try: gpu = io.loadmat(gpu_filename)
            except: gpu = tmp
            try: esttp = io.loadmat(esttp_filename)
            except: esttp = tmp

            if hint_type == "gpu":
                th = 1 / gpu['run_results_timing_k20c']
            elif hint_type == "esttp":
                th = 1 / esttp['run_results_timing_esp_tp']
            elif hint_type == "cpu":
                th = 1 / tmp['time_cpu']
            elif hint_type == "random":
                th = np.random.rand(len(t))
                lh = np.random.rand(len(l))
            else:
                raise RuntimeError("Type of hint unknown: " + hint_type)

            if hint_type != "random":
                if 'logic_util_synth_report' in tmp: logic_estim = tmp
                else: logic_estim = gpu
                lh = 1 / logic_estim['logic_util_synth_report']

            yh = np.c_[th, lh]

            if hint_mult_factor is None:
                hint_mult_factor = [10, 10000]
                if hint_type == "random": hint_mult_factor = [1,1]

            yh *= hint_mult_factor

            if hint_random_factor > 0.0:
                yhnoise = np.random.normal(scale=hint_random_factor * yh.std(axis=0), size=yh.shape)
                yh += yhnoise - yhnoise.min(axis=0)

        if return_names:
            if 'knob_names' in tmp:
                names = [cell[0] for cell in tmp['knob_names'].flatten()]
            else:
                names = ['knob_' + str(i) for i in range(X.shape[1])]
            names += ['Time', 'Logic']
            if 'knob_types' in tmp:
                types = [cell[0] for cell in tmp['knob_types'].flatten()]
            else:
                types = ['ordinal'] * X.shape[1]

        # y -= (np.nanmin(y) - 0.001)


    elif extension == ".csv":
        import pandas

        df = pandas.read_csv(fn)

        # Objectives by order of priority
        obj1 = ["time", "tp", "obj1"]
        obj2 = ["logic", "error", "fn", "fp", "obj2"]

        for o in obj1:
            if o in df:
                obj1 = o
                break
        for o in obj2:
            if o in df:
                obj2 = o
                break

        names = [col for col in df if col.startswith('knob') or col.startswith('param')]

        X = df[names].values
        y = np.c_[1/df[obj1], 1/df[obj2]]

        y[np.abs(y) == np.inf] = 0

        names += [obj1, obj2]
        types = ['ordinal'] * X.shape[1]

        if random_factor > 0.0:
            ynoise = np.random.normal(scale=random_factor * y.std(axis=0), size=y.shape)
            y += ynoise - ynoise.min(axis=0)

        if mult_factor is None:
            mult_factor = [1, 1]

        y *= mult_factor


        yh = None

        hint_obj1 = "hint_" + obj1
        hint_obj2 = "hint_" + obj2

        if use_hint:
            yh = np.c_[1/df[hint_obj1], 1/df[hint_obj2]]

            yh[np.abs(yh) == np.inf] = 0

            if hint_mult_factor is None:
                hint_mult_factor = [1, 1]

            yh *= hint_mult_factor

            if hint_random_factor > 0.0:
                yhnoise = np.random.normal(scale=hint_random_factor * yh.std(axis=0), size=yh.shape)
                yh += yhnoise - yhnoise.min(axis=0)

        if hint_type == "random":
            yh = np.random.random(y.shape)

        # y -= (np.nanmin(y) - 0.001)


        ######### TEMP
        #y[:,0] *= 10
        #if use_hint: yh[:,0] *= 10
        #########

    else:
        raise RuntimeError("Input file extension not valid")
    
    if return_names:
        return X, y, yh, names, types
    else:
        return X, y, yh



def dcor_pval(dcor, x, y, nruns=500):

    dcor_value = dcor.u_distance_correlation_sqr(x, y)

    greater = 0
    for i in range(nruns):
        y_r = np.copy(y)
        np.random.shuffle(y_r)
        dcor_value_r = dcor.u_distance_correlation_sqr(x, y_r)
        if np.abs(dcor_value_r) >= np.abs(dcor_value):
            greater += 1

    return dcor_value, greater / float(nruns)
