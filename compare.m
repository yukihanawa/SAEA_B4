clear;
dim = 10;
knn = [1*dim, 2*dim, 3*dim, 4*dim, 5*dim];
rsm = [0.1 0.2 0.5 0.7 0.9];

run = 1;


seed = run*100 + 2019;
fprintf('NoS is starting....')
for func = [1 2 4 8 13 15]
    fprintf('func: %d', func);
    evolve = NoS(func, dim, seed);
    filename = sprintf('nosresult/no_s_result_run%d_f%d_d%d.mat',run, func, dim);
    save(filename, 'evolve')
end
fprintf('\n\n\n')

seed = run*100 + 2019;
fprintf('PSSVC is starting....')
for func = [1 2 4 8 13 15]
    fprintf('func: %d', func);    
    evolve(j) = PSSVC( func, dim, seed, 0);
    filename = sprintf('psresult/svc_result_run%d_f%d_d%d.mat', run, func, dim);
    %     save(filename, 'evolve')
end
fprintf('\n\n\n')