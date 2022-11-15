function [v] = TOOL_DiagonalAveragingMulti(A,d)
% This function TOOL_DiagonalAveragingMulti diagonal averages time delayed
% data, which was originally multivariate. Therefore, an additional input
% in form of the delay parameter is needed.
%
% A small example for the diagonal averaging:
% |x11 x12|
% |x21 x22| ----- diagonal averaging -----> [x11 x21+x12 x31+x22 x32]
% |x31 x32|
%
% [delayedTimeSeries] = TOOL_DiagonalAveraging(timeSeries, delayParameter)
%
% Input: 
%   * A     matrix / time delayed data
%   * d     delay parameter
%
% Output: 
%   * v     diagonal averaged data


[n,tmp_m] = size(A);
m = tmp_m - 1;

N = n/(d+1);

if(~(mod(N,1) == 0))
    error('somethings wrong with the dimension of the delay embedding and the diagonal averaging'); 
end


if d == 0
    v = A;
    return
end

v = zeros(N,d+m+1);

i = 1;
for k = -d:m
    
    if(k<0)
        numDiagElements = min(d+1+k,m+1);
        row_start = 1+N*(d+k);
        col_start = 1;
    else
        numDiagElements = min(m+1-k,d+1);
        row_start = 1+N*d;
        col_start = 1+k;
    end
    
    diag_vec = zeros(N,1);
    for l = 0:numDiagElements-1
        diag_vec = diag_vec + A( (row_start-l*N):(row_start-l*N)+(N-1) , col_start+l );
    end


    v(:,i) = diag_vec/numDiagElements;
    
    i = i+1;
end


end