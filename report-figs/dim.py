import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Set random seed for reproducibility
np.random.seed(42)

# Generate random points in low (d=2) and high (d=100) dimensions
n_samples = 1000
low_dim = np.random.rand(n_samples, 2)    # 2D data
high_dim = np.random.rand(n_samples, 100) # 100D data

# Compute pairwise distances (Euclidean and Manhattan)
def pairwise_distances(data, metric='euclidean'):
    n = data.shape[0]
    dists = np.zeros((n, n))
    for i in range(n):
        for j in range(n):
            if metric == 'euclidean':
                dists[i, j] = np.sqrt(np.sum((data[i] - data[j])**2))
            elif metric == 'manhattan':
                dists[i, j] = np.sum(np.abs(data[i] - data[j]))
    return dists[np.triu_indices(n, k=1)]  # Upper triangle (avoid duplicates)

# Compute distances
low_dim_euclidean = pairwise_distances(low_dim, 'euclidean')
low_dim_manhattan = pairwise_distances(low_dim, 'manhattan')
high_dim_euclidean = pairwise_distances(high_dim, 'euclidean')
high_dim_manhattan = pairwise_distances(high_dim, 'manhattan')

# Plotting
plt.figure(figsize=(12, 6))

# Low-Dimensional Space
plt.subplot(1, 2, 1)
sns.kdeplot(low_dim_euclidean, label='Euclidean (L₂)', fill=True)
sns.kdeplot(low_dim_manhattan, label='Manhattan (L₁)', fill=True)
plt.title('Low-Dimensional Space (d=2)')
plt.xlabel('Distance')
plt.ylabel('Density')
plt.legend()

# High-Dimensional Space
plt.subplot(1, 2, 2)
sns.kdeplot(high_dim_euclidean, label='Euclidean (L₂)', fill=True)
sns.kdeplot(high_dim_manhattan, label='Manhattan (L₁)', fill=True)
plt.title('High-Dimensional Space (d=100)')
plt.xlabel('Distance')
plt.legend()

plt.suptitle('Figure 1: Pairwise Distance Distributions in Low vs. High Dimensions', y=1.02)
plt.tight_layout()
plt.show()