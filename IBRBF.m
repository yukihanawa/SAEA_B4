function [arcv, global_min] = IBRBF( func_num, dim, seed, sp)
% Parameter settings


psr = 0.5;%pre-selection rate

rng(seed); %seed値を設定する
lb = -100 * ones(dim,1);%lower bound
ub = 100 * ones(dim,1);%upper bound

maxFE = 200*dim; % maximum function evaluations
pop_size = 40; % number of population

rsm = 0.5;

% parameter
pc = 0.7; %交叉率
nc = 2 * round(pc * pop_size/2); %子孫の数
gamma = 0.4; %extra range factor for crossover

pm = 0.3; %突然変異率
nm = round(pm*pop_size); %突然変異数
mu = 0.3;

% Initialize global_min_fit_history and global_min_fit
global_min = nan(maxFE,1);
global_min_fit = Inf;

fhd = @(x)(cec15problems('eval',x,func_num));

%LHS(Latin Hypercube Sampling)を使ってサンプルを生成
arcv.x = repmat(lb', 5*dim,1) + lhsdesign(5*dim,dim, 'iterations',1000).*(repmat(ub' - lb', 5*dim, 1));
%サンプルを評価
arcv.y = eval_pop(fhd, arcv.x')';
%ソート
[arcv.y, index] = sort(arcv.y); % 昇順でソート
arcv.x = arcv.x(index,:); % ソートされたインデックスを使用して、arcv.x(index,:)をソート
%初期集団の選択
fit = arcv.y(1:pop_size)';% 評価値
pop = arcv.x(1:pop_size,:)';% 集団

fe = 5*dim; %評価回数を更新


%評価値の良い順番に並び替え
[fit, index] = sort(fit); 
pop = pop(:,index);

% Main loop（最大評価回数を超える前繰り返す）
while fe < maxFE
    
    % Update the global minimum fitness value if necessary
    current_min_fit = min(fit);
    if current_min_fit < global_min_fit
        global_min_fit = current_min_fit;
    end
    
    % Record the current global minimum fitness value
    global_min(fe,1) = global_min_fit;
    ssr = randperm(pop_size); %1からpop_sizeまでの数字をランダムに並べたベクトルを作成
    parent = pop(:,ssr); %個体の座標を並べ直す
    parentfit = fit(:,ssr); %個体の評価値を並べ直す
    
    %交叉に使う親個体を選択
    spc = ssr(1:nc);
    %突然変異させる親個体を選択（交叉しなかった親全部）
    spm = ssr(nc+1: end);
    
    %交叉
    parentc = pop(:, spc);
    offspringc = zeros(size(parentc));
    for k=1:nc/2
        p1 = parentc(:, 2*k-1);
        p2 = parentc(:, 2*k);
        
        [offspringc(:, 2*k-1),offspringc(:, 2*k)] = Crossover(p1, p2, gamma,ub(1),lb(1));
    end
    
    %突然変異
    parentm = pop(:, spm);
    offspringm = zeros(size(parentm));
    for k = 1: nm
        p = parentm(:, k);
        offspringm(:,k) = Mutate(p, mu, ub(1), lb(1));
    end
    
    %新たな子個体（交叉したものと突然変異させたものを組み合わせる）
    offspring = [offspringc offspringm];

    % 再評価の割合
    psm = floor(rsm * pop_size);  % 実評価関数によって評価される個体数
    

    % 評価値を予測（実評価関数を使う）
    offspring_fit_assumed = eval_pop(fhd, offspring);
    
    
    % 予測値を元に並び替え
    [sorted_fit, index] = sort(offspring_fit_assumed);

    % 再評価する個体を選ぶ（評価値が良いとされていたもの）
    reevaluate_pop = offspring(:, index(1:psm));
    %再評価
    reevaluate_fit = eval_pop(fhd, reevaluate_pop);
    fe = fe + psm;  % 評価回数を更新

    % 本当はここでアーカイブを残す（座標、評価値→学習のため）
    %今回はサロゲートを学習しないので、省略
    
    %最良個体を残す
    [bestfit, index] = min(parentfit);
    bestind = parent(:, index);
    %最良個体を取り除く（後で付け足す）
    parent(:, index) = [];
    parentfit(index) = [];

       % 次世代に残る候補を集める（親、再評価された子個体、再評価されなかった子個体）
    pop = [parent reevaluate_pop  offspring(:, index(psm+1:end))];
    fit = [parentfit reevaluate_fit offspring_fit_assumed(index(psm+1:end))];

    % 候補の評価値を元に並び替え
    [fit, index] = sort(fit);
    pop = pop(:, index);
    
    % 精度に基づいて個体を選ぶ
    n_select = round(sp * pop_size);  % 精度に基づいて選ぶ個体数
    n_random = pop_size - n_select;   % ランダムに選ぶ個体数
    
    % 精度に基づいて選ばれた個体とランダムに選ばれた個体
    selected_pop = pop(:, 1:n_select);
    random_index = randperm(size(pop, 2), n_random);
    random_pop = pop(:, random_index);
    
    % 精度に基づいて選ばれた評価値とランダムに選ばれた評価値
    selected_fit = fit(1:n_select);
    random_fit = fit(random_index);
    
    % 次世代の個体と評価値
    pop = [selected_pop, random_pop];
    fit = [selected_fit, random_fit];
    
    % 最良個体を追加している
    [bestfit, index] = min(fit);
    bestind = pop(:, index);
    pop(:, index) = [];
    fit(index) = [];
    pop = [bestind pop(:, 1:pop_size-1)];
    fit = [bestfit fit(1:pop_size-1)];


    %fprintf('FE: %d, Fitness: %.2e \n', FE, min(fit));
    fprintf('%.2e\n',min(fit));

end  
end


%評価値を計算
function fit = eval_pop(f, pop)
    
    [~ , n] = size(pop);
    fit = zeros(1, n);
    for i = 1:n
        fit(i) = f(pop(:, i));
    end

end


% 交叉関数
function [y1, y2]=Crossover(x1,x2,gamma,VarMax,VarMin)

    alpha=unifrnd(-gamma,1+gamma,size(x1));
    
    y1=alpha.*x1+(1-alpha).*x2;
    y2=alpha.*x2+(1-alpha).*x1;
    
    y1=max(y1,VarMin);
    y1=min(y1,VarMax);
    
    y2=max(y2,VarMin);
    y2=min(y2,VarMax);

end

% 突然変異関数
function y=Mutate(x,mu,VarMax,VarMin)
    
    nVar=size(x,1);
    %nmu=ceil(mu*nVar);
    
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
