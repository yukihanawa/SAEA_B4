% 指定されたspの値のリスト
sp_values = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0];

% 保存するための配列を初期化
all_results = nan(2001, length(sp_values) + 1);

% ヘッダーを作成
header = zeros(1, length(sp_values) + 1);
header(1) = 0; % ヘッダーの最初の要素
for idx = 1:length(sp_values)
    header(idx + 1) = sp_values(idx); 
end
all_results(1, :) = header;

% 2行目から2000行目までの最初の列に1から2000までの数字を追加
all_results(2:end, 1) = 1:2000;

% 各sp値でPS_classification関数を呼び出し、結果をall_resultsに追加
for idx = 1:length(sp_values)
    sp = sp_values(idx);
    fitness_results = PS_classification(sp);
    all_results(2:length(fitness_results)+1,idx+1) = fitness_results;
end

% 結果をCSVファイルに保存
writematrix(all_results,'results2.csv');
