function [v] = TOOL_DiagonalAveraging(A)
% This function TOOL_DiagonalAveraging diagonal averages time delayed
% data, which was originally univariate.
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
%
% Output: 
%   * v     diagonal averaged data

[n,m]=size(A);

if n == 1
    v = A;
    return
end

A = flipud(A);
v = zeros(1,n+m-1);

i = 1;
for d = -(n-1):(m-1)
    v(i) = mean(diag(A,d));
    i = i+1;
end

end
