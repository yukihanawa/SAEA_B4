surrogate = 'ibafs';
f_value = [1, 2, 4, 8, 13, 15];
d = [10, 30]; % 変数d_valueに対応する
sp_value = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0];

%ibとか
for f = 1:length(f_value)
    for d_idx = 1:length(d)
        d_value = d(d_idx); % d_valueの設定
        f_v = f_value(f); 
        all_data = [];
        for sp = 1:length(sp_value)
            sp_v = sp_value(sp);
            filename = sprintf('combine_results/aggregated_%s_f%d_d%d_sp%.2f.csv', surrogate, f_v, d_value, sp_v);
            
            if ~exist(filename, 'file')
                fprintf('ファイルが存在しません: %s\n', filename);
                continue; % 次のループへ進む
            end
            
            try
                data = readmatrix(filename); % csvreadの代わりにreadmatrixを使用
                
                % 2000行目の1〜20列の中央値を計算
                median_2000_row = median(data(2000, 1:20));
                
                % 各行の1〜20列の値に対して中央値との差を計算
                diff_to_median = abs(data(2000, 1:20) - median_2000_row); 
                
                disp(diff_to_median);
                
                % 最も中央値に近い行を見つける
                [~, closest_row] = min(diff_to_median);
                
                fprintf('ファイル: %s, 最も中央値に近い行: %d\n', filename, closest_row);
                
            catch ME
                fprintf('エラーが発生しました: %s\n', ME.message);
            end
            filename = sprintf('ibafs_mat/%s_run%d_f%d_d%d_sp%.2f.mat', surrogate, closest_row, f_v, d_value, sp_v);

            % .matファイルの存在確認
            if ~exist(filename, 'file')
                fprintf('ファイルが存在しません: %s\n', filename);
            else
                try
                    % .matファイルの読み込み
                    mat_data = load(filename);

                    % pop_history.xの取得
                    if isfield(mat_data, 'pop_history') && isfield(mat_data.pop_history, 'x')
                        x_data = mat_data.pop_history.x;

                        % データサイズの確認 (40×12×2000)
                        [num_individuals, num_coords, num_generations] = size(x_data);

                        fprintf('個体数: %d, 座標数: %d, 世代数: %d\n', num_individuals, num_coords, num_generations);

                        % 各世代の座標(3〜12行目)を抽出
                        coords_data = x_data(:, 3:12, :);

                        % 各世代の多様性を計算
                        diversity_per_generation = NaN(num_generations, 1); % 初期値をNaNで設定

                        for gen = 1:num_generations
                            gen_coords = coords_data(:, :, gen); % 世代ごとの座標データ (40×10)

                            % NaNを含む世代はスキップ
                            if all(isnan(gen_coords), 'all')
%                                 fprintf('世代 %d にはデータがありません (NaN のみ)\n', gen);
                                continue; % この世代はスキップ
                            end
                            
%                             fprintf('世代%dにはデータがあります\n',gen);

                            % 各次元 j の多様性 Div_j を計算
                            D = size(gen_coords, 2); % 次元数 D = 10
                            Div_j = zeros(D, 1);

                            for j = 1:D
                                % 各次元 j の中央値を計算し、NaNを除外
                                valid_data = gen_coords(:, j);
                                valid_data = valid_data(~isnan(valid_data)); % NaNを除去

                                % 有効なデータがない場合、スキップ
                                if isempty(valid_data)
                                    continue;
                                end

                                median_j = median(valid_data); % 中央値の計算
                                Div_j(j) = mean(abs(valid_data - median_j)); % 個体間の差の平均
                            end

                            % 全次元の平均多様性 Div を計算
                            diversity_per_generation(gen) = mean(Div_j);
                        end

                        fprintf('多様性の計算が完了しました。\n');                        
                        %結果の保存
