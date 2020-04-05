import numpy as np
import scipy
import scipy.linalg as linalg
import scipy.spatial
import scipy.special
import scipy.optimize
import sklearn


def bases(name):
    if name == 'linear':
        f = lambda x: x
    elif name == 'cubic':
        f = lambda x: x**3
    elif name == 'multiquadric':
        f = lambda x, s: np.sqrt((1.0/s*x)**2 + 1)
    elif name == 'thin_plate':
        f = lambda x: scipy.special.xlogy(x**2, x)
    elif name == 'gaussian':
        f = lambda x, s: np.exp(-(1.0/s*x)**2)
    elif name == 'inverse_multiquadric':
        f = lambda x, s: 1.0/np.sqrt((1.0/s*x)**2 + 1)
    else:
        raise ValueError('Basis not recognised.')
        
    return f

class RbfInterpolator:
    """
    Standard RBF interpolation / kernel smoothing. 
    Written to replace Scipy's Rbf class, which has a silly interface and is difficult to modify
    Also includes optional optimization of the "smooth" parameter
    
    Author: Alric Althoff -- 2018
    """
    def __init__(self, norm='euclidean', rbf=lambda r: r, smooth=0.0, optimize_smoothing=False):
        self.norm = norm
        self.rbf = rbf
        self.smooth = smooth
        self.optimize_smoothing = optimize_smoothing

    def _opt_smooth(self):
        # We're just using cross-validation and retraining the whole model.
        # Likely a lot of improvements possible
        def obj(x):
            ss = sklearn.model_selection.ShuffleSplit(n_splits=5, test_size=.3)
            for tri, tei in ss.split(self._X_train):
                K = scipy.spatial.distance.squareform(scipy.spatial.distance.pdist(self._X_train[tri,:], self.norm))
                K = self.rbf(K)
                K -= np.eye(K.shape[0]) * x
                
                nodes = None
                rcond = 1/np.linalg.cond(K)
                if rcond > 1e-10: # If the matrix is not singular, (i.e. most of the time)
                    try:
                        nodes = linalg.solve(K, self._y_train[tri], sym_pos=True)
                    except linalg.LinAlgError: pass
                if nodes is None:
                    nodes = linalg.lstsq(K, self._y_train[tri])[0]
                
                K = scipy.spatial.distance.cdist(self._X_train[tei,:], self._X_train[tri,:], self.norm)
                K = self.rbf(K)
    
            return np.sum((self._y_train[tei] - np.dot(K, nodes))**2)
        
        opt_param = scipy.optimize.minimize_scalar(obj, bounds=[.0001,100], bracket=[0.0001,100])
        self.smooth = opt_param.x
    
    def _make_kernel(self, new_X=None):
        if new_X is None:
            K = scipy.spatial.distance.squareform(scipy.spatial.distance.pdist(self._X_train, self.norm))
        else:
            K = scipy.spatial.distance.cdist(new_X, self._X_train, self.norm)
        
        K = self.rbf(K)
            
        if new_X is None and self.smooth != 0:
            K -= np.eye(K.shape[0])*self.smooth
        
        return K
    
    def fit(self, X, y):
        self._X_train = X
        self._y_train = y
        
        if len(self._X_train.shape) == 1:
            self._X_train = self._X_train[:,np.newaxis]
            
        if self.optimize_smoothing:
            self._opt_smooth()

        self.K = self._make_kernel()
        
        nodes = None
        rcond = 1/np.linalg.cond(self.K)
        if rcond > 1e-10:
            try:
                self.nodes = linalg.solve(self.K, self._y_train, sym_pos=True)
            except linalg.LinAlgError: pass
        if nodes is None:
            self.nodes = linalg.lstsq(self.K, self._y_train)[0]
        
    def predict(self, X):
        if len(X.shape) == 1:
            X = X[:,np.newaxis]

        K = self._make_kernel(X)
        
        return np.dot(K, self.nodes)
        

