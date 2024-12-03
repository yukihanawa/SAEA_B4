import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np

# Recreating the data in a structured format
accuracy = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
functions = ["f1", "f2", "f4", "f8", "f13", "f15"]

# Mapping symbols to numeric values
symbol_mapping = {"-": -1, "≈": 0, "+": 1}

# Data for each comparison and dimension
data_10d_ps_ib = [
    ["-", "-", "-", "-", "≈", "≈"],
    ["≈", "≈", "+", "+", "+", "+"],
    ["-", "-", "-", "-", "-", "+"],
    ["-", "-", "-", "-", "≈", "+"],
    ["-", "-", "≈", "+", "+", "+"],
    ["-", "≈", "≈", "+", "+", "+"],
]
data_30d_ps_ib = [
    ["-", "-", "-", "-", "≈", "+"],
    ["≈", "≈", "+", "+", "+", "+"],
    ["-", "-", "-", "-", "-", "+"],
    ["-", "-", "-", "≈", "+", "+"],
    ["-", "-", "-", "≈", "+", "+"],
    ["-", "-", "-", "-", "+", "+"],
]
data_10d_ps_gb = [
    ["+", "-", "-", "-", "≈", "≈"],
    ["+", "-", "-", "-", "-", "+"],
    ["+", "-", "-", "-", "-", "-"],
    ["+", "-", "-", "-", "-", "+"],
    ["+", "-", "-", "-", "-", "-"],
    ["+", "-", "-", "-", "≈", "+"],
]
data_30d_ps_gb = [
    ["+", "-", "-", "-", "-", "-"],
    ["-", "-", "-", "-", "-", "+"],
    ["+", "-", "-", "-", "-", "-"],
    ["+", "-", "-", "-", "-", "+"],
    ["+", "-", "-", "-", "-", "-"],
    ["+", "-", "-", "-", "≈", "+"],
]
data_10d_ib_gb = [
    ["+", "-", "≈", "-", "≈", "≈"],
    ["+", "-", "-", "-", "-", "-"],
    ["+", "-", "-", "-", "-", "-"],
    ["+", "-", "-", "-", "-", "-"],
    ["+", "-", "-", "-", "-", "-"],
    ["+", "-", "-", "-", "-", "-"],
]
data_30d_ib_gb = [
    ["+", "≈", "-", "-", "-", "-"],
    ["-", "-", "-", "-", "-", "-"],
    ["+", "-", "-", "-", "-", "-"],
    ["+", "≈", "-", "-", "-", "-"],
    ["+", "-", "-", "-", "-", "-"],
    ["+", "≈", "-", "-", "-", "-"],
]

# Convert data into DataFrames and map symbols
def create_dataframe(data, dimension):
    df = pd.DataFrame(data, columns=accuracy, index=functions)
    df = df.replace(symbol_mapping)
    df.index.name = "Function"
    df.columns.name = f"Accuracy"
    return df

df_10d_ps_ib = create_dataframe(data_10d_ps_ib, "10d")
df_30d_ps_ib = create_dataframe(data_30d_ps_ib, "30d")
df_10d_ps_gb = create_dataframe(data_10d_ps_gb, "10d")
df_30d_ps_gb = create_dataframe(data_30d_ps_gb, "30d")
df_10d_ib_gb = create_dataframe(data_10d_ib_gb, "10d")
df_30d_ib_gb = create_dataframe(data_30d_ib_gb, "30d")

# Plotting function
def plot_heatmaps(dfs, titles, x_label="Function", y_label="Accuracy", fontsize=18):
    fig, axes = plt.subplots(2, 3, figsize=(18, 12))
    for ax, df, title in zip(axes.flat, dfs, titles):
        sns.heatmap(df, annot=False, fmt=".0f", cmap="coolwarm", center=0, ax=ax, cbar=False, linewidths=0.5)
        ax.set_title(title, fontsize=18)
        ax.set_xlabel(x_label, fontsize=fontsize)
        ax.set_ylabel(y_label, fontsize=fontsize)
        ax.set_xticklabels(ax.get_xticklabels(), rotation=45, fontsize=fontsize)
        ax.set_yticklabels(ax.get_yticklabels(), rotation=0, fontsize=fontsize)
    plt.tight_layout()
    plt.savefig("mann_heatmaps.pdf")

# Prepare data and titles for plotting
dfs = [
    df_10d_ps_ib, df_10d_ps_gb, df_10d_ib_gb,
    df_30d_ps_ib, df_30d_ps_gb, df_30d_ib_gb
]
titles = [
    "PS vs IB (10D)", "PS vs GB (10D)", "IB vs GB (10D)",
    "PS vs IB (30D)", "PS vs GB (30D)", "IB vs GB (30D)"
]

# Individual plotting and saving function
def save_individual_heatmaps(dfs, titles, x_label="Function", y_label="Accuracy", fontsize=18, output_dir="heatmaps"):
    import os
    os.makedirs(output_dir, exist_ok=True)  # Create directory if not exists
    
    for df, title in zip(dfs, titles):
        plt.figure(figsize=(8, 6))
        sns.heatmap(df, annot=False, fmt=".0f", cmap="coolwarm", center=0, cbar=False, linewidths=0.5)
        plt.title(title, fontsize=fontsize)
        plt.xlabel(x_label, fontsize=fontsize)
        plt.ylabel(y_label, fontsize=fontsize)
        plt.xticks(rotation=45, fontsize=fontsize)
        plt.yticks(rotation=0, fontsize=fontsize)
        # Save each heatmap to a separate file
        filename = os.path.join(output_dir, f"{title.replace(' ', '_').replace('(', '').replace(')', '')}.pdf")
        plt.savefig(filename, bbox_inches="tight")
        plt.close()

# Plot the heatmaps
save_individual_heatmaps(dfs, titles)