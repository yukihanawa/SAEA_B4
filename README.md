# SAEA_B4

この文書では、`SAEA_B4`プロジェクトにおける主要な関数とその実行手順について説明します。
これらのプログラムはhttps://github.com/HawkTom/CodeforSAEAsurvey/tree/main を参考に作成しました。

## 概要

- `compare` 関数を使用して、全ての組み合わせを実行します。
- `calucurate_ave.m` では、全ての実行を参照して、それぞれの平均を計算します。
- `combine_ave` で、算出された平均値のデータを集めます。

## 主要関数

- `NoS.m`：サロゲートなしモデルfor IB-AFM。
- `new_IBRBF_changed.m`：IB-AFMの現在のバージョン。
- `PS_classification.m`: PS-classificationモデル．
- `NoS_PSSVC`:サロゲートなしPSのモデル

## 実行関数

- `compare.m`：各関数を実行します。実行ごとに次元数を手動で変更する必要があります。
- `calucurate_ave.m`：20試行の結果を一つの表にまとめて平均を算出します。結果は`combine_results`フォルダ内に保存されます。
- `combine_ave.m`：算出された平均値を一つの表にまとめます。結果は`collected`フォルダ内に保存されます。
- `collected/makefigure.py`：表を作成するためのPythonスクリプト。

## その他必要なファイルおよびフォルダ

- `input_data` フォルダ：実行に必要な入力データを格納。
- `cec15_testfunc.c`：CEC 2015のテスト関数のC言語実装。
- `cec15problems.c`：CEC 2015の問題設定のC言語実装。
- `cec15_test_func.h`：CEC 2015のテスト関数のヘッダーファイル。
- `cec15problems.mexmaci64`：Mac OS用のCEC 2015の問題設定の実行可能ファイル。

## 各実行結果が入るフォルダ
- `pssvc_csv`
- `nosresult_csv`
- `nos_pssvc_csv`
- `ibrbf_csv`
- `generation_csv`

## グラフ作成用
- `kendall_tau.py` : ケンドールのタウを求める
- `mannwhiteneyu.py`: マンホイットニーのU検定