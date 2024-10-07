clear;
dim = 30;
knn = [1*dim, 2*dim, 3*dim, 4*dim, 5*dim];
rsm = [0.1 0.2 0.5 0.7 0.9];

results = cell(20, 1);  % 結果を保存するセル配列

parfor run = 1:10
    seed = run * 100 + 2019;
    temp_results = [];  % 各反復の結果を一時的に保存

%     fprintf('generation_based is starting....run:%d\n', run);
    fprintf('pscs is starting....run:%d\n', run);
    for func = [1 2 4 8 13 15]
        for sp = [0.5 0.6 0.7 0.8 0.9 1.0]
            fprintf('func: %d sp: %.2f\n', func, sp);
            
            % GB_AFS_1 の返り値を取得
%             [evolve, min_hist, correct_rate, pop_history] = GB_AFS_1(func, dim, seed, sp);
            [evolve, min_hist, pop_history] = PSSVC(func, dim, seed, sp);

            % 修正バージョンのデータを temp_results に保存
            filled_data = fillmissing(min_hist(1:2000), 'previous');
            temp_results = [temp_results; {run, func, dim, sp, filled_data, pop_history}];  % 結果を保存
        end
    end

    % 各反復の結果を cell 配列に保存
    results{run} = temp_results;
end

% parfor の外でファイル保存
for run = 1:10
    temp_results = results{run};
    for i = 1:size(temp_results, 1)
        func = temp_results{i, 2};
        dim = temp_results{i, 3};
        sp = temp_results{i, 4};
        filled_data = temp_results{i, 5};
        pop_history = temp_results{i, 6};

        % CSV ファイル保存
%         filename = sprintf('gbafs_2_csv/gbafs_run%d_f%d_d%d_sp%.2f.csv', run, func, dim, sp);
%         csvwrite(filename, filled_data);

        % MAT ファイル保存
%         filename2 = sprintf('gbafs_2_mat/gbafs_run%d_f%d_d%d_sp%.2f.mat', run, func, dim, sp);
        filename2 = sprintf('pscs_mat/pscs_run%d_f%d_d%d_sp%.2f.mat', run, func, dim, sp);
        save(filename2, 'pop_history');
    end
end


clear;
dim = 30;
knn = [1*dim, 2*dim, 3*dim, 4*dim, 5*dim];
rsm = [0.1 0.2 0.5 0.7 0.9];

results = cell(20, 1);  % 結果を保存するセル配列
parfor run = 11:21
    seed = run * 100 + 2019;
    temp_results = [];  % 各反復の結果を一時的に保存

%     fprintf('generation_based is starting....run:%d\n', run);
    fprintf('pscs is starting....run:%d\n', run);
    for func = [1 2 4 8 13 15]
        for sp = [0.5 0.6 0.7 0.8 0.9 1.0]
            fprintf('func: %d sp: %.2f\n', func, sp);
            
            % GB_AFS_1 の返り値を取得
%             [evolve, min_hist, correct_rate, pop_history] = GB_AFS_1(func, dim, seed, sp);
            [evolve, min_hist, pop_history] = PSSVC(func, dim, seed, sp);

            % 修正バージョンのデータを temp_results に保存
            filled_data = fillmissing(min_hist(1:2000), 'previous');
            temp_results = [temp_results; {run, func, dim, sp, filled_data, pop_history}];  % 結果を保存
        end
    end

    % 各反復の結果を cell 配列に保存
    results{run} = temp_results;
end

% parfor の外でファイル保存
for run = 11: 21
    temp_results = results{run};
    for i = 1:size(temp_results, 1)
        func = temp_results{i, 2};
        dim = temp_results{i, 3};
        sp = temp_results{i, 4};
        filled_data = temp_results{i, 5};
        pop_history = temp_results{i, 6};

        % CSV ファイル保存
%         filename = sprintf('gbafs_2_csv/gbafs_run%d_f%d_d%d_sp%.2f.csv', run, func, dim, sp);
%         csvwrite(filename, filled_data);

        % MAT ファイル保存
%         filename2 = sprintf('gbafs_2_mat/gbafs_run%d_f%d_d%d_sp%.2f.mat', run, func, dim, sp);
        filename2 = sprintf('pscs_mat/pscs_run%d_f%d_d%d_sp%.2f.mat', run, func, dim, sp);
        save(filename2, 'pop_history');
    end
end