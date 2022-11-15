function [delayedTimeSeries] = TOOL_HankelShift(timeSeries, delayParameter)
% This function TOOL_HankelShift converts a time series into a delayed time
% series with regard to the delay parameter.
%
% A small example for a time delay embedding:
%                                               |x0 x1|
% [x0 x1 x2 x3] ----- delayParameter = 2 -----> |x1 x2|
%                                               |x2 x3|
%
% [delayedTimeSeries] = TOOL_HankelShift(timeSeries, delayParameter)
%
% Input: 
%   * timeSeries
%   * delayParameter
%
% Output: 
%   * delayedTimeSeries


[dim1,dim2] = size(timeSeries);

if (delayParameter >= dim2)
    error('The delayed time series could not be produced - the delay parameter is too large!')    
end

delayedTimeSeries = zeros(dim1*(delayParameter+1),dim2-delayParameter);

for k = 0:delayParameter
    delayedTimeSeries(k*dim1+1:(k+1)*dim1 , 1:end) = timeSeries(:,1+k:dim2-delayParameter+k);
end

end