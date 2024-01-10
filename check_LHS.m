clear;
sp = 1.0;
pop_size = 40;
current_pop_size = 80;
% spに基づいてランダムに残す個体数を計算
    n_remain = round(sp * pop_size)

    n_remain_bad = pop_size - n_remain
% fprintf('%d',c(1));