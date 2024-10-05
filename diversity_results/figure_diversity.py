import csv
import matplotlib.pyplot as plt

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
        filename = f'ibafs_f{func}_d{dim}.csv'
        data = []

        with open(filename, 'r') as csvfile:
            csvreader = csv.reader(csvfile)
            for row in csvreader:
                data.append([float(value) for value in row])

        # データを転置して、各列（精度）ごとにプロットできるようにする
        data_transposed = list(map(list, zip(*data)))

        # グラフを作成
        plt.figure(figsize=(12, 6))

        accuracies = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0, "nos"]  # 0.95を追加
        for i, row in enumerate(data_transposed):
            plt.plot(range(1, 2001), row,
                     linestyle=line_styles[i % len(line_styles)],
                     marker=markers[i % len(markers)],
                     color=colors[i % len(colors)],
                     label=f'Accuracy {accuracies[i]}',
                     markevery=200)  # マーカーを200点ごとに表示

        plt.xlabel('Data Point')
        plt.ylabel('Value')
        plt.title(f'Experiment Results for Different Accuracies (f{func}, d{dim})')
        plt.legend()
        plt.grid(True)

        # 特定の関数に対して縦軸を対数スケールに設定
        if func in log_scale_functions:
            plt.yscale('log')
            plt.ylabel('Value (log scale)')

        # x軸の範囲を1から2000に設定
        plt.xlim(1, 2000)

        # グラフを保存
        plt.savefig(f'ibafs_f{func}_d{dim}.png', dpi=300, bbox_inches='tight')
        plt.close()  # メモリ解放のためにfigureを閉じる

print("All graphs have been generated and saved.")