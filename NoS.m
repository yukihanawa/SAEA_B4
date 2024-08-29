function [arcv, global_min] = NoS(func_num, dim, seed)


rng(seed);


lb = -100 * ones(dim, 1);
ub = 100 * ones(dim, 1);
fhd = @(x)(cec15problems('eval',x,func_num));

maxFE = 2000;
pop_size =40;

% LHS database initilization
arcv.x = repmat(lb', 5*dim, 1) + lhsdesign(5*dim, dim, 'iterations', 1000) .* (repmat(ub' - lb', 5*dim, 1));
arcv.y = eval_pop(fhd, arcv.x')';

[arcv.y, index] = sort(arcv.y);%昇順でソート
arcv.x = arcv.x(index, :);%ソートされたインデックスを使用して、arcv.x(index,:)をソート
%初期集団の選択
fit = arcv.y(1:pop_size)';%評価値（上位pop_size分だけ）
pop = arcv.x(1:pop_size, :)';%集団
fe = 5*dim;

% hyperparameter for GA
pc=0.7;                                  % crossover percentage
nc=2*round(pc*pop_size/2);      % number of offsprings (also Parnets)
gamma=0.4;                          % extra range factor for crossover

pm=0.3;                                 % mutation percentage
nm=round(pm*pop_size);           % number of mutants
mu=0.3;                                  % mutation rate

% Initialize global_min_fit_history and global_min_fit
global_min = nan(maxFE,1);
global_min_fit = Inf;

stream = RandStream('mt19937ar','Seed',0);
RandStream.setGlobalStream(stream);

% main loop
while fe < maxFE 
%     fprintf('FE: %d, Fitness: %.2e \n', fe, min(fit))
    % Update the global minimum fitness value if necessary
    current_min_fit = min(fit);
    if current_min_fit < global_min_fit
        global_min_fit = current_min_fit;
    end
    
    % Record the current global minimum fitness value
    global_min(fe,1) = global_min_fit;
    
    ssr = stream.randperm(pop_size);
    parent = pop(:, ssr);
    parentfit = fit(:, ssr);
    
    % select parents for crossover
    spc = ssr(1: nc);
    % select parents for mutation
    spm = ssr(nc+1: end);
    
    % Crossover
    parentc = pop(:, spc);
    offspringc = zeros(size(parentc));
    for k=1:nc/2
        
        p1=parentc(:, 2*k-1);
        p2=parentc(:, 2*k);
        
        [offspringc(:, 2*k-1), offspringc(:, 2*k)]=Crossover(p1, p2, gamma, ub(1), lb(1),stream);
        
    end
    
    
    % Mutation
    parentm = pop(:, spm);
    offspringm = zeros(size(parentm));
    for k=1:nm 
        
        p=parentm(:, k);
        
        offspringm(:, k)=Mutate(p,mu,ub(1), lb(1),stream);
        
    end
    
%     sort(eval_pop(fhd,offspringm))
    
    % new offspring
    offspring = [offspringc offspringm];

    
    % --------------No Surrogate---------------
    offspringfit = eval_pop(fhd, offspring);        
    fe = fe + size(offspring, 2);%size(,2)は2番目の次元の長さを返す
    arcv.x = [arcv.x; offspring'];
    arcv.y = [arcv.y; offspringfit'];
    
    % Merge the parent and offspring
    pop = [parent offspring];
    fit = [parentfit offspringfit];
    
    % Select new parents
    [fit, index] = sort(fit);
    pop = pop(:, index);
    
    % Truncation
    pop = pop(:, 1:pop_size);
    fit = fit(:, 1:pop_size);

end
end

function fit = eval_pop(f, pop)
    
    [dim, n] = size(pop);
    fit = zeros(1, n);
    for i = 1:n
        fit(i) = f(pop(:, i));
    end

end


% 交叉関数
function [y1, y2] = Crossover(x1, x2, gamma, VarMax, VarMin, stream)
    alpha = stream.rand(size(x1)) * (1 + 2 * gamma) - gamma;  % 乱数ストリームを使用

    y1 = alpha .* x1 + (1 - alpha) .* x2;
    y2 = alpha .* x2 + (1 - alpha) .* x1;

    y1 = max(y1, VarMin);
    y1 = min(y1, VarMax);

    y2 = max(y2, VarMin);
    y2 = min(y2, VarMax);
end


% 突然変異関数
% 突然変異関数
function y = Mutate(x, mu, VarMax, VarMin, stream)
    nVar = size(x, 1);
    r = stream.rand(nVar, 1) < mu;  % 乱数ストリームを使用

    y = x;
    y(r) = stream.rand(sum(r), 1) * (VarMax - VarMin) + VarMin;  % 乱数ストリームを使用

    y = max(y, VarMin);
    y = min(y, VarMax);
end
