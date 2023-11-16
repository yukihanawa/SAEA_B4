import pandas as pd
import matplotlib.pyplot as plt
import os

# Base directory where the data files are located
base_dir = ''

# Generate file names based on the pattern
surrogate_models = ['pssvc', 'ibrbf']
functions = ['f1', 'f2', 'f4', 'f8', 'f13', 'f15']
dimensions = ['d10', 'd30']

# Creating a list of file paths based on the naming pattern
file_paths = [os.path.join(base_dir, f'collected_data_{model}_{func}_{dim}.csv')
              for model in surrogate_models
              for func in functions
              for dim in dimensions]

# Define distinct line styles, markers, and colors
line_styles = ['-', '--', '-.', ':', (0, (3, 1, 1, 1)), (0, (3, 5, 1, 5))]
markers = ['o', 's', 'D', '^', 'v', '<', '>', 'p', '*', 'h', 'H', '+', 'x', 'X', '|', '_']
colors = ['b', 'g', 'r', 'c', 'm', 'y', 'k', 'orange', 'purple', 'brown']

# Define the files for logarithmic scale and inset
log_scale_files = [
    # ... (list of files for logarithmic scale)
     'collected_data_pssvc_f1_d10.csv', 'collected_data_pssvc_f2_d10.csv', 'collected_data_pssvc_f8_d10.csv',
    'collected_data_pssvc_f1_d30.csv', 'collected_data_pssvc_f8_d30.csv',
    'collected_data_ibrbf_f1_d10.csv', 'collected_data_ibrbf_f2_d10.csv', 'collected_data_ibrbf_f8_d10.csv',
    'collected_data_ibrbf_f1_d30.csv', 'collected_data_ibrbf_f8_d30.csv'
]
inset_files = [
    'collected_data_pssvc_f2_d10.csv', 'collected_data_pssvc_f8_d10.csv', 'collected_data_pssvc_f13_d10.csv',
     'collected_data_pssvc_f13_d30.csv',
    'collected_data_ibrbf_f2_d10.csv', 'collected_data_ibrbf_f8_d10.csv', 'collected_data_ibrbf_f13_d10.csv',
    'collected_data_ibrbf_f2_d30.csv', 'collected_data_ibrbf_f13_d30.csv'
]

inset_ymin_files = {
    'collected_data_pssvc_f2_d10.csv': 1e4,
    # 他のファイルに対する最小値指定も同様に追加可能
}

# Function to plot each graph with conditional logarithmic scale and inset, and save it
def plot_and_save_graph(file_path, use_log_scale, add_inset):
    # Read data from CSV file
    data = pd.read_csv(file_path)

    # Rename the column '10' to 'NoS' if present
    if '10' in data.columns:
        data = data.rename(columns={'10': 'NoS'})

    # Plotting the main graph
    fig, ax = plt.subplots(figsize=(10, 6))
    plt.subplots_adjust(left=0.1, right=0.9, bottom=0.1, top=0.9)
    for i, column in enumerate(data.columns[1:]):
        ax.plot(data.iloc[:, 0], data[column], label=column, 
                linestyle=line_styles[i % len(line_styles)],
                marker=markers[i % len(markers)], markevery=200, color=colors[i % len(colors)])

    ax.set_xticks(range(0, data.iloc[:, 0].max() + 1, 200))
    ax.set_xlabel('Evaluation Count',fontsize=16)
    ax.set_ylabel('Difference from Minimum value' + (' (log scale)' if use_log_scale else ''), fontsize=16)
    if use_log_scale:
        ax.set_yscale('log')
    ax.legend(fontsize = 16)

    # Adding an inset for the last 500 evaluations if specified
    if add_inset:
        # Create an inset axes
        inset_ax = fig.add_axes([0.45, 0.55, 0.3, 0.3])
        for i, column in enumerate(data.columns[1:]):
            inset_ax.plot(data.iloc[-500:, 0], data.iloc[-500:, i+1], 
                          linestyle=line_styles[i % len(line_styles)],
                          color=colors[i % len(colors)])
        inset_ax.set_title('Last 500 Evaluations')
        if use_log_scale:
            inset_ax.set_yscale('log')
        # 特定のファイルのインセットの縦軸の最小値を設定
        if os.path.basename(file_path) in inset_ymin_files:
            ymin = inset_ymin_files[os.path.basename(file_path)]
            inset_ax.set_ylim(bottom=ymin)

    # Save the plot to the specified folder
    save_path = os.path.join(base_dir, os.path.basename(file_path).replace('.csv', '.pdf').replace('collected_data_', ''))
    plt.savefig(save_path, bbox_inches='tight')
    plt.close()  # Close the figure after saving

# Iterate through the file paths and plot each graph, then save
for path in file_paths:
    if os.path.exists(path):
        use_log_scale = os.path.basename(path) in log_scale_files
        add_inset = os.path.basename(path) in inset_files
        plot_and_save_graph(path, use_log_scale, add_inset)
    else:
        print(f"File not found: {path}")
