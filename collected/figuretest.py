import matplotlib.pyplot as plt
import matplotlib

# 日本語フォントの設定
matplotlib.rcParams['font.family'] = 'IPAexGothic'  # ここに使用するフォント名を指定

# プロットの例
x = [1, 2, 3, 4, 5]
y = [1, 4, 9, 16, 25]

plt.plot(x, y)
plt.title('グラフのタイトル')
plt.xlabel('横軸ラベル')
plt.ylabel('縦軸ラベル')
plt.show()
