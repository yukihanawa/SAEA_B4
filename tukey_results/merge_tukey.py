import pandas as pd
import os
import re

# 結果ディレクトリとサロゲートモデルのリスト
result_directory = 'tukey_results'
surrogate_models = ['gbafs', 'ibafs', 'pssvc']

# 指定されたfとdの順序
d_values = [10, 30]
f_values = [1, 2, 4, 8, 13, 15]

# サロゲートモデルごとのファイルを格納する辞書を作成
all_data = {surrogate: pd.DataFrame() for surrogate in surrogate_models}

# サロゲートモデルごとにファイルを処理
for surrogate in surrogate_models:
    # 結合するデータフレームのリストを初期化
    combined_df = pd.DataFrame()

    # 指定順にdとfをループ
    for d in d_values:
        for f in f_values:
            # 列名として使うf_dを設定
            column_name = f'f{f}_d{d}'
            
            # サロゲートモデルとf、dに対応するファイルを探す
            for file in os.listdir(result_directory):
                if file.startswith(surrogate) and file.endswith('.csv') and f'_f{f}_d{d}' in file:
                    # ファイルを読み込み、group1, group2, reject列を取得
                    file_path = os.path.join(result_directory, file)
                    df = pd.read_csv(file_path, usecols=['group1', 'group2', 'reject'])
                    df = df.rename(columns={'reject': column_name})  # reject列をf_dの名前に変更

                    # group1とgroup2をキーにして、既存のデータフレームとマージ
                    if combined_df.empty:
                        combined_df = df
                    else:
                        combined_df = pd.merge(combined_df, df, on=['group1', 'group2'], how='outer')

    # サロゲート別にデータを格納
    all_data[surrogate] = combined_df

# サロゲートごとにCSVファイルを保存
for surrogate, df in all_data.items():
    output_file = f'combined_{surrogate}_results.csv'
    df.to_csv(output_file, index=False)
    print(f'{output_file}に結果を保存しました。')