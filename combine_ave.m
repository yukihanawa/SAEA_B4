% 初期設定
f_value = [1,2,4,8,13,15]; % fの値
d_value = 30; % dの値は10
sp_values = 0.5:0.1:1.0; % spの値は0.5から1.0まで0.1刻み
run = 20;
% 対象となるファイル名のプレフィックスを配列に格納
file_prefixes = {'ibbubble','ibafs'};

% データを保存する配列を初期化
% +1列目で行数+1、+1行目でsp値を保存する
collected_data = zeros(2001,length(sp_values) + 2); % +2 to add a special column at the end

% 1列目に1から2000までの数字を入れる
collected_data(2:end, 1) = 1:2000;

% 一番右側の列の1行目には10を設定
collected_data(1, end) = 10;

for p = 1:length(file_prefixes)
    prefix = file_prefixes{p};
    % 各sp値でループ
    for f = 1:length(f_value)
        f_v = f_value(f);
        % 1行目にsp値を入れる
        collected_data(1, 2:length(sp_values) + 1) = sp_values;

        for sp = 1:length(sp_values)
            sp_v = sp_values(sp);
            % ファイル名を生成
%             filename = sprintf('combine_results/aggregated_%s_f%d_d%d_sp%.2f.csv', prefix, f_v, d_value, sp_v);
            filename = sprintf('combine_results/aggregated_%s_f%d_d%d_sp%.2f.csv', prefix, f_v, d_value, sp_v);
            if ~exist(filename, 'file')
                fprintf('ファイルが存在しません: %s\n', filename);
                continue; % 次のループへ進む
            end
            % ファイルを読み込む
            data = csvread(filename);

            % run数+1列目のデータを取得
            col_11_data = data(:, run + 1);

            % 取得したデータを保存
            collected_data(2:end, sp + 1) = col_11_data;
        end

        % 特定のファイルから11行目のデータを取得して最後の列に追加
        nosresult_filename = sprintf('combine_results/aggregated_nosresult_f%d_d%d.csv', f_v, d_value);
        if exist(nosresult_filename, 'file')
            nosresult_data = csvread(nosresult_filename);
            col_11_data_nosresult = nosresult_data(:,run + 1);
            collected_data(2:end, end) = col_11_data_nosresult;
        else
            fprintf('ファイルが存在しません: %s\n', nosresult_filename);
        end

        % 新しいCSVファイルにデータを書き出す
%         new_filename = sprintf('collected/collected_data_%s_f%d_d%d.csv', prefix, f_v, d_value);
%         new_filename = sprintf('collected/new_collected_data_%s_f%d_d%d.csv', prefix, f_v, d_value);
          new_filename = sprintf('collected/collected_%s_f%d_d%d.csv', prefix, f_v, d_value);
        
        
        csvwrite(new_filename, collected_data);
    end
end
