
import numpy as np
import scipy.stats as stats


class MultiArmedBandit:
    """Define a simple implementation of Multi-Armed Bandit with a Beta distribution.

    Based on https://peterroelants.github.io/posts/multi-armed-bandit-implementation/
    """


    def __init__(self, n_bandits, reshape_factor=1, minimize=False, boltzmann=False):
        self.n_bandits      = n_bandits
        self.alpha_priors   = np.ones(n_bandits)
        self.beta_priors    = np.ones(n_bandits)
        self.reshape_factor = reshape_factor # Higher reshape factor favors exploitation
        self.minimize       = minimize
        self.boltzmann      = boltzmann


    def choose_bandit(self):

        if self.boltzmann:
            probs = self.get_empirical_probs()
            self.chosen_bandit_idx = np.random.choice(self.n_bandits, p=np.exp(probs) / np.sum(np.exp(probs)))

        else:

            # Define prior distribution for each bandit
            self.bandit_priors = [stats.beta(alpha, beta)
                                  for alpha, beta in zip(self.alpha_priors, self.beta_priors)]

            # Sample a probability theta for each bandit
            theta_samples = [d.rvs(1) for d in self.bandit_priors]


            # Choose a bandit
            if self.minimize:
                self.chosen_bandit_idx = np.argmin(theta_samples)
            else:
                self.chosen_bandit_idx = np.argmax(theta_samples)

        return self.chosen_bandit_idx


    def update_posterior(self, observation):
        """Update the posterior of the current chosen bandit based on the observation (0 or 1)
        """

        assert 0 <= observation <= 1

        # Update posterior

        self.alpha_priors[self.chosen_bandit_idx] += observation * self.reshape_factor
        self.beta_priors[self.chosen_bandit_idx] += (1 - observation) * self.reshape_factor


    def get_empirical_probs(self):
        return np.array([(a / (a + b - 1)) for a, b in zip(self.alpha_priors, self.beta_priors)])





if __name__ == '__main__':

    import matplotlib.pyplot as plt
    import seaborn as sns

    sns.set_style('darkgrid')


    nb_bandits = 4

    # True probability of winning for each bandit
    p_bandits = np.random.rand(nb_bandits)


    def pull(i):
        if np.random.rand() < p_bandits[i]:
            return 1
        else:
            return 0

    def plot(priors, step, ax):
        """Plot the priors for the current step."""
        plot_x = np.linspace(0.001, .999, 100)
        for prior in priors:
            y = prior.pdf(plot_x)
            p = ax.plot(plot_x, y)
            ax.fill_between(plot_x, y, 0, alpha=0.2)
        ax.set_xlim([0, 1])
        ax.set_ylim(bottom=0)
        ax.set_title('Priors at step {}'.format(step))

    mab = MultiArmedBandit(nb_bandits, 1)

    plots = [1, 2, 5, 10, 25, 50, 100, 200, 500, 1000]
    # plots = np.logspace(0.2, 2, 10).astype(int)

    # Setup plot
    fig, axs = plt.subplots(5, 2, figsize=(8, 10))
    axs = axs.flat

    trials = [0] * nb_bandits

    n = 1000
    # Run the trail for `n` steps
    for step in range(1, n + 1):
        idx = mab.choose_bandit()

        trials[idx] += 1

        if step in plots:
            plot(mab.bandit_priors, step, next(axs))

        x = pull(idx)

        mab.update_posterior(x)


    emperical_p_bandits = [(a / (a + b - 1)) for a, b in zip(mab.alpha_priors, mab.beta_priors)]
    for i in range(nb_bandits):
        print(('True prob={:.2f};  '
               'Emperical prob={:.2f};  '
               'Trials={:d}'.format(p_bandits[i], emperical_p_bandits[i], trials[i])
               ))


    plt.tight_layout()
    plt.show()