class RBFConsensus:
    def __init__(self, 
                 sample_frac=.6, 
                 subsample_rounds=32, 
                 radial_basis_function=lambda x:x, 
                 norm='euclidean',
                 copy_data=True,
                 categorical_features=None):
        
        self.sample_frac = sample_frac # What fraction of data to sample for each subsampling round
        self.subsample_rounds = subsample_rounds # How many rounds
        self.radial_basis_function = radial_basis_function # which interpolator ("linear" with euclidean norm is linear interpolation)
        self.norm = norm # Which distance function is appropriate?
        self.copy_data = copy_data # Should input data be copied, or refed?
        self.N = None
        self.trained_smooth_param = None  
        self.categorical_features = categorical_features
        
    
    def _fit_one(self, X, y, optimize_smoothing=False):
        
        self.rbfis_by_dim = []
        
        for dim in range(y.shape[1]):
            
            # Use previously optimized smoothing unless optimize_smoothing == True
            if self.trained_smooth_param is None:
                rbfi = RbfInterpolator(rbf=self.radial_basis_function, norm=self.norm, optimize_smoothing=optimize_smoothing)
            else:
                rbfi = RbfInterpolator(smooth=self.trained_smooth_param[dim], rbf=self.radial_basis_function, norm=self.norm, optimize_smoothing=optimize_smoothing)
            
            rbfi.fit(X,y[:,dim])
            
            self.rbfis_by_dim.append(rbfi)
        
        if optimize_smoothing: # This means we have optimized params available
            self.trained_smooth_param = [self.rbfis_by_dim[dim].smooth for dim in range(y.shape[1])]
        
        return self
    
    
    def _predict_one(self, X):
        
        if len(X.shape) == 1:
            Xp = X[:,np.newaxis]
        else:
            Xp = X
        
        pred = np.empty([Xp.shape[0], self._y_train.shape[1]])
        for dim in range(len(self.rbfis_by_dim)):
            pred[:,dim] = self.rbfis_by_dim[dim].predict(X).squeeze()
            
        return pred
    
    
    def fit(self, X, y):
        
        self._y_train = y.copy() if self.copy_data else y
        self._X_train = X.copy() if self.copy_data else X
        
        if len(self._y_train.shape) == 1:
            self._y_train = self._y_train[:,np.newaxis]
        
        if len(self._X_train.shape) == 1:
            self._X_train = self._X_train[:,np.newaxis]
        
        self.N = X.shape[0]
        
    def predict(self, X, return_std=False):

        if self.N is None:
            raise RuntimeError('`.fit` must be called before `.predict`')      
            
        N_samp = int(np.ceil(self.N * self.sample_frac))

        y_pred = np.empty([X.shape[0], self._y_train.shape[1], self.subsample_rounds])

        # np.random.seed(7)
        
        for i in range(self.subsample_rounds):
            r = np.random.permutation(self.N)[:N_samp]

            y_sub = self._y_train[r,:]
            X_sub = self._X_train[r,:]

            self._fit_one(X_sub, y_sub)
            y_pred[:,:,i] = self._predict_one(X)
            
        y_out = y_pred.mean(axis=2)
        
        if return_std:    
            y_std = np.sqrt(y_pred.var(axis=2).sum(axis=1))
            return y_out, y_std 
        else:
            return y_out
        


def RBF_unit_test():
    
    import matplotlib.pyplot as plt
    import time
    
    # Generate synthetic 1-d data    
    N = 300
    lo = -10.0
    hi = 10.0

    t = np.linspace(lo,hi,N)
    y = np.sin(t*.5) - .08*t**2 + np.random.randn(t.shape[0])*.05*(t-lo)

    # Messy fitting
    model = RBFConsensus(radial_basis_function=lambda x:bases('inverse_multiquadric')(x,.2))
    
    t0 = time.time()
    model.fit(t,y)
    y_pred, y_std = model.predict(t, return_std=True)
    print(time.time()-t0)

    y_pred = y_pred.squeeze()
    y_std = y_std.squeeze()

    plt.fill_between(t, y_pred - 5*y_std, y_pred + 5*y_std, alpha=0.15, color='k')
    plt.scatter(t,y)
    plt.plot(t, y_pred, color='red')

    plt.show()


