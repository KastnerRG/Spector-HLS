from sklearn.ensemble import RandomForestRegressor
from sklearn.utils.validation import check_is_fitted
from sklearn.externals.joblib import Parallel, delayed
from sklearn.ensemble.base import BaseEstimator, _partition_estimators
import threading
import numpy as np

class RandomForestRegressor2(RandomForestRegressor):

    def __init__(self,
                 n_estimators=10,
                 criterion="mse",
                 max_depth=None,
                 min_samples_split=2,
                 min_samples_leaf=1,
                 min_weight_fraction_leaf=0.,
                 max_features="auto",
                 max_leaf_nodes=None,
                 min_impurity_decrease=0.,
                 min_impurity_split=None,
                 bootstrap=True,
                 oob_score=False,
                 n_jobs=1,
                 random_state=None,
                 verbose=0,
                 warm_start=False):
        super(RandomForestRegressor2, self).__init__(
            n_estimators,
            criterion,
            max_depth,
            min_samples_split,
            min_samples_leaf,
            min_weight_fraction_leaf,
            max_features,
            max_leaf_nodes,
            min_impurity_decrease,
            min_impurity_split,
            bootstrap,
            oob_score,
            n_jobs,
            random_state,
            verbose,
            warm_start)

    def predict(self, X, return_std=False):
        if return_std:

            check_is_fitted(self, 'estimators_')

            # Check data
            X = self._validate_X_predict(X)

            # Assign chunk of trees to jobs
            n_jobs, _, _ = _partition_estimators(self.n_estimators, self.n_jobs)

            # if self.n_outputs_ > 1:
            #     y_pred = np.zeros((self.n_estimators, X.shape[0], self.n_outputs_), dtype=np.float64)
            # else:
            #     y_pred = np.zeros((self.n_estimators, X.shape[0]), dtype=np.float64)

            # Parallel loop
            # lock = self.threading.Lock()
            y_pred = np.array(Parallel(n_jobs=n_jobs, verbose=self.verbose, backend="threading")(
                delayed(e.predict)(X) for e in self.estimators_))

            # y_hat /= len(self.estimators_)

            ypred_mean = np.mean(y_pred, axis=0)
            ypred_std  = np.std(y_pred, axis=0)

            if len(ypred_std.shape) > 1:
                ypred_std = np.max(ypred_std, 1)

            return ypred_mean, ypred_std



        else:
            return super(RandomForestRegressor2, self).predict(X)
