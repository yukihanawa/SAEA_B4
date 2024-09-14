function [arcv, global_min, correct_rate, pop_history] = GB_AFS_1( func_num, dim, seed, sp)
% Parameter settings

%精度の推移を記録する配列
correct_rate = [];

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

max_gen = 30;

% Initialize global_min_fit_history and global_min_fit
global_min = nan(maxFE,1);
global_min_fit = Inf;

fhd = @(x)(cec15problems('eval',x,func_num));

pop_history.x = nan(pop_size, dim + 2, maxFE);
pop_history.y = nan(pop_size, maxFE);

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
p_value_state = ones(1,pop_size);

stream = RandStream('mt19937ar','Seed',0);
stream1 = RandStream('mt19937ar','Seed',0); 

RandStream.setGlobalStream(stream);
% Main loop（最大評価回数を超える前繰り返す）
while fe < maxFE
    
    %pop_historyにほぞん
    pop_history.x(:,1,fe) = fe;
    pop_history.x(:,2,fe) = p_value_state;
    pop_history.x(:,3:end,fe) = pop';
    pop_history.y(:,fe) = fit';
    
    % Update the global minimum fitness value if necessary
    current_min_fit = min(arcv.y);
    if current_min_fit < global_min_fit
        global_min_fit = current_min_fit;
    end
    
    % Record the current global minimum fitness value
    global_min(fe,1) = global_min_fit;
    
    gen = 0;
    while gen < max_gen
        ssr = stream.randperm(pop_size); %1からpop_sizeまでの数字をランダムに並べたベクトルを作成
        parent = pop(:,ssr); %個体の座標を並べ直す
        parentfit = fit(:,ssr); %個体の評価値を並べ直す
        p_value_state = p_value_state(:,ssr);

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

            [offspringc(:, 2*k-1),offspringc(:, 2*k)] = Crossover(p1, p2, gamma,ub(1),lb(1),stream);
        end

        %突然変異
        parentm = pop(:, spm);
        offspringm = zeros(size(parentm));
        for k = 1: nm
            p = parentm(:, k);
            offspringm(:,k) = Mutate(p, mu, ub(1), lb(1),stream);
        end

        %新たな子個体（交叉したものと突然変異させたものを組み合わせる）
        offspring = [offspringc offspringm];

        % 評価値を予測（実評価関数を使う）
        offspring_fit_assumed = eval_pop(fhd, offspring);

        o_value_state = zeros(1,pop_size);


        % 予測値を元に並び替え
        [offspring_fit_assumed, index,~] = bubbleSort(offspring_fit_assumed,sp,stream1,o_value_state);
        
        offspring = offspring(:,index);


        %今回はサロゲートを学習しないので、省略

        %最良個体を残す
    %     [bestfit, index] = min(parentfit);
    %     bestind = parent(:, index);
    %     %最良個体を取り除く（後で付け足す）
    %     parent(:, index) = [];
    %     parentfit(index) = [];

           % 次世代に残る候補を集める（親、再評価された子個体、再評価されなかった子個体）
        pop = [parent offspring];
        fit = [parentfit offspring_fit_assumed];
        value_state = [p_value_state o_value_state];

        % 候補の評価値を元に並び替え
        [fit, index, value_state] = bubbleSort(fit,sp,stream1,value_state);
        pop = pop(:, index);

        
        % 次世代の個体と評価値を更新
        pop = pop(:,1:pop_size);
        fit = fit(1:pop_size);
        p_value_state = value_state(1:pop_size);
        gen = gen + 1;
    end
    
%     psm = floor(rsm * pop_size);%再評価する個体数
    %30世代回した後の最良個体をピックアップ
    % 再評価する個体を選ぶ（評価値が良いとされていたもの）
    reevaluate_pop = pop(:, 1);
    %再評価
    reevaluate_fit = eval_pop(fhd, reevaluate_pop);
    fe = fe + 1; %評価回数を更新
%     % ここでアーカイブを残す（座標、評価値→学習のため）
    arcv.x = [arcv.x;reevaluate_pop'];
    arcv.y = [arcv.y;reevaluate_fit'];
    
    p_value_state(:,1) = 1;

    
%     % 最良個体を追加している
%     pop = [bestind pop(:, 1:pop_size-1)];
%     fit = [bestfit fit(1:pop_size-1)];

    %fprintf('FE: %d, Fitness: %.2e \n', FE, min(fit));
%     fprintf('%.2e\n',min(fit));

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

