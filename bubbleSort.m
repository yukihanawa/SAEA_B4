function [sortedArray,index] = bubbleSort(array,accuracy,stream1)

n = length(array);
index = 1:n;
for i = 1:n
    for j = 1:n-i
        if array(j)>array(j+1)
%             disp(rand(stream1,1));
            if(accuracy > rand(stream1,1))
                temp = array(j);
                array(j) = array(j+1);
                array(j+1) = temp;
                %indexの入れ替え
                tempIndex = index(j);
                index(j) = index(j+1);
                index(j+1)=tempIndex;
            end
        end
    end
end
sortedArray = array;
end

