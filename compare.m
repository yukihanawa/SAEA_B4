clear;
dim = 30;
knn = [1*dim, 2*dim, 3*dim, 4*dim, 5*dim];
rsm = [0.1 0.2 0.5 0.7 0.9];

for run = 1:1:10
    seed = run*100 + 2019;
    fprintf('NoS is starting....')
    for func = [1 2 4 8 13 15]
        fprintf('func: %d', func);
        [evolve,min_hist] = NoS(func, dim, seed);
        filename = sprintf('nosresult/no_s_result_run%d_f%d_d%d.mat',run, func, dim);
        save(filename, 'evolve')
        filename = sprintf('nosresult_csv/nosresult_run%d_f%d_d%d.csv',run,func,dim);
        filled_data = fillmissing(min_hist(1:end),'previous');        
        csvwrite(filename, filled_data)
    end
    fprintf('\n\n\n')

    seed = run*100 + 2019;
    fprintf('PSSVC is starting....')
    for func = [1 2 4 8 13 15]
        for sp = [0.5 0.6 0.7 0.8 0.9 1.0]
            fprintf('func: %d', func);    
            [evolve, min_hist] = PSSVC( func, dim, seed, sp);
            filename = sprintf('pssvc/pssvc_run%d_f%d_d%d_sp%.2f.mat', run, func, dim,sp);
            save(filename, 'evolve')
            filename = sprintf('pssvc_csv/pssvc_run%d_f%d_d%d_sp%.2f.csv',run,func,dim,sp);
            filled_data = fillmissing(min_hist(1:end),'previous');
            csvwrite(filename, filled_data)
        end
    end
    fprintf('\n\n\n')
end