randomStreamDemo

function randomStreamDemo
    % 各関数用の乱数ストリームを作成
    stream1 = RandStream('mt19937ar', 'Seed', 0);
    stream2 = RandStream('mt19937ar', 'Seed', 0);

    for i = 1:5  % 5回のループを想定
        disp(['Iteration ' num2str(i)]);
        % function1とfunction2を呼び出し、それぞれのストリームを渡す
        function1(stream1);
        function2(stream2);
    end
end

function function1(stream)
    RandStream.setGlobalStream(stream);  % グローバルストリームを設定
    disp(randperm(stream, 10, 2));  % 10の中から2つのランダムな数値を選択
end

function function2(stream)
    RandStream.setGlobalStream(stream);  % 同じストリームを使用
    disp(randperm(stream, 10, 2));  % 同じランダム配列を生成
end