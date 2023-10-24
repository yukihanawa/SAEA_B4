function [ arcv ] = IBrankSVM( func_num, dim, seed, knn, ~)


rng(seed);
lb = -100 * ones(dim, 1);
ub = 100 * ones(dim, 1);
fhd = @(x)(cec15problems('eval',x,func_num));


maxfe = 200 *dim;
pop_size =40;

% LHS database initilization
arcv.x = repmat(lb', 5*dim, 1) + lhsdesign(5*dim, dim, 'iterations', 1000) .* (repmat(ub' - lb', 5*dim, 1));
arcv.y = eval_pop(fhd, arcv.x')';

[arcv.y, index] = sort(arcv.y);
arcv.x = arcv.x(index, :);
fit = arcv.y(1:pop_size)';
pop = arcv.x(1:pop_size, :)';
fe = 5*dim;

% hyperparameter for GA
pc=0.7;                                  % crossover percentage
nc=2*round(pc*pop_size/2);      % number of offsprings (also Parnets)
gamma=0.4;                          % extra range factor for crossover

pm=0.3;                                 % mutation percentage
nm=round(pm*pop_size);           % number of mutants
mu=0.3;                                  % mutation rate


% sort population
[fit, index] = sort(fit);
pop = pop(:, index);

fprintf('FE: %d, Fitness: %.2e \n', fe, min(fit))

% arxiv 
% knn = 5 * dim;  %training size for each surrogate model 
psm = [];

% main loop
while fe < maxfe 
    
    ssr = randperm(pop_size);
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
        
        [offspringc(:, 2*k-1), offspringc(:, 2*k)]=Crossover(p1, p2, gamma, ub(1), lb(1));
        
    end
    
    
    % Mutation
    parentm = pop(:, spm);
    offspringm = zeros(size(parentm));
    for k=1:nm 
        
        p=parentm(:, k);
        
        offspringm(:, k)=Mutate(p,mu,ub(1), lb(1));
        
    end
    
    % 新たな子孫
    offspring = [offspringc offspringm];
    
    % ------------------------------------------
    % ----------------ランクベース model-----------
    % ------------------------------------------
    tau = 0; %ケンドールτ
    offspring_temp = offspring; %現在の子孫（一時的なコピー）
    test_points = [];% テストポイント
    test_points_fit = [];%テストポイントの評価値
    rsm = 0;%サロゲートモデルの計算回数
    
    while tau < 0.8 && size(offspring_temp, 2) ~= 0 %相関がまだ足りないor比較する子孫がまだ残っている時に続ける
        train = rank_traing_data(arcv, knn, offspring_temp'); %アーカイブ内の子孫に近いものがtrainに入る
        %訓練データの評価値でソート
        [train.y, index] = sort(train.y);
        train.x = train.x(index, :);
        
        %テストデータの用意
        test_x = [offspring_temp'; train.x]; %子孫と訓練データの座標
        ntraing = size(train.x, 1); %訓練データの要素の数
        ntesting = size(test_x, 1); %テストデータの要素の数
        
        %サロゲートモデルで順序を計算
        [ftrain_svm, ftest_svm] = GetSVMRank_FAST(train.x, test_x, ntraing, ntesting, dim, 0 , floor(50000 * (dim^0.5)));
        
        %親と子に分ける（それぞれの評価値を取得？）
        offspring_svm = ftest_svm(1:size(offspring_temp, 2));
        parent_svm = ftest_svm(size(offspring_temp, 2)+1: end);
        
        % 最もランクが高いものをテストポイントとして選択
        [test_point_svm, index] = max(offspring_svm);     
        test_point = offspring_temp(:, index);
        %テストポイントの評価値を実評価関数で計算する
        test_point_fit = fhd(test_point);
        fe = fe + 1;
        rsm = rsm + 1;
        
        % テストポイントとその評価値を記録
        test_points = [test_points test_point];
        test_points_fit = [test_points_fit test_point_fit];
        
        % ケンドールのτを計算
        tau = kendall(-1*test_point_svm, -1*parent_svm, test_point_fit, train.y);
        
        %アーカイブに追加
        arcv.x = [arcv.x; test_point'];
        arcv.y = [arcv.y; test_point_fit];
        %最もランクが高いものは省く
        offspring_temp(:, index) = [];
    end
    %サロゲートモデル使用率を計算
    psm = [psm; rsm/ size(offspring, 2)];
    
    %未評価の子孫が残っている場合
    if size(offspring_temp, 2) ~= 0
        pop = [parent test_points offspring_temp];
        test_x = pop'; ntesting = size(test_x, 1);
        [ftrain_svm, ftest_svm] = GetSVMRank_FAST(train.x, test_x, ntraing, ntesting, dim, 0 , floor(50000 * (dim^0.5)));
        
        %ランクでソート、最適な個体を選択
        [~, index] = sort(ftest_svm, 'descend');
        pop = pop(:, index(1:pop_size));
    end
    fprintf('FE: %d, Fitness: %.2e \n', fe, min(arcv.y))
    
end
    %サロゲートモデル使用率を計算
    arcv.psm  = psm;
end

function fit = eval_pop(f, pop)
    
    [dim, n] = size(pop);
    fit = zeros(1, n);
    for i = 1:n
        fit(i) = f(pop(:, i));
    end

end

function train = rank_traing_data(arx, k, pop)
    
    dis = pdist2(pop, arx.x);
    pop_size = size(pop, 1);
    train.x = [];
    train.y = [];
%     train.x = zeros(k, size(pop, 2));zz
    for i = 1:k
        j = mod(i, pop_size); 
        if j ==0
            j=pop_size;
        end
        [~, index] = min(dis(j, :));
        train.x = [train.x; arx.x(index, :)];
        train.y = [train.y; arx.y(index, :)];
        dis(:, index) = inf;
    end

end

function tau = kendall(x1, rank1, x2, rank2)

    tau = sum(sign(x1 - rank1) .* sign(x2 - rank2)) / length(rank1); 
    
end

% crossover operator
function [y1, y2]=Crossover(x1,x2,gamma,VarMax,VarMin)

    alpha=unifrnd(-gamma,1+gamma,size(x1));
    
    y1=alpha.*x1+(1-alpha).*x2;
    y2=alpha.*x2+(1-alpha).*x1;
    
    y1=max(y1,VarMin);
    y1=min(y1,VarMax);
    
    y2=max(y2,VarMin);
    y2=min(y2,VarMax);

end

% mutation operator
function y=Mutate(x,mu,VarMax,VarMin)
    
    nVar=size(x,1);
    nmu=ceil(mu*nVar);
    
   % original mutation     
%     j=randsample(nVar,nmu)';
%     
%     sigma=0.1*(VarMax-VarMin);
%     
%     y=x;
%     y(j)=x(j)+sigma*randn(size(j));
%     
%     y=max(y,VarMin);
%     y=min(y,VarMax);
    
    % uniform mutation 
    r = rand(nVar, 1) >= mu;
    y = unifrnd(VarMin, VarMax, nVar, 1);
    y(r) = x(r);

end





