%% features Takahashi deap mats

meanAllDeap = cell(32,1);
stdAllDeap = cell(32,1);
meanabsdiffAllDeap = cell(32,1);
meanabsdiffnorAllDeap = cell(32,1);
meanabs2diffAllDeap = cell(32,1);
meanabs2diffnorAllDeap = cell(32,1);
EEGfeatures = [];
GSRfeatures = [];

labelAllDeap = cell(32,1);
for i = 1:32
    if i < 10
        load(['../mats_deap/s0' num2str(i) '.mat']);
    else
        load(['../mats_deap/s' num2str(i) '.mat']);
    end
    
    % subject labels
    labelAllDeap{i} = labels;
    % mean
    meanSuj = mean(data,3);
    meanAllDeap{i} = meanSuj;
    % std
    stdSuj = std(data,0,3);
    stdAllDeap{i} = stdSuj; 
    % mean of differences
    meanabsdiff = mean(abs(diff(data,1,3)),3);
    meanabsdiffAllDeap{i} = meanabsdiff;
    % mean of normalized differences
    meanabsdiffnor = meanabsdiff./stdSuj;
    meanabsdiffnorAllDeap{i} = meanabsdiffnor;
    % mean of 2nd differences
    meanabs2diff = mean(abs(diff(data,2,3)),3);
    meanabs2diffAllDeap{i} = meanabs2diff;
    % mean of normalized 2nd differences
    meanabs2diffnor = meanabs2diff./stdSuj;
    meanabs2diffnorAllDeap{i} = meanabs2diffnor;
    
    EEGfeatures = [EEGfeatures; meanSuj(:,1:32) stdSuj(:,1:32) ...
        meanabsdiff(:,1:32) meanabsdiffnor(:,1:32) meanabs2diff(:,1:32) ...
        meanabs2diffnor(:,1:32)];
    GSRfeatures = [GSRfeatures; meanSuj(:,37) stdSuj(:,37) ...
        meanabsdiff(:,37) meanabsdiffnor(:,37) meanabs2diff(:,37) ...
        meanabs2diffnor(:,37)]; 
    clear data labels meanSuj i stdSuj meanabs2diffnor ... 
        meanabs2diff meanabsdiffnor meanabsdiff;
    
end

%% SVM Takahashi

%% labels and features videos

pos = label_all(:,1)>=6.33333;
neg = label_all(:,1)<3.66667;
neu = label_all(:,1)<6.33333 & label_all(:,1)>=3.66667;

labels = [];
labels(pos) = 1;
labels(neu) = 3;
labels(neg) = 2;
labels = labels';
labels = repmat(labels, [32,1]);

% pos = label_all(:,1)>=4.5;
% neg = label_all(:,1)<4.5;
% 
% labels = [];
% labels(pos) = 1;
% labels(neg) = 2;
% labels = labels';
% labels = repmat(labels, [32,1]);

% features
features = [EEGfeatures GSRfeatures];

N = length(labels);

%% SVM one-against-one

% split training/testing sets
[trainIdx testIdx] = crossvalind('HoldOut', labels, 1/3);
%[trainIdx testIdx] = crossvalind('LeaveMOut', N, 1);

pairwise = nchoosek(1:3,2);            %# 1-vs-1 pairwise models
svmModel = cell(size(pairwise,1),1);            %# store binary-classifers
predTest = zeros(sum(testIdx),numel(svmModel)); %# store binary predictions

% classify using one-against-one approach, SVM with 3rd degree poly kernel
for k=1:numel(svmModel)
    % get only training instances belonging to this pair
    idx = trainIdx & any( bsxfun(@eq, labels, pairwise(k,:)) , 2 );

    % train
    svmModel{k} = svmtrain(features(idx,:), labels(idx), ...
         'Kernel_Function','rbf', 'RBF_Sigma', 2 );

    % test
    predTest(:,k) = svmclassify(svmModel{k}, features(testIdx,:));
end
pred = mode(predTest,2);   % voting: clasify as the class receiving most votes

% performance
cmat = confusionmat(labels(testIdx),pred);
acc = 100*sum(diag(cmat))./sum(cmat(:));
fprintf('SVM (1-against-1):\naccuracy = %.2f%%\n', acc);
fprintf('Confusion Matrix:\n'), disp(cmat)

%% SVM one-against-all

itrain = sort(randsample(N,round(N*0.7))); 
itest = setdiff(1:N,itrain)';

smvStructs = Allsvm(features(itrain,:),labels(itrain),3);
disp('entrenamiento listo');
p = predictSVM(smvStructs,features(itest,:));
fprintf('\nTraining Set Accuracy: %f\n', mean(double(p == labels(itest))) * 100);
[C,order] = confusionmat(double(labels(itest)),p);

%% SVM one-against-all one-leave-out
pred = zeros(N,1);
for i = 1:N
    itrain = 1:N;
    itrain(i) = [];
    itest = i;
    smvStructs = Allsvm(features(itrain,:),labels(itrain),3);
    p = predictSVM(smvStructs,features(itest,:));
    pred(i,1) = mean(double(p == labels(itest))) * 100;
    display([num2str(i) ': ' num2str(pred(i,1)) ' - ' num2str(mean(pred))]);
end

res = mean(pred);
