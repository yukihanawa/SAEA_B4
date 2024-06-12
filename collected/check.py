import matplotlib.pyplot as plt
from matplotlib import font_manager

font_dirs = ["/Users/hanawayuki/Documents/SAEA_B4/collected"]
font_files = font_manager.findSystemFonts(fontpaths=font_dirs)
print(font_files)

x = [1, 2, 3, 4, 5]
y = [1, 4, 9, 16, 25]

for font_file in font_files:
    font_manager.fontManager.addfont(font_file)

plt.rcParams['font.family'] = 'TimesRoman'

plt.title('y = x^2check')
plt.plot(x, y)
plt.show()