function [ ageSummary, avgCoV ] = calculateAgeClusterSummary(Oages, result)
% This function calculates the comparison matrices for a result produced
% by the biclust function specifically for the Abalone Dataset. The ages
% for each row selected in a bicluster is extracted and the metrices are
% calculated for each cluster accordingly.
% This function will calculate Max, Min, Mean, Standard
% Deviation and Coefficient of Variance for each cluster's  age values 

% Matrices Calculated in each column (by Column Index)
% 1   -   Number of Rows in the Bicluster
% 2   -   Number of Columns in the Bicluster
% 3   -   Rows Selected for the Bicluster
% 4   -   Columns Selected for the Bicluster
% 5   -   Maximum Age Value in the Bicluter
% 6   -   Minimum Age Value in the Bicluster
% 7   -   Mean of all Ages Values in the Bicluster
% 8   -   Standard Deviation of Ages in the Bicluster
% 9   -   Coefficient of Variance of Ages in the Bicluster

m = result.ClusterNo; % Number of rows in the table i.e Number of Clusters 
n = 9; % Number of parameters to calculate

CoV = zeros(m,1);
ageSummary = {};

for i=1:m
    
    %Getting Number of Rows and Colums Selected
    rn = sum(result.RowxNum(:,i));
    cn = sum(result.NumxCol(i,:));
    
    %Selected Rows and Colums of the Bicluster
    r = result.Clust(i).rows;
    c = result.Clust(i).cols;
    
    %Extracting Age Values for Selected Rows in Bicluster
    cAges = Oages(r);
    
    aMax = max(cAges);                        % Max
    aMin = min(cAges);                        % Min
    aMean = mean(cAges);                      % Mean
    aStd = std(double(cAges));                % Standard Deviation
    CoV(i) = aStd/aMean;                      % Coefficient of Variance
    
    ageSummary = [ageSummary; {rn, cn, mat2str(r), mat2str(c), aMax, aMin,...
        aMean, aStd, CoV(i)}];
    
end

avgCoV = mean(CoV);

end
