# SAEA_B4

この文書では、`SAEA_B4`プロジェクトにおける主要な関数とその実行手順について説明します。

## 概要

- `compare` 関数を使用して、全ての組み合わせを実行します。
- `calucurate_ave.m` では、全ての実行を参照して、それぞれの平均を計算します。
- `combine_ave` で、算出された平均値のデータを集めます。

## 主要関数

- `NoS.m`：サロゲートなしモデル。
- `new_IBRBF.m`：IB-AFMの旧バージョン。
- `new_IBRBF_changed.m`：IB-AFMの現在のバージョン。

## 実行関数

- `compare.m`：各関数を実行します。実行ごとに次元数を手動で変更する必要があります。
- `calucurate_ave.m`：20試行の結果を一つの表にまとめて平均を算出します。結果は`combine_results`フォルダ内に保存されます。
- `combine_ave.m`：算出された平均値を一つの表にまとめます。結果は`collected`フォルダ内に保存されます。
- `collected/makefigure.py`：表を作成するためのPythonスクリプト。
