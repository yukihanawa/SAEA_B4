import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns

# データの読み込みと整形
def prepare_data(data, func, dim):
    # グループの順序を定義
    groups = ['nos', 'sp0.50', 'sp0.60', 'sp0.70', 'sp0.80', 'sp0.90', 'sp1.00']
    
    # 結果を格納するための空の DataFrame を作成
    result = pd.DataFrame(index=groups, columns=groups)
    
    # データを埋める
    for _, row in data.iterrows():
        g1, g2 = row['group1'], row['group2']
        col_name = f"{func}_{dim}"
        result.loc[g1, g2] = row[col_name]
        result.loc[g2, g1] = row[col_name]  # 対称性のため
    
    # 対角線上をNaNに設定
    np.fill_diagonal(result.values, np.nan)
    
    # 上三角をNaNに設定
    for i in range(len(result)):
        for j in range(i + 1, len(result.columns)):
            result.iloc[i, j] = np.nan
            
    return result.replace({True: 1, False: 0})

# ヒートマップを作成する関数
def create_heatmap(data, func, dim, output_filename):
    plt.figure(figsize=(10, 8))
    
    # ヒートマップの作成
    heatmap_args = {
        'linewidths': 0.35,
        'linecolor': 'white',
        'square': True,
        'cmap': 'Set1_r',
        'vmin': 0,
        'vmax': 1,
        'center': 0.5,
        'cbar': False,
        # 'cbar_kws': {'label': 'Significance (1=True, 0=False)',
        #              'ticks': [0, 1]}
    }
    
    # ラベルを整形（'sp'と'nos'の処理）
    labels = [label.replace('sp', '') if label != 'nos' else 'NoS' 
             for label in data.columns]
    
    ax = sns.heatmap(data, **heatmap_args)
    
    # 軸ラベルとタイトルの設定
    ax.set_xticklabels(labels, rotation=45, size=18)
    ax.set_yticklabels(labels, rotation=0, size=18)
    ax.set_xlabel("Group1",size=18)
    ax.set_ylabel("Group2",size=18)
    # ax.set_title(f"Significance Heatmap for {func} ({dim})")
    
    # グラフの保存
    plt.tight_layout()
    plt.savefig(output_filename)
    plt.close()

# メインの処理
def generate_all_heatmaps(data_file):
    # CSVファイルを読み込む
    df = pd.read_csv(data_file)
    
    # 全ての関数と次元の組み合わせでヒートマップを生成
    functions = ['f1', 'f2', 'f4', 'f8', 'f13', 'f15']
    dimensions = ['d10', 'd30']
    
    for func in functions:
        for dim in dimensions:
            # データの準備
            processed_data = prepare_data(df, func, dim)
            
            # ヒートマップの作成と保存
            output_filename = f"ヒートマップ/heatmap_pssvc_{func}_{dim}.pdf"
            create_heatmap(processed_data, func, dim, output_filename)

# 実行
generate_all_heatmaps('combined_pssvc_results.csv')