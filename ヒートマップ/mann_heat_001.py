import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# シンボルを数値にマッピング
symbol_mapping = {"-": -1, "≈": 0, "+": 1}

# IB vs GB データ (30 dimension)
ib_vs_gb_data = [
    ["+", "-", "+", "+", "+", "+", "+", "≈", "≈", "≈", "≈"],
    ["-", "≈", "≈", "-", "-", "-", "-", "-", "-", "-", "-"],
    ["+", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
    ["+", "≈", "+", "+", "+", "≈", "+", "-", "≈", "≈", "≈"],
    ["+", "-", "≈", "≈", "≈", "-", "-", "-", "-", "-", "-"],
    ["+", "+", "+", "≈", "≈", "≈", "≈", "≈", "≈", "≈", "≈"],
]

# PS vs GB データ (30 dimension)
ps_vs_gb_data = [
    ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
    ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "+"],
    ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
    ["-", "-", "-", "-", "-", "≈", "-", "-", "-", "≈", "+"],
    ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
    ["≈", "≈", "+", "+", "+", "≈", "+", "+", "+", "+", "+"],
]

# データを DataFrame に変換
def create_dataframe(data, accuracies, functions):
    df = pd.DataFrame(data, columns=accuracies, index=functions)
    df = df.replace(symbol_mapping)  # シンボルを数値に変換
    df.index.name = "Function"
    df.columns.name = "Accuracy"
    return df

# データの準備
accuracies_ib_gb = [0.50, 0.51, 0.52, 0.53, 0.54, 0.55, 0.56, 0.57, 0.58, 0.59, 0.60]
functions = ["f1", "f2", "f4", "f8", "f13", "f15"]

df_ib_gb = create_dataframe(ib_vs_gb_data, accuracies_ib_gb, functions)

accuracies_ps_gb = [0.90, 0.91, 0.92, 0.93, 0.94, 0.95, 0.96, 0.97, 0.98, 0.99, 1.00]
df_ps_gb = create_dataframe(ps_vs_gb_data, accuracies_ps_gb, functions)

# ヒートマップをプロットする関数
def plot_single_heatmap(df, title, filename):
    plt.figure(figsize=(10, 6))
    sns.heatmap(df, annot=False, fmt=".0f", cmap="coolwarm", center=0, cbar=False, linewidths=0.5)
    plt.title(title, fontsize=18)
    plt.xlabel("Accuracy", fontsize=18)
    plt.ylabel("Function", fontsize=18)
    plt.tight_layout()
    plt.savefig(filename)
    plt.show()

# ヒートマップのプロット
plot_single_heatmap(df_ib_gb, "IB vs GB (30 Dimension)", "ib_vs_gb_heatmap.pdf")
plot_single_heatmap(df_ps_gb, "PS vs GB (30 Dimension)", "ps_vs_gb_heatmap.pdf")