from scipy.stats import mannwhitneyu
import pandas as pd
import numpy as np

# 探索対象の設定
functions = ['f1', 'f2', 'f4', 'f8', 'f13', 'f15']
dimensions = ['d10', 'd30']
accuracies = ['0.50', '0.60', '0.70', '0.80', '0.90', '1.00']

surrogate = ['ibafs', 'pssvc', 'gbafs']

# pandasでCSVファイルを読み込む際に使用する列の指定
columns_to_use = list(range(0, 20))  # Pythonのインデックスは0から始まるため、1-20列は0-19として指定

# 結果を格納するためのリスト
results = []

# 各組み合わせに対して検定を行う
# for surrogate_model in surrogate:
#     for surrogate_model_2 in surrogate:
#         if surrogate_model == surrogate_model_2:
#             continue
for function in functions:
    for dimension in dimensions:
        for accuracy in accuracies:
            # ファイル名を生成
            ibrbf_file = f'combine_results/aggregated_ibafs_{function}_{dimension}_sp{accuracy}.csv'
            pssvc_file = f'combine_results/aggregated_pssvc_{function}_{dimension}_sp{accuracy}.csv'
            gb_file = f'combine_results/aggregated_gbafs_{function}_{dimension}_sp{accuracy}.csv'

            # 2000行目のデータを読み込む
            try:
                ibafs = pd.read_csv(ibrbf_file, skiprows=1999, nrows=1, header=None, usecols=columns_to_use).values.flatten()
                pssvc = pd.read_csv(pssvc_file, skiprows=1999, nrows=1, header=None, usecols=columns_to_use).values.flatten()
                gbafs = pd.read_csv(gb_file, skiprows=1999, nrows=1, header=None, usecols=columns_to_use).values.flatten()
            except FileNotFoundError:
                # ファイルが見つからない場合はスキップ
                print(f"File not found: {ibrbf_file} or {pssvc_file}")
                continue

            # サロゲートモデルのデータをマッピング
            data_map = {
                'ibafs': ibafs,
                'pssvc': pssvc,
                'gbafs': gbafs
            }

            # マンホイットニーU検定を実施
            # stat, p = mannwhitneyu(data_map[surrogate_model], data_map[surrogate_model_2], alternative='less')
            stat, p = mannwhitneyu(gbafs, pssvc, alternative='less')
            # stat,p = mannwhitneyu(data_pssvc, data_gb, alternative='less')

            # 結果を記録
            results.append([function, dimension, accuracy, p])

# 結果をDataFrameに変換
results_df = pd.DataFrame(results, columns=['Function', 'Dimension', 'Accuracy', 'P-Value'])

# 結果をCSVファイルに出力
# results_df.to_csv(f'mannwhitneyu_results_{surrogate_model}vs{surrogate_model_2}.csv', index=False)
results_df.to_csv(f'mannwhitneyu_results_gb_vs_ps.csv', index=False)




