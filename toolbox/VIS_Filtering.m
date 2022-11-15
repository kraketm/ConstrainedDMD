function [DMD] = VIS_Filtering(DMD, epsTrend, epsFreq)
% This function VIS_Filtering implements the filtering technique, where
% DMD components are sorted by their influence and grouped into the three 
% categories: trend, seasonal, and residual patterns. For more details,
% please have a look into the related publication.
%
%
% [DMD] = VIS_Filtering(DMD, epsTrend, epsFreq)
%
% Input: A struct DMD as well as two parameters:
%   * DMD.lambda
%   * DMD.ThetaScaled
%   * DMD.influenceDiagK
%   * epsTrend
%   * epsFreq
%
% Output: 
%   * DMD.lambdaSort
%   * DMD.ThetaScaledSort
%   * DMD.influenceDiagKSort
%   * DMD.filtering


% Sort (index of) the DMD eigenvalues, scaled DMD modes, and their related 
% influence according to the location of the DMD eigenvalue
[DMD.lambdaSort, DMD.ThetaScaledSort, DMD.influenceDiagKSort] = DMD_Sort(DMD.lambda,DMD.ThetaScaled,DMD.influenceDiagK,1e-6);
    
% Group DMD components according to Eq. 22, Eq. 23, and Eq. 24 
lambdaSortTrendBin = (abs(imag(DMD.lambdaSort)) < epsTrend) .* (real(DMD.lambdaSort)>0);
lambdaSortFreqBin  = (abs(DMD.lambdaSort) > 1-epsFreq) .* (abs(DMD.lambdaSort) < 1+epsFreq) .* (~lambdaSortTrendBin);
lambdaSortRestBin  = (~lambdaSortTrendBin) .* (~lambdaSortFreqBin);

lambdaSortTrendID = find(lambdaSortTrendBin);
lambdaSortFreqID = find(lambdaSortFreqBin);
lambdaSortRestID = find(lambdaSortRestBin);

if (length(unique([lambdaSortTrendID; lambdaSortFreqID; lambdaSortRestID])) ~= length(DMD.lambdaSort))
    error('Something went wrong with filtering DMD components')
end

% Sort DMD components within the groups
[~,ITrend]  = sort(DMD.influenceDiagKSort(lambdaSortTrendID));
[~,IFreq]   = sort(DMD.influenceDiagKSort(lambdaSortFreqID));
[~,IRest]   = sort(DMD.influenceDiagKSort(lambdaSortRestID));

% Generate general order for plotting
DMD.filtering=[fliplr(lambdaSortTrendID(ITrend)'), fliplr(lambdaSortFreqID(IFreq)'), fliplr(lambdaSortRestID(IRest)') ];


end