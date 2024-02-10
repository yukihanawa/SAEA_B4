import numpy as np

def kendall_tau(a, b):
    n = len(a)
    concordant = 0
    discordant = 0
    for i in range(n):
        for j in range(i+1, n):
            concordant += np.sign(a[i] - a[j]) == np.sign(b[i] - b[j])
            discordant += np.sign(a[i] - a[j]) != np.sign(b[i] - b[j])
    tau = (concordant - discordant) / (0.5 * n * (n - 1))
    return tau

# 使用例
A = np.array([6, 5, 4, 3, 2, 1])
B = np.array([6, 5, 4, 1, 3, 2])

tau = kendall_tau(A, B)
print(f"ケンドールの順位相関係数: {tau}")
