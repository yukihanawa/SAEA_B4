clear;
dim = 10;
knn = [1*dim, 2*dim, 3*dim, 4*dim, 5*dim];
rsm = [0.1 0.2 0.5 0.7 0.9];

for run = [1 2 3 4 5 6 7 8 9 10]
seed = run*100 + 2019;
fprintf('NoS is starting....')
for func = [1 2 4 8 13 15]
    fprintf('func: %d', func);
    evolve = NoS(func, dim, seed);
    filename = sprintf('nosresult/no_s_result_run%d_f%d_d%d.mat',run, func, dim);
    save(filename, 'evolve')
end
fprintf('\n\n\n')

% seed = run*100 + 2019;
% fprintf('PSSVC is starting....')
% for func = [1 2 4 8 13 15]
%     for sp = [0.5 0.6 0.7 0.8 0.9 1.0]
%         fprintf('func: %d', func);    
%         evolve = PSSVC( func, dim, seed, sp);
%         filename = sprintf('psresult/svc_result_run%d_f%d_d%d_sp%.2f.mat', run, func, dim,sp);
%         save(filename, 'evolve')
%     end
% end
% fprintf('\n\n\n')
end