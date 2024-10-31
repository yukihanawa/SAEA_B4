import pandas as pd
import os
import re
from statsmodels.stats.multicomp import pairwise_tukeyhsd

# ディレクトリとサロゲートモデルを指定
directory = 'combine_results'
surrogate = 'pssvc'  # 'ibafs' または 'pscs' を指定

# 比較対象に応じたファイル名キーワードを設定
if surrogate in ['gbafs', 'ibafs']:
    nos_keyword = 'nosresult'
elif surrogate == 'pssvc':
    nos_keyword = 'nos_pssvc'
else:
    nos_keyword = ''

# データを格納するリスト
data_list = []

# ファイル名からf（関数）とd（次元）を区別
for file in os.listdir(directory):
    if surrogate in file or nos_keyword in file:
        # spの値（精度）を抽出 (nosファイルには精度がないため、適宜ラベルを設定)
        match_sp = re.search(r'_sp(\d+\.\d+)', file)
        sp = float(match_sp.group(1)) if match_sp else 'nos'  # nosのデータには精度を設定しない

        match_f_d = re.search(r'_f(\d+)_d(\d+)', file)  # 関数fと次元dを抽出
        if match_f_d:
            f = int(match_f_d.group(1))  # 関数番号
            d = int(match_f_d.group(2))  # 次元
            
            # CSVファイルの読み込み
            file_path = os.path.join(directory, file)
            df = pd.read_csv(file_path, header=None)

            # 2000行目の1〜21列目のデータを取得
            data_2000 = df.iloc[1999, :21].values  # 1999は2000行目を意味する

            # 精度（sp値）、関数（f）、次元（d）と2000行目のデータを格納
            for value in data_2000:
                data_list.append((sp, f, d, value))

# データをデータフレームに整理
data_df = pd.DataFrame(data_list, columns=['sp', 'f', 'd', 'value'])

# 関数fと次元dごとにデータを分割
unique_f_d = data_df[['f', 'd']].drop_duplicates()

for _, row in unique_f_d.iterrows():
    f_value = row['f']
    d_value = row['d']
    
    # 対象の関数fと次元dに該当するデータをフィルタリング
    subset_df = data_df[(data_df['f'] == f_value) & (data_df['d'] == d_value)]
    
    # 精度のリストを取得してソート、'nos' は比較のため先頭に追加
    sp_values = sorted([sp for sp in subset_df['sp'].unique() if sp != 'nos']) + ['nos']
    
    comparison_results = []
    
    # TukeyのHSD検定を各精度ペアに対して実行
    for i in range(len(sp_values) - 1):
        for j in range(i + 1, len(sp_values)):
            sp_1 = sp_values[i]
            sp_2 = sp_values[j]
            
            # 対応する精度のデータをフィルタリング
            data_sp1 = subset_df[subset_df['sp'] == sp_1]['value']
            data_sp2 = subset_df[subset_df['sp'] == sp_2]['value']
            
            # TukeyのHSD検定の実行
            tukey = pairwise_tukeyhsd(endog=pd.concat([data_sp1, data_sp2]),
                                      groups=['sp{:.2f}'.format(sp_1) if sp_1 != 'nos' else 'nos'] * len(data_sp1) +
                                             ['sp{:.2f}'.format(sp_2) if sp_2 != 'nos' else 'nos'] * len(data_sp2),
                                      alpha=0.05)
            
            # 検定結果を格納
            for result in tukey.summary().data[1:]:
                comparison_results.append({
                    'group1': result[0],
                    'group2': result[1],
                    'meandiff': result[2],
                    'p-adj': result[3],
                    'lower': result[4],
                    'upper': result[5],
                    'reject': result[6]
                })
    
    # 比較結果をCSVファイルに書き出す
    output_file = f'{surrogate}_tukey_results_f{f_value}_d{d_value}.csv'
    comparison_df = pd.DataFrame(comparison_results)
    comparison_df.to_csv(output_file, index=False)
    
    print(f'TukeyのHSD検定結果を {output_file} に保存しました。')