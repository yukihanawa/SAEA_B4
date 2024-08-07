% 設定
f_value = [1,2,4,8,13,15]; % fの値
d_value = 10; % dの値
num_runs = 20; % runの数
sp_value = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0];

% 対象となるファイル名のプレフィックスを配列に格納
file_prefixes = {'gbafs'};
% nosresult用

prefix = 'nosresult';
for f = 1:length(f_value)
    f_v = f_value(f);
    % 2000x10の行列を初期化（各CSVファイルのデータがここに格納されます）
    all_data = zeros(2000, num_runs);

    % 各CSVファイルからデータを読み込む
    % 各CSVファイルからデータを読み込む

    for run = 1:num_runs
        filename = sprintf('%s_csv/%s_run%d_f%d_d%d.csv',prefix, prefix, run, f_v, d_value);
        if ~exist(filename, 'file')
            fprintf('ファイルが存在しません: %s\n', filename);
            continue; % 次のループへ進む
        end
        try
            all_data(:, run) = csvread(filename);
        catch ME
            fprintf('エラーが発生しました: %s\n', ME.message);
        end
    end


    % 平均値を計算
    mean_values = mean(all_data, 2);

    % 平均値を最後の列に追加
    all_data_with_mean = [all_data, mean_values];

    % 新しいCSVファイルに保存
    new_filename = sprintf('combine_results/aggregated_%s_f%d_d%d.csv', prefix, f_v, d_value);
    csvwrite(new_filename, all_data_with_mean);
end


% 各プレフィックスに対して処理
for p = 1:length(file_prefixes)
    prefix = file_prefixes{p};
    for f = 1:length(f_value)
        f_v = f_value(f);
        for sp = 1:length(sp_value)
            sp_v = sp_value(sp);
            % 2000x10の行列を初期化（各CSVファイルのデータがここに格納されます）
            all_data = zeros(2000, num_runs);

            % 各CSVファイルからデータを読み込む
            % 各CSVファイルからデータを読み込む

            for run = 1:num_runs
%                 filename = sprintf('%s_csv/%s_run%d_f%d_d%d_sp%.2f.csv',prefix, prefix, run, f_v, d_value,sp_v);
                filename = sprintf('%s_csv/%s_run%d_f%d_d%d_sp%.2f.csv',prefix , prefix, run, f_v, d_value,sp_v);
                if ~exist(filename, 'file')
                    fprintf('ファイルが存在しません: %s\n', filename);
                    continue; % 次のループへ進む
                end
                try
                    all_data(:, run) = csvread(filename);
                catch ME
                    fprintf('エラーが発生しました: %s\n', ME.message);
                end
            end


            % 平均値を計算
            mean_values = mean(all_data, 2);

            % 平均値を最後の列に追加
            all_data_with_mean = [all_data, mean_values];

            % 新しいCSVファイルに保存
            new_filename = sprintf('combine_results/aggregated_%s_f%d_d%d_sp%.2f.csv', prefix, f_v, d_value,sp_v);
%             new_filename = sprintf('combine_results/changed_aggregated_%s_f%d_d%d_sp%.2f.csv', prefix, f_v, d_value,sp_v);
            csvwrite(new_filename, all_data_with_mean);
        end
    end
end
