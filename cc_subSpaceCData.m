M = xlsread('SubspaceClusterMR-Data2.xlsx');

%% Variation with Delta
%Different values of Delta
%Closer the value is to 1, More the clusters formed
%warning issued for values below 1.2

delta = linspace(0.00001,0.001,100);
clusterNum = zeros(1,size(delta,2));
meanStd = zeros(1,size(delta,2));

results = [];
for i = 1:size(delta,2)
    res = biclust(M,'cc','delta',delta(i));
    results = [results; res];
    clusterNum(i) = res.ClusterNo;
    CV = zeros(1,res.ClusterNo);
    for j = 1:res.ClusterNo
        values = M(res.Clust(j).rows,res.Clust(j).cols);
        CV(j) = mean(var(values));
    end
    meanStd(i) = mean(CV);
end

%%
figure;
plot(delta,clusterNum,'r',delta,meanStd,'b');
legend('#Clusters Vs Delta','Mean Standard Deviation Vs Delta');
title('Effect of Various Deltas on the # Clusters and Mean StD');
xlabel('Delta Value');
ylabel('#Clusters / Mean StD');

%% Exporting all Results to file
filename = strcat('CC_',datestr(date),'_all.xlsx');

sheet1Rows = {};
sheet1Cols = {'DeltaValue', 'MeanStd','NumClusters'};

contents = {};
for i=1:size(results,1)
    sheet1Rows = [sheet1Rows; strcat('Row',int2str(i))];
    fileClusterSummary(M,results(i),delta(i),filename);
    contents = [contents; {delta(i),meanStd(i),results(i).ClusterNo}];
end

contents_table = cell2table(contents,'RowNames',sheet1Rows,'VariableNames',sheet1Cols);
contents_table.Properties.DimensionNames = {'AvailContents','Values'};
writetable(contents_table,filename,'FileType','spreadsheet','WriteRowNames',true,...
    'Sheet','Sheet1','Range','B2');

fprintf('Clusters selected and Exported Successfully');