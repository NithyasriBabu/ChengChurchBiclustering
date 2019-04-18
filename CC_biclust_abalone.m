%% Importing Data

f = fopen('Capstone/abalone/abalone.data');
C = textscan(f,'%c,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%d');
fclose(f);

%% Enumerating Sex Column

sex_char = cell2mat(C(1));
sex = zeros(size(sex_char,1),1);

sex(sex_char=='M') = 0;
sex(sex_char=='F') = 1;
sex(sex_char=='I') = 2;

%% Extracting Age Colums
Oages = cell2mat(C(9));

%% Creating matrix for biclust Input
M = [sex cell2mat(C(2:8))];

%% Executing Biclust function for the input data

delta = [0.0001,0.0002,0.0003,0.0004,0.0005,0.0006,0.0007,0.0008,0.0009...
    0.001,0.002,0.003,0.004,0.005,0.006,0.007,0.008,0.009,0.01];

clusterNum = zeros(1,size(delta,2));

results = [];
for i = 1:size(delta,2)
    res = biclust(M,'cc','delta',delta(i),'numbiclust',500);
    results = [results; res];
    clusterNum(i) = res.ClusterNo;
    meanStd_clust = zeros(1,res.ClusterNo);
    for j = 1:res.ClusterNo
        values = M(res.Clust(j).rows,res.Clust(j).cols);
        meanStd_clust(j) = mean(std(values));
    end
    meanStd(i) = mean(meanStd_clust);
end

%%
figure;
plot(delta,clusterNum,'r');
legend('Number of Clusters');
title('Variation of Number of Clusters with Delta Value');
xlabel('Delta Value');
ylabel('Number of Clusters');

%%  extracting AvgCov
AvgCV = zeros(size(delta,2),1);

for i=1:size(results,1)
    [~,AvgCV(i)] = calculateAgeClusterSummary(Oages, results(i));
end

%% Comparing CoV values of each delta
% this value is expected to increase with increase in delta. This is
% because the lower the delta the lesser the variance of Age within a
% bicluster. So the lesser the variance the lesser the CoV

figure;
plot(delta,AvgCV,'b');
legend('Average Coefficient of Variance of all biclusters');
title('Comparing CoV over Delta');
xlabel('Delta Value');
ylabel('Average Coefficient of Variance');
xlim([0 0.001]);
ylim([0.2 0.4]);

%% Extracting all clusters
filename = strcat('results/CC_Abalone_',datestr(date),'_all.xlsx');

sheet1Rows = {};
sheet1Cols = {'DeltaValue', 'NumClusters','AverageCoV'};
contents = {};

AvgCV = zeros(size(delta,2),1);

for i=1:size(results,1)
    sheet1Rows = [sheet1Rows; strcat('Row',int2str(i))];
    AvgCV(i) = fileClusterSummaryAb(M,Oages, results(i),delta(i),filename);
    contents = [contents; {delta(i),results(i).ClusterNo,AvgCV(i)}];
end

contents_table = cell2table(contents,'RowNames',sheet1Rows,'VariableNames',sheet1Cols);
contents_table.Properties.DimensionNames = {'AvailContents','Values'};

writetable(contents_table,filename,'FileType','spreadsheet','WriteRowNames',true,...
    'Sheet','Sheet1','Range','B2');

fprintf('Clusters selected and Exported Successfully\n');