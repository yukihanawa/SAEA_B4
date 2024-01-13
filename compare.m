clear;
dim = 30;
knn = [1*dim, 2*dim, 3*dim, 4*dim, 5*dim];
rsm = [0.1 0.2 0.5 0.7 0.9];

for run = 1:1:20
    %NoS用
    seed = run*100 + 2019;
    fprintf('NoS is starting....run:%d',run);
    for func = [1 2 4 8 13 15]
        fprintf('func: %d', func);
        [evolve,min_hist] = NoS(func, dim, seed);
        filename = sprintf('nosresult/nosresult_run%d_f%d_d%d.mat',run, func, dim);
        save(filename, 'evolve')
        filename = sprintf('nosresult_csv/nosresult_run%d_f%d_d%d.csv',run,func,dim);
        filled_data = fillmissing(min_hist(1:end),'previous');        
        csvwrite(filename, filled_data)
    end
    fprintf('\n\n\n')
    %PS-CM用
%     seed = run*100 + 2019;
%     fprintf('PSSVC is starting....')
%     for func = [1 2 4 8 13 15]
%         for sp = [0.5 0.6 0.7 0.8 0.9 1.0]
%             fprintf('func: %d', func);    
%             [evolve, min_hist] = PSSVC( func, dim, seed, sp);
%             filename = sprintf('pssvc/pssvc_run%d_f%d_d%d_sp%.2f.mat', run, func, dim,sp);
%             save(filename, 'evolve')
%             filename = sprintf('pssvc_csv/pssvc_run%d_f%d_d%d_sp%.2f.csv',run,func,dim,sp);
%             filled_data = fillmissing(min_hist(1:end),'previous');
%             csvwrite(filename, filled_data)
%         end
%     end
%     fprintf('\n\n\n')

%IBーAFM用
    seed = run * 100 + 2019;
    fprintf('IBRBF is starting....run%d',run);
    for func = [1 2 4 8 13 15]
        for sp = [0.5 0.6 0.7 0.8 0.9 1.0]
            fprintf('func: %d\n', func);    
            [evolve, min_hist, correct_rate] = new_IBRBF_changed( func, dim, seed, sp);
%           %旧バージョン
%             filename = sprintf('IBRBF/ibrbf_run%d_f%d_d%d_sp%.2f.mat', run, func, dim,sp);
%             save(filename, 'evolve')
%             filename = sprintf('ibrbf_csv/ibrbf_run%d_f%d_d%d_sp%.2f.csv',run,func,dim,sp);
          %修正バージョン(2024/1/10)
            filename = sprintf('ibrbf_csv/new_ibrbf_changed_run%d_f%d_d%d_sp%.2f.csv',run,func,dim,sp);
            filled_data = fillmissing(min_hist(1:2000),'previous');
            csvwrite(filename, filled_data)
        end
    end
    fprintf('\n\n\n')
    %NoS_ps-cm用
%     seed = run*100 + 2019;
%     fprintf('NoS_pssvc is starting....')
%     for func = [1 2 4 8 13 15]
%         fprintf('func: %d', func);
%         [evolve,min_hist] = NoS_PSSVC(func, dim, seed);
%         filename = sprintf('nos_pssvc/nos_pssvc_run%d_f%d_d%d.mat',run, func, dim);
%         save(filename, 'evolve')
%         filename = sprintf('nos_pssvc_csv/nos_pssvc_run%d_f%d_d%d.csv',run,func,dim);
%         filled_data = fillmissing(min_hist(1:end),'previous');        
%         csvwrite(filename, filled_data)
%     end
%     fprintf('\n\n\n')

    %generation_based
%     seed = run * 100 + 2019;
%     fprintf('generation_based is starting....run:%d\n',run);
%     for func = [1 2 4 8 13 15]
%         for sp = [0.5 0.6 0.7 0.8 0.9 1.0]
%             fprintf('func: %d sp: %.2f\n', func, sp);    
%             [evolve, min_hist, correct_rate] = generation_base( func, dim, seed, sp);
% 
%             %修正バージョン
%             filename = sprintf('generation_csv/generation_run%d_f%d_d%d_sp%.2f.csv',run,func,dim,sp);
%             filled_data = fillmissing(min_hist(1:2000),'previous');
%             csvwrite(filename, filled_data)
%         end
%     end
%     fprintf('\n\n\n')


end