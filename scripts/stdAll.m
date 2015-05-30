%% std gino mats
stdALL = cell(32,1);
for i = 1:32
    if i < 10
        load(['../s0' num2str(i) '.mat']);
    else
        load(['../s' num2str(i) '.mat']);
    end
    stdSuj = std(data,0,2);
    stdSuj = permute(stdSuj,[1 3 2]);
    stdALL{i} = stdSuj;
    clear data times;
end

%% mean deap mats
stdAllDeap = cell(32,1);
labelAllDeap = cell(32,1);
for i = 1:32
    if i < 10
        load(['../mats_deap/s0' num2str(i) '.mat']);
    else
        load(['../mats_deap/s' num2str(i) '.mat']);
    end
    stdSuj = std(data,0,3);
    stdAllDeap{i} = stdSuj;
    labelAllDeap{i} = labels;  
    clear data labels stdSuj;
end