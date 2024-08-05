dim = 10;
psm = 6;

index = 1:1:10;
value_state = zeros(1,dim);

value_state(:,index(1:psm)) = 1;

for i = 1:1:10
    fprintf('%d, ',value_state(i));
end
fprintf('\n');