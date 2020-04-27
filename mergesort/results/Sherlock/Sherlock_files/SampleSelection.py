import scipy
import scipy.spatial
import numpy as np
from sklearn.cluster import KMeans, MiniBatchKMeans
from sklearn.neighbors import NearestNeighbors
import warnings

class TED:

    def __init__(self):
        pass


    def fit(self, X, sigma=None):
        if sigma is None:
            # sigma = np.min(np.std(X, axis=0))
            sigma = np.sqrt(np.max(scipy.ptp(X, axis=0)))
        pairwise_sq_dists = scipy.spatial.distance.squareform(scipy.spatial.distance.pdist(X, 'sqeuclidean'))
        self.scale = np.mean(np.sqrt(pairwise_sq_dists))
        self.K = np.matrix(scipy.exp(-pairwise_sq_dists / (2 * sigma ** 2)))
        return self


    def predict(self, m, lamb=10e-4, candidates_idx=None, return_scale=False):
        if candidates_idx is None:
            candidate_index = list(range(self.K.shape[0]))
        else:
            candidate_index = list(candidates_idx)

        n = self.K.shape[0]
        if m > n: raise ValueError("m > #data. Can't pick more samples than data points")

        index = np.zeros(m, dtype=np.intc)
        for i in range(m):
            score = np.zeros(len(candidate_index))
            for j in range(len(candidate_index)):
                k = candidate_index[j]
                score[j] = self.K[k, :] * self.K[:, k] / (self.K[k, k] + lamb)

            I = np.argmax(score)
            index[i] = candidate_index[I]
            del candidate_index[I]
            self.K -= self.K[:, index[i]] * self.K[index[i], :] / (self.K[index[i], index[i]] + lamb)

        if return_scale:
            return index, self.scale
        else:
            return index





def sample_clusters(X, m, return_scale=False):
    """
    Sample the requested number of points (possibly minus 1) based on cluster centers.
    https://github.com/viggin/yan-prtools/blob/master/smpSel_cluster.m
    """
    clusters = MiniBatchKMeans(n_clusters=m, random_state=0).fit(X)
    # clusters = KMeans(n_clusters=m, random_state=0).fit(X)
    labels = clusters.labels_

    unique_labels = np.unique(labels)
    centers_idx = np.empty(len(unique_labels), dtype=int)
    for j, i in enumerate(unique_labels):
        idx = np.where(labels == i)[0]
        Xp = X[idx, :]
        med = np.median(Xp, axis=0)
        nbrs = NearestNeighbors(n_neighbors=1).fit(Xp)
        distances, indices = nbrs.kneighbors(med.reshape(1, -1))
        centers_idx[j] = idx[indices]
    if return_scale:
        # Warning: stupid, a.k.a. todo
        warnings.warn('Scale is not implemented properly!')
        stupid_scale = np.mean(scipy.spatial.distance.cdist(X, X[0].reshape(1, -1), 'euclidean'))
        return centers_idx, stupid_scale
    else:
        return centers_idx