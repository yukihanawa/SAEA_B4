import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Load the dataset
file_path = 'collected_data_ibrbf_f15_d10.csv'
data = pd.read_csv(file_path)

# Rename the column '10' to 'NoS' if present
if '10' in data.columns:
    data = data.rename(columns={'10': 'NoS'})

# Dropping NaN values as per instruction
data_cleaned = data.dropna()

# Extracting evaluation numbers and accuracies
evaluation_numbers = data_cleaned.iloc[:, 0]
accuracies = data_cleaned.iloc[:, 1:]

# Creating a dataframe for ranks
ranks = accuracies.rank(axis=1, method='min', ascending=True)

# Renaming the column '10' to 'NoS'
ranks = ranks.rename(columns={10: 'NoS'})

# Setting distinct colors for each accuracy
colors = ['b', 'g', 'r', 'c', 'm', 'y', 'k']

# Plotting the graph with distinct colors and corrected legend
plt.figure(figsize=(12, 6))

for (column, color) in zip(ranks.columns, colors):
    label = 'NoS' if column == 'NoS' else f'{column}'
    plt.plot(evaluation_numbers, ranks[column], label=label, color=color)

plt.xlabel('Evaluation Number')
plt.ylabel('Rank')
plt.legend(title="Accuracies", loc = 'best')
plt.grid(True)

save_path = file_path.replace('.csv', '.png').replace('collected_data', 'rank_figure')
plt.savefig(save_path, bbox_inches='tight')
plt.close()  # Close the figure after saving
plt.show()