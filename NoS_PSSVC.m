function [all_fitness, global_min, pop_history] = NoS_PSSVC(func_num, dim,seed)
% Parameter settings

rng(seed); %seed値を設定する
lb = -100 * ones(dim,1);%lower bound
ub = 100 * ones(dim,1);%upper bound
fhd = @(x)(cec15problems('eval',x,func_num));

maxFE = 2000; % maximum function evaluations
pop_size = 40; % number of population

pop_history.x = nan(pop_size, dim + 2, maxFE);
pop_history.y = nan(pop_size, maxFE);

all_fitness = nan(1,2000);

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

FE = 5*dim; %評価回数を更新


%評価値の良い順番に並び替え
[fit, index] = sort(fit); 
pop = pop(:,index);

% Main loop（最大評価回数を超える前繰り返す）
while FE < maxFE
    %pop_historyに保存
    pop_history.x(:,1,FE) = FE;
    pop_history.x(:,2,FE) = 1;
    pop_history.x(:,3:end,FE) = pop';
    pop_history.y(:,FE)=fit';
    
%     fprintf('FE: %d, Fitness: %.2e \n', FE, min(fit));
    % Update the global minimum fitness value if necessary
    current_min_fit = min(fit);
    if current_min_fit < global_min_fit
        global_min_fit = current_min_fit;
    end
    
    % Record the current global minimum fitness value
    global_min(FE,1) = global_min_fit;
%     fprintf('%.2e\n',min(fit));
     all_fitness(FE) = min(fit);
     
     
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
    
    %新たな子個体（交叉したものと突然変異させたものを組み合わせる）親の数と同じだけの量
    offspring = [offspringc offspringm];

    %classification for pre-selection
    pop = parent;
    fit = parentfit;
    
    for i = 1:pop_size
        reference = parentfit(i);
        offspringfit = fhd(offspring(:,i));
        
        FE = FE + 1;
        
        if offspringfit < reference
            pop(:,i) = offspring(:,i);
            fit(i) = offspringfit;
        end
        

        
        
    end
     
    
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
