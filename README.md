# SAEA_B4

compareで全ての組み合わせを実行  
calucurate_ave.mで全てのrunを参照して、平均を出す  
combine_aveで平均のデータを集めてくる 

関数
NoS.m：サロゲートなしモデル
new_IBRBF.m：IB-AFM旧バージョン
new_IBRBF_changed.m：IB-AFM現在のバージョン

実行関数
compare.m：各関数の実行（実行毎に次元数を手動で変更する必要あり）

calucurate_ave.m：20試行の結果を一つの表にまとめ平均を算出→結果はcombine_resultsフォルダ内
combine_ave.m：算出された平均値を一つの表にまとめる→結果はcollectedフォルダ内
collected/makefigure.py：表の作成 