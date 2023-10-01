% Parameter settings
seed = 1;
dim = 2;
psr = 0.5;%pre-selection rate

rng(seed); %seed値を設定する
lb = -100 * ones(dim,1);%lower bound
ub = 100 * ones(dim,1);%upper bound

maxFE = 200*dim; % maximum function evaluations
pop_size = 40; % number of population

%LHS(Latin Hypercube Sampling)を使ってサンプルを生成
arcv.x = repmat(lb', 5*dim,1) + lhsdesign(5*dim,dim, 'iterations',1000).*(repmat(ub' - lb', 5*dim, 1));
%サンプルを評価
arcv.y = eval_pop(fhd, arc.x')';
%ソート
[arcv.y, index] = sort(arcv.y); % 昇順でソート
arcv.x = arcv.x(index,:); % ソートされたインデックスを使用して、arcv.x(index,:)をソート
%初期集団の選択
fit = arcv.y(1:pop_size)';% 評価値
pop = arcv.x(1:pop_size,:)';% 集団

FE = 5*dim; %評価回数を更新

% parameter
pc = 0.7; %交叉率
nc = 2 * round(pc * pip_size/2); %子孫の数
gamma = 0.4; %extra range factor for crossover

pm = 0.3; %突然変異率
nm = round(pm*pop_size); %突然変異数

%評価値の良い順番に並び替え
[fit, index] = sort(fit); 
pop = pop(:,index);

% Main loop（最大評価回数を超える前繰り返す）
while FE < maxFE
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
    
    %新たな子個体
    offspring = [offspringc offspringm];

    % 再評価の割合
    psm = floor(rsm * pop_size);  % 実評価関数によって評価される個体数

    % 評価値を予測（実評価関数を使う（ノイズあり））
    offspring_fit_assumed = eval_pop(fhd_noise, offspring);
    fe = fe + pop_size;  % 評価回数を更新
    
    % 予測値を元に並び替え
    [sorted_fit, index] = sort(offspring_fit_assumed);

    % 再評価する個体を選ぶ
    reevaluate_pop = offspring(:, index(1:psm));
    reevaluate_fit = sorted_fit(1:psm);

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
    fit = [parentfit reevaluate_fit sorted_fit(index(psm+1:end))];

    % 候補の評価値を元に並び替え
    [fit, index] = sort(fit);
    pop = pop(:, index);

    % 最良個体を追加している
    pop = [bestind pop(:, 1:pop_size-1)];
    fit = [bestfit fit(:, 1:pop_size-1)];

    fprintf('FE: %d, Fitness: %.2e \n', fe, min(arcv.y));

end  

% Helper functions (You need to fill these up)
function pop = initializePopulation(N)
    % Return initial population of size N
    pop = rand(N,2); % 2次元配列を作成
end

function fit = evaluatePopulation(pop)
    % Evaluate the fitness of the population
    fit = sum(pop,2); % Example: sum of elements
end

function candidate = generateCandidate()
    % Generate a single offspring candidate
    candidate = rand(1,1); % Example: random value
end

function model = buildSurrogateModel(pop, fit)
    % Return the surrogate model based on the population and their fitness values
    model = fit; % Placeholder
end

function predicted = predictFitness(model, candidate)
    % Predict the fitness of the candidate using the surrogate model
    predicted = sum(candidate); % Example: sum of elements
end

function actual = reEvaluate(candidate)
    % Re-evaluate the fitness of the candidate
    actual = sum(candidate); % Example: sum of elements
end

function [newPop, newFit] = selectBestIndividuals(pop, offspring, fit, N)
    % Select the N best individuals
    [~, idx] = sort(fit, 'descend'); % Example: sort in descending order
    newPop = pop(idx(1:N),:);
    newFit = fit(idx(1:N));
end

function y = fitness(x1,x2)
    y = x1 * x2;
end

