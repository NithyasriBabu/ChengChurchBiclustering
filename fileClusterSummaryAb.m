function [avgCV] = fileClusterSummaryAb(M, Oages, result, parameter, filename)
% Given a result it will extract the number of rows and columns for each
% cluster and also print cluster matrices for each cluster in the result

% Input:
% M - Original Matrix values of the input data
% Oages - Original vector containing Age values for all rows
% result - Results array from biclust function output for a delta values
% parameter - Delta Value
% filename - Name of the file summary needs to be written to

% Written By: Nithyasri Babu, 2019

summarySheetName = strcat('Summary_delta_',num2str(parameter));

[ageSummary, avgCV] = calculateAgeClusterSummary(Oages,result);

age_table = cell2table(ageSummary,'RowNames',RowNames(result.ClusterNo),...
    'VariableNames',{'NumRows','NumColums','Rows','Columns',...
    'MaxAges','MinAges','MeanAges','AgesStD','AgesCV'});
age_table.Properties.DimensionNames = {'Clusters','ComparisonMatrices'};

writetable(age_table,filename,'FileType','spreadsheet','WriteRowNames',true,...
    'Sheet',summarySheetName,'Range','B2');


colAlpha = 'B';
crowCount = 5;
range = strcat(colAlpha,int2str(crowCount));

clusterSheetName = strcat('ClusterValues','delta_',num2str(parameter));

rnames = {'Delta','NumberBiClusters'};
cnames = {'Values'};
values = {parameter; result.ClusterNo};

title_table = cell2table(values,'RowNames',rnames,'VariableNames',cnames);
title_table.Properties.DimensionNames = {'Parameters','ComparisonMatrices'};
writetable(title_table,filename,'FileType','spreadsheet','WriteRowNames',true,...
    'Sheet',clusterSheetName,'Range','B2');

for i = 1:result.ClusterNo

    % ClusterNames
    cluster_name = strcat('Cluster',int2str(i));
    
    %Getting Number of Rows and Colums Selected
    rn = sum(result.RowxNum(:,i));
    cn = sum(result.NumxCol(i,:));
     
    %Extracting Data from the original matrix
    r = result.Clust(i).rows;
    c = result.Clust(i).cols;
    
    rnames = strsplit(mat2str(r),{' ',';','[',']'});
    rnames = strcat('Row',rnames(1,2:size(rnames,2)-1));
    
    cnames = strsplit(mat2str(c),{' ',';','[',']'});
    cnames = strcat('Col',cnames(1,2:size(cnames,2)-1));
    cnames = [cnames 'Age'];
    
    ctable = array2table([M(r,c) double(Oages(r))],'RowNames',rnames,'VariableNames',cnames);
    ctable.Properties.DimensionNames = {cluster_name,...
        strcat(cluster_name,'Columns')};
     
    range = strcat(colAlpha,int2str(crowCount));
     
    writetable(ctable,filename,'FileType','spreadsheet','WriteRowNames',true,...
         'Sheet',clusterSheetName,'Range',range);
     
    crowCount = crowCount + 1 + rn + 2;     
end

end