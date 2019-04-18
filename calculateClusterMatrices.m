function [ summary ] = calculateClusterMatrices(M, result)
% This function calculates cluster matrices for a result produced by the
% biclust function. This function will calculate Max, Min, Mean, Standard
% Deviation and Variance for each cluster's values (i.e the submatrix
% formed by the row and columns selected by the biclust funciton for any
% algorithm in the MTBA Biclustering Library

% Matrices Calculated in each column (by Column Index)
% 1   -   Number of Rows in the Bicluster
% 2   -   Number of Columns in the Bicluster
% 3   -   Maximum Value in the Bicluter
% 4   -   Minimum Value in the Bicluster
% 5   -   Mean of all Values in the Bicluster
% 6   -   Mean of Standard Variance of elements in each column
% 7   -   Mean of Variance of elements in each column
% 8   -   Sum of Squared Error for each bicluster
m = result.ClusterNo; % Number of rows in the table i.e Number of Clusters 
n = 9; % Number of parameters to calculate
summary = zeros(m,n);

for i=1:m
    
    rn = sum(result.RowxNum(:,i));
    cn = sum(result.NumxCol(i,:));
    
    values = M(result.Clust(i).rows,result.Clust(i).cols);
    
    % Calculating Matrices here
    summary(i,1) = rn; % #Rows
    summary(i,2) = cn; % #Cols
    
    if (rn ~= 0) && (cn ~= 0)
        summary(i,3) = max(max(values));                        % Max
        summary(i,4) = min(min(values));                        % Min
        summary(i,5) = mean2(values);                           % Mean
        summary(i,6) = mean(std(values));                       % Mean Std
        summary(i,7) = mean(var(values));                       % Mean Var
        summary(i,8) = sum(sum((values - mean2(values)).^2));   % SSE
        summary(i,9) = ccscore(values);                         % H(I,J)
    else
        summary(i,3) = NaN;
        summary(i,4) = NaN;  
        summary(i,5) = NaN;
        summary(i,6) = NaN;
        summary(i,7) = NaN;
        summary(i,8) = NaN;
        summary(i,9) = NaN;
    end
end

end


% Calculate H(I,J)
function ccScore = ccscore(mat)
% Subtract row mean
a1 = bsxfun(@minus, mat, mean(mat,2));
% Subtract col mean
a2 = bsxfun(@minus, a1, mean(mat));
% Add matrix mean
a3 = bsxfun(@plus, a2, mean2(mat));
ccScore = sumsqr(a3)/(size(mat,1)*size(mat,2));
end