import csv
import matplotlib.pyplot as plt

plt.rcParams['text.usetex'] = True
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['font.sans-serif'] = 'Helvetica'

surrogate = 'gbafs'
d = [10, 30]
f = [1, 2, 4, 8, 13, 15]

# 対数スケールを使用する関数のリスト
log_scale_functions = [1, 2, 4, 8]  # 例: f1, f2, f4, f8 に対して対数スケールを使用

# スタイル設定
line_styles = ['-', '--', '-.', ':', (0, (3, 1, 1, 1)), (0, (3, 5, 1, 5))]
markers = ['o', 's', 'D', '^', 'v', '<', '>', 'p', '*', 'h', 'H', '+', 'x', 'X', '|', '_']
colors = ['b', 'g', 'r', 'c', 'm', 'orange', 'k', 'lime', 'purple', 'brown']

for dim in d:
    for func in f:
        filename = f'{surrogate}_f{func}_d{dim}.csv'
        data = []

        with open(filename, 'r') as csvfile:
            csvreader = csv.reader(csvfile)
            for row in csvreader:
                data.append([float(value) for value in row])

        # データを転置して、各列（精度）ごとにプロットできるようにする
        data_transposed = list(map(list, zip(*data)))

        # グラフを作成
        plt.figure(figsize=(12, 6))

        accuracies = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0, "nos"]
        # メインのグラフを作成
        fig, ax = plt.subplots(figsize=(10, 6))
        plt.subplots_adjust(left=0.1, right=0.9, bottom=0.1, top=0.9)

        for i, row in enumerate(data_transposed):
            # "nos" の場合はラベルを NoS のみに設定
            label = 'NoS' if accuracies[i] == "nos" else f'{accuracies[i]}'
            
            ax.plot(range(1, 2001), row,
                    linestyle=line_styles[i % len(line_styles)],
                    linewidth=2.5,
                    marker=markers[i % len(markers)],
                    markevery=200,  # マーカーを200点ごとに表示
                    color=colors[i % len(colors)],
                    label=label)

        # 軸ラベルの設定
        ax.set_xticks(range(0, 2001, 200))
        # ax.set_xlim(left=-100)
        # ax.set_xlim(right=2100)
        ax.set_xlabel('Evaluation Count', fontsize=24)
        ax.set_ylabel('Diversity' + (' (log scale)' if func in log_scale_functions else ''), fontsize=24)

        # 縦軸を対数スケールに設定する場合
        if func in log_scale_functions:
            ax.set_yscale('log')

        # 凡例を"center left"の位置に設定
        ax.legend(fontsize=14, loc='center left', bbox_to_anchor=(1, 0.5))

        # x軸の範囲を1から2000に設定
        ax.set_xlim(-50, 2100)


        # グラフを保存
        plt.savefig(f'{surrogate}_f{func}_d{dim}.png', bbox_inches='tight')
        plt.close()  # メモリ解放のためにfigureを閉じる

print("All graphs have been generated and saved.")