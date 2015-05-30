%% mean gino mats
meanALL = cell(32,1);
for i = 1:32
    if i < 10
        load(['../mats_gino/s0' num2str(i) '.mat']);
    else
        load(['../mats_gino/s' num2str(i) '.mat']);
    end
    meanSuj = mean(data,2);
    meanSuj = permute(meanSuj,[1 3 2]);
    meanALL{i} = meanSuj;
    clear data times meanSuj;
end

%% mean deap mats
meanAllDeap = cell(32,1);
labelAllDeap = cell(32,1);
for i = 1:32
    if i < 10
        load(['../mats_deap/s0' num2str(i) '.mat']);
    else
        load(['../mats_deap/s' num2str(i) '.mat']);
    end
    meanSuj = mean(data,3);
    meanAllDeap{i} = meanSuj;
    labelAllDeap{i} = labels;  
    clear data labels meanSuj i;
end
