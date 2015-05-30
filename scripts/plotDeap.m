%% histograms

for i = 1:32
    figure;
    suptitle(['histograms for subject ' num2str(i)]);
    for j = 1:40
        subplot(5,8,j);
        hist(meanAllDeap{i}(:,j));
        title(['Channel ' num2str(j)]);
    end
    print(['Histograms/Histograms subject ' num2str(i)],'-dpng');
end

%% scatter for valence

for i = 1:32
    figure;
    suptitle(['scatter for subject ' num2str(i)]);
    for j = 1:40
        subplot(5,8,j);
        scatter(meanAllDeap{i}(:,j), labelAllDeap{i}(:,1));
        title(['Channel ' num2str(j)]);
        xlabel('mean');
        ylabel('val');
    end
    print(['Scatters_Valence/Scatter subject ' num2str(i)],'-dpng');
end

%% scatter for arousal

for i = 1:32
    figure;
    suptitle(['scatter for subject ' num2str(i)]);
    for j = 1:40
        subplot(5,8,j);
        scatter(meanAllDeap{i}(:,j), labelAllDeap{i}(:,2));
        title(['Channel ' num2str(j)]);
        xlabel('mean');
        ylabel('aro');
    end
    print(['Scatters_Arousal/Scatter subject ' num2str(i)],'-dpng');
end

%% scatter for dominance

for i = 1:32
    figure;
    suptitle(['scatter for subject ' num2str(i)]);
    for j = 1:40
        subplot(5,8,j);
        scatter(meanAllDeap{i}(:,j), labelAllDeap{i}(:,3));
        title(['Channel ' num2str(j)]);
        xlabel('mean');
        ylabel('dom');
    end
    print(['Scatters_Dominance/Scatter subject ' num2str(i)],'-dpng');
end

%% scatter for liking

for i = 1:32
    figure;
    suptitle(['scatter for subject ' num2str(i)]);
    for j = 1:40
        subplot(5,8,j);
        scatter(meanAllDeap{i}(:,j), labelAllDeap{i}(:,4));
        title(['Channel ' num2str(j)]);
        xlabel('mean');
        ylabel('lik');
    end
    print(['Scatters_Liking/Scatter subject ' num2str(i)],'-dpng');
end