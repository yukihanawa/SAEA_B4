clear;
% 設定
f_value = [1,2,4,8,13,15]; % fの値
d_value = 30; % dの値
num_runs = 21; % runの数
% sp_value = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
% sp_value = [0.51, 0.52, 0.53, 0.54, 0.55, 0.56, 0.57, 0.58, 0.59];
sp_value = [0.91, 0.92, 0.93, 0.94, 0.95, 0.96, 0.97, 0.98, 0.99];

% 対象となるファイル名のプレフィックスを配列に格納
file_prefixes = {'gbafs','pssvc'};
% nosresult用

% prefix = 'nosresult';
% for f = 1:length(f_value)
%     f_v = f_value(f);
%     % 2000x10の行列を初期化（各CSVファイルのデータがここに格納されます）
%     all_data = zeros(2000, num_runs);
% 
%     % 各CSVファイルからデータを読み込む
%     % 各CSVファイルからデータを読み込む
% 
%     for run = 1:num_runs
%         filename = sprintf('%s_csv/%s_run%d_f%d_d%d.csv',prefix, prefix, run, f_v, d_value);
%         if ~exist(filename, 'file')
%             fprintf('ファイルが存在しません: %s\n', filename);
%             continue; % 次のループへ進む
%         end
%         try
%             all_data(:, run) = csvread(filename);
%         catch ME
%             fprintf('エラーが発生しました: %s\n', ME.message);
%         end
%     end
% 
% 
%     % 平均値を計算
%     mean_values = mean(all_data, 2);
% 
%     % 平均値を最後の列に追加
%     all_data_with_mean = [all_data, mean_values];

%     %中央値ver
%     % 最終行のデータから中央値を計算
%     final_row = all_data(end, :);
%     median_value_final_row = median(final_row);
% 
%     % 最終行で中央値に該当する列の値を取得
%     [~, median_column_index] = min(abs(final_row - median_value_final_row));
% 
%     % 中央値を持つ列の値を全行に追加
%     median_column = all_data(:, median_column_index);
% 
%     % 中央値の列を追加
%     all_data_with_mean = [all_data, median_column];

    % 新しいCSVファイルに保存
%     new_filename = sprintf('combine_results/aggregated_%s_f%d_d%d.csv', prefix, f_v, d_value);
%     csvwrite(new_filename, all_data_with_mean);
% end
% 
% prefix = 'nos_pssvc';
% for f = 1:length(f_value)
%    f_v = f_value(f);
%     % 2000x10の行列を初期化（各CSVファイルのデータがここに格納されます）
%     all_data = zeros(2000, num_runs);
% 
%     % 各CSVファイルからデータを読み込む
%     % 各CSVファイルからデータを読み込む
% 
%     for run = 1:num_runs
%         filename = sprintf('%s_csv/%s_run%d_f%d_d%d.csv',prefix, prefix, run, f_v, d_value);
%         if ~exist(filename, 'file')
%             fprintf('ファイルが存在しません: %s\n', filename);
%             continue; % 次のループへ進む
%         end
%         try
%             all_data(:, run) = csvread(filename);
%         catch ME
%             fprintf('エラーが発生しました: %s\n', ME.message);
%         end
%     end
% 
% 
%     % 平均値を計算
%     mean_values = mean(all_data, 2);
% 
%     % 平均値を最後の列に追加
%     all_data_with_mean = [all_data, mean_values];

%      %中央値ver
%     % 最終行のデータから中央値を計算
%     final_row = all_data(end, :);
%     median_value_final_row = median(final_row);
% 
%     % 最終行で中央値に該当する列の値を取得
%     [~, median_column_index] = min(abs(final_row - median_value_final_row));
% 
%     % 中央値を持つ列の値を全行に追加
%     median_column = all_data(:, median_column_index);
% 
%     % 中央値の列を追加
%     all_data_with_mean = [all_data, median_column];

    % 新しいCSVファイルに保存
%     new_filename = sprintf('combine_results/aggregated_%s_f%d_d%d.csv', prefix, f_v, d_value);
%     csvwrite(new_filename, all_data_with_mean);
% end


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

            %平均値ver
            % 平均値を計算
            mean_values = mean(all_data, 2);

            % 平均値を最後の列に追加
            all_data_with_mean = [all_data, mean_values];
            
%             %中央値ver
%             % 最終行のデータから中央値を計算
%             final_row = all_data(end, :);
%             median_value_final_row = median(final_row);
% 
%             % 最終行で中央値に該当する列の値を取得
%             [~, median_column_index] = min(abs(final_row - median_value_final_row));
% 
%             % 中央値を持つ列の値を全行に追加
%             median_column = all_data(:, median_column_index);
% 
%             % 中央値の列を追加
%             all_data_with_mean = [all_data, median_column];

            % 新しいCSVファイルに保存
            new_filename = sprintf('combine_results/aggregated_%s_f%d_d%d_sp%.2f.csv', prefix, f_v, d_value,sp_v);
%             new_filename = sprintf('combine_results/changed_aggregated_%s_f%d_d%d_sp%.2f.csv', prefix, f_v, d_value,sp_v);
            csvwrite(new_filename, all_data_with_mean);
        end
    end
end
