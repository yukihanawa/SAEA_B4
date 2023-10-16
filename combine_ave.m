% 初期設定
f_value = [1,2,4,8,13,15]; % fの値
d_value = 10; % dの値は10
sp_values = 0.5:0.1:1.0; % spの値は0.5から1.0まで0.1刻み
% 対象となるファイル名のプレフィックスを配列に格納
file_prefixes = {'pssvc'};

% データを保存する配列を初期化
collected_data = zeros(2000,length(sp_values));

for p = 1:length(file_prefixes)
    prefix = file_prefixes{p};
    % 各sp値でループ
    for f = 1:length(f_value)
        f_v = f_value(f);
        for sp = 1:length(sp_values)
            sp_v = sp_values(sp);
            % ファイル名を生成
            filename = sprintf('combine_results/aggregated_%s_f%d_d%d_sp%.2f.csv', prefix, f_v, d_value, sp_v);
            if ~exist(filename, 'file')
                    fprintf('ファイルが存在しません: %s\n', filename);
                    continue; % 次のループへ進む
            end
            % ファイルを読み込む
            data = csvread(filename);

            % 11列目のデータを取得
            col_11_data = data(:, 11);

            % 取得したデータを保存
            collected_data(:,sp) = col_11_data;
        end

        % 新しいCSVファイルにデータを書き出す
        new_filename = sprintf('collected/collected_data_%s_f%d_d%d.csv',prefix, f_v, d_value);
        csvwrite(new_filename, collected_data);
    end
end