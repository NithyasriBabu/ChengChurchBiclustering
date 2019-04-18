function [ cluster_names ] = RowNames( ClusterNo )
% Given a number, this function returns a vector with all the row names for
% a number of clusters. For Example if there are 3 clusters, it will return
% a list ['C1', 'C2', 'C3']

% Input: ClusterNo - Number of Clusters
% Output: cluster_names - List of Cluster Names for Table rows

cluster_names = {};

for i=1:ClusterNo
    rowName = strcat('C',num2str(i));
    cluster_names = [cluster_names; rowName];
end

end

