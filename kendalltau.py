import numpy as np
from scipy.stats import kendalltau
# New data from the second image
new_data = np.array([
  [6, 5, 4, 3, 2, 1],
[6, 5, 4, 2, 3, 1],
[6, 5, 4, 1, 2, 3],
[6, 5, 4, 3, 1, 2],
[6, 5, 4, 3, 1, 2],
[6, 5, 4, 3, 1, 2],
[6, 5, 2, 3, 1, 4],
])

# Reference row (1st row)
reference_row_new = new_data[0]

# Calculate Kendall's tau for each row compared to the reference row
tau_results_new = []
for i in range(1, new_data.shape[0]):
    tau, _ = kendalltau(reference_row_new, new_data[i])
    tau_results_new.append(tau)

print(tau_results_new)