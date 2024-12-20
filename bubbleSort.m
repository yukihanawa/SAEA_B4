function [sortedArray,index,value_state] = bubbleSort(array,accuracy,stream1,value_state)

n = length(array);
index = 1:n;
for i = 1:n
    for j = 1:n-i
        %両方とも実評価の場合
        if (value_state(j) == 1 && value_state(j+1) == 1)
            if(array(j)>array(j+1))
                [array(j),array(j+1)] = swap(array(j),array(j+1));
                %indexの入れ替え
                [index(j),index(j+1)] = swap(index(j),index(j+1));
                %value_stateの入れ替え
                [value_state(j),value_state(j+1)] = swap(value_state(j),value_state(j+1));
            end
        %片方が予測値の場合
        else        
            if(accuracy > rand(stream1,1)) %予測が正しい
                if(array(j) > array(j+1))
                    [array(j),array(j+1)] = swap(array(j),array(j+1));
                    %indexの入れ替え
                    [index(j),index(j+1)] = swap(index(j),index(j+1));
                    %value_stateの入れ替え
                    [value_state(j),value_state(j+1)] = swap(value_state(j),value_state(j+1));
                end
            else    %予測が誤り
                if(array(j) < array(j+1))
                    [array(j),array(j+1)] = swap(array(j),array(j+1));
                    %indexの入れ替え
                    [index(j),index(j+1)] = swap(index(j),index(j+1));
                    %value_stateの入れ替え
                    [value_state(j),value_state(j+1)] = swap(value_state(j),value_state(j+1));
                end
            end
        end   
    end
end
sortedArray = array;
end
