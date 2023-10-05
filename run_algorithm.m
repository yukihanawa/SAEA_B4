% 指定されたspの値のリスト
sp_values = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0];

% 保存するための配列を初期化
all_results = nan(2000, length(sp_values) + 1);

% ヘッダーを作成
header = cell(1, length(sp_values) + 1);
header{1} = 'Iteration'; % 最初の列のヘッダーを'Iteration'に変更
for idx = 1:length(sp_values)
    header{idx + 1} = num2str(sp_values(idx)); % インデックスを1つずらしています
end

% セル配列に変換して、ヘッダーを追加
all_results_cell = cell(size(all_results) + [1, 0]); % 追加の行を考慮
all_results_cell(1, :) = header;

% 2行目から2020行目までの最初の列に1から2020までの数字を追加
all_results_cell(2:end, 1) = num2cell(1:2000);

% 各sp値でPS_classification関数を呼び出し、結果をall_resultsに追加
for idx = 1:length(sp_values)
    sp = sp_values(idx);
    fitness_results = PS_classification(sp);
    
    all_results_cell(2:length(fitness_results)+1, idx+1) = num2cell(fitness_results);
end

% 結果をCSVファイルに保存
writetable(cell2table(all_results_cell), 'results.csv', 'WriteVariableNames', false);