%                         filename1 = sprintf('diversity_results/%s_f%d_d%d_sp%.2f.csv',surrogate,f_v,d_value,sp_v);
%                         filled_data = fillmissing(diversity_per_generation(1:2000),'previous');
%                         writematrix(filled_data,filename1);
                    else
                        fprintf('pop_history.xが見つかりません。\n');
                    end
                catch ME
                    fprintf('エラーが発生しました: %s\n', ME.message);
                end
            end
            filled_data = fillmissing(diversity_per_generation(1:2000),'previous');
            all_data = horzcat(all_data, filled_data);
        end
        nos_data = nosdiversity(f_v,d_value);
        all_data = horzcat(all_data,nos_data);
        % ファイル名の作成（f_vとd_valueごとにファイルを作成）
        filename1 = sprintf('diversity_results/%s_f%d_d%d.csv', surrogate, f_v, d_value);

        % 横に並べたデータを一つのファイルに書き出し
        writematrix(all_data, filename1);
    end
end


function all_data = nosdiversity(f_v,d_value)
    all_data_nos =[];
    filename = sprintf('combine_results/aggregated_nosresult_f%d_d%d.csv', f_v, d_value);
            
    if ~exist(filename, 'file')
        fprintf('ファイルが存在しません: %s\n', filename);
        return; % 次のループへ進む
    end

    try
        data = readmatrix(filename); % csvreadの代わりにreadmatrixを使用

        % 2000行目の1〜20列の中央値を計算
        median_2000_row = median(data(2000, 1:20));

        % 各行の1〜20列の値に対して中央値との差を計算
        diff_to_median = abs(data(2000, 1:20) - median_2000_row); 

        disp(diff_to_median);

        % 最も中央値に近い行を見つける
        [~, closest_row] = min(diff_to_median);

        fprintf('ファイル: %s, 最も中央値に近い行: %d\n', filename, closest_row);

    catch ME
        fprintf('エラーが発生しました: %s\n', ME.message);
    end
    filename = sprintf('nosresult_mat/nosresult_run%d_f%d_d%d.mat',closest_row, f_v, d_value);

    % .matファイルの存在確認
    if ~exist(filename, 'file')
        fprintf('ファイルが存在しません: %s\n', filename);
    else
        try
            % .matファイルの読み込み
            mat_data = load(filename);

            % pop_history.xの取得
            if isfield(mat_data, 'pop_history') && isfield(mat_data.pop_history, 'x')
                x_data = mat_data.pop_history.x;

                % データサイズの確認 (40×12×2000)
                [num_individuals, num_coords, num_generations] = size(x_data);

                fprintf('個体数: %d, 座標数: %d, 世代数: %d\n', num_individuals, num_coords, num_generations);

                % 各世代の座標(3〜12行目)を抽出
                coords_data = x_data(:, 3:12, :);

                % 各世代の多様性を計算
                diversity_per_generation = NaN(num_generations, 1); % 初期値をNaNで設定

                for gen = 1:num_generations
                    gen_coords = coords_data(:, :, gen); % 世代ごとの座標データ (40×10)

                    % NaNを含む世代はスキップ
                    if all(isnan(gen_coords), 'all')
    %                                 fprintf('世代 %d にはデータがありません (NaN のみ)\n', gen);
                        continue; % この世代はスキップ
                    end

    %                             fprintf('世代%dにはデータがあります\n',gen);

                    % 各次元 j の多様性 Div_j を計算
                    D = size(gen_coords, 2); % 次元数 D = 10
                    Div_j = zeros(D, 1);

                    for j = 1:D
                        % 各次元 j の中央値を計算し、NaNを除外
                        valid_data = gen_coords(:, j);
                        valid_data = valid_data(~isnan(valid_data)); % NaNを除去

                        % 有効なデータがない場合、スキップ
                        if isempty(valid_data)
                            continue;
                        end

                        median_j = median(valid_data); % 中央値の計算
                        Div_j(j) = mean(abs(valid_data - median_j)); % 個体間の差の平均
                    end

                    % 全次元の平均多様性 Div を計算
                    diversity_per_generation(gen) = mean(Div_j);
                end                     
            else
                fprintf('pop_history.xが見つかりません。\n');
            end
        catch ME
            fprintf('エラーが発生しました: %s\n', ME.message);
        end
    end
    filled_data = fillmissing(diversity_per_generation(1:2000),'previous');
    all_data = horzcat(all_data_nos, filled_data);
end