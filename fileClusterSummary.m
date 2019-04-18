function fileClusterSummary(M, result, parameter, filename)
% Given a result it will extract the number of rows and columns for each
% cluster and also print cluster matrices for each cluster in the result

% Input:
% f - File variable containing the file in which it is saved
% M - Original Matrix values of the input data
% result - biclust function output for the given clustering algorithm

% Written By: Nithyasri Babu, 2019

summarySheetName = strcat('Summary','_',num2str(parameter),'_',int2str(result.ClusterNo));
colAlpha = 'B';
srowCount = 2;

summary = calculateClusterMatrices(M,result);
summary_table = array2table(summary,'RowNames',RowNames(result.ClusterNo),...
    'VariableNames',{'NumRows','NumColums','Maximum','Minimum','Mean','Mean_Std','Mean_Var','SSE','MeanSqResidual'});
summary_table.Properties.DimensionNames = {'Clusters','ComparisonMatrices'};

range = strcat(colAlpha,int2str(srowCount));
writetable(summary_table,filename,'FileType','spreadsheet','WriteRowNames',true,...
    'Sheet',summarySheetName,'Range',range);

% Writing Table Number of Rows and Cols and selected rows and cols for each
% cluster

rowcols = {};
cluster_values = {};

clusterSheetName = strcat('ClusterValues','_',num2str(parameter),'_',int2str(result.ClusterNo));
crowCount = 2;

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
     
     ctable = array2table(M(r,c),'RowNames',rnames,'VariableNames',cnames);
     ctable.Properties.DimensionNames = {cluster_name,...
         strcat(cluster_name,'Columns')};
     
     range = strcat(colAlpha,int2str(crowCount));
     
     writetable(ctable,filename,'FileType','spreadsheet','WriteRowNames',true,...
         'Sheet',clusterSheetName,'Range',range);
     
     crowCount = crowCount + 1 + rn + 2;
     
     %Adding Values to table:
     cell_row = {rn, cn, mat2str(r), mat2str(c)};
     rowcols = [rowcols; cell_row];
     
end

rowcol_table = cell2table(rowcols,'RowNames',RowNames(result.ClusterNo),...
    'VariableNames',{'NumRows','NumColumns','ClusteredRows','ClusteredColumns'});
rowcol_table.Properties.DimensionNames = {'Clusters','ClusterRowsColumns'};

srowCount = srowCount + result.ClusterNo + 2;
range = strcat(colAlpha,int2str(srowCount));

writetable(rowcol_table,filename,'FileType','spreadsheet','WriteRowNames',true,...
    'Sheet',summarySheetName,'Range',range);
end