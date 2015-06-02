%% categories

positive = label_all(label_all(:,1)>=6.33333,1);
negative = label_all(label_all(:,1)<3.66667,1);
neutral = label_all(label_all(:,1)<6.33333 & label_all(:,1)>=3.66667,1);

cats = [1 3.66667 6.33333 9];
bincounts = histc(label_all(:,1),cats);
figure;
bar(cats(1:3),bincounts(1:3),'histc');
title('Quantity per category');
ylabel('Quantity');
xlabel('Valence');

%% signal per label

pos = label_all(:,1)>=6.33333;
neg = label_all(:,1)<3.66667;
neu = label_all(:,1)<6.33333 & label_all(:,1)>=3.66667;


signalAllDeap = cell(32,1);
for i = 1:32
    if i < 10
        load(['../mats_deap/s0' num2str(i) '.mat']);
    else
        load(['../mats_deap/s' num2str(i) '.mat']);
    end
    avgsigneg = mean(data(neg,:,:),1);
    avgsigpos = mean(data(pos,:,:),1);
    avgsigneu = mean(data(neu,:,:),1);
    avgsigneg = permute(avgsigneg, [3 2 1]);
    avgsigpos = permute(avgsigpos, [3 2 1]);
    avgsigneu = permute(avgsigneu, [3 2 1]);
    signalAllDeap{i} = [mean(avgsigneg(:,1:32),2) mean(avgsigpos(:,1:32),2) mean(avgsigneu(:,1:32),2)];  
    clear data labels avgsigneg avgsigpos avgsigneu i;
end



