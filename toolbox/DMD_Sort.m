function [lambdaSort,ThetaScaledSort,influenceDiagKSort] = DMD_Sort(lambda, ThetaScaled, influenceDiagK, tol)
% This function DMD_Sort sorts the DMD components and their influence by 
% the argument of their corresponding DMD eigenvalue and drops the complex 
% conjugated pairs.
%
% [lambdaSort,ThetaScaledSort,influenceDiagKSort] = DMD_Sort(lambda, ThetaScaled, influenceDiagK, tol)
%
% Input: 
%   * lambda                DMD eigenvalues
%   * ThetaScaled           scaled DMD modes
%   * influenceDiagK        influence of DMD componens
%
% Output: 
%   * lambdaSort         DMD eigenvalues sorted and thinned out 
%   * ThetaScaledSort    scaled DMD modes sorted and thinned out 
%   * influenceDiagKSort influence of DMD componens sorted and thinned out


% DMD eigenvalues are sorted by their argument (counter-clockwise starting
% with the positive real axis in the complex plane)
[lambdaSortTmp, sortKey] = TOOL_SortByAngle(lambda, tol);

% Search index where negative real axis in the complex plane starts
k_0 = length(lambdaSortTmp);
if(tol > 0)
    for k = 1:length(lambdaSortTmp)
        if(angle(lambdaSortTmp(k)) < -2*pi*tol )
            k_0 = k-1;
            break;
        end
    end
end

[n,~] = size(ThetaScaled);

ThetaScaledSort    = zeros(n,k_0);
lambdaSort         = zeros(k_0,1);
influenceDiagKSort = zeros(k_0,1);

for k = 1:k_0
    ThetaScaledSort(:,k)  = ThetaScaled(:,sortKey(k)); 
    lambdaSort(k)         = lambda(sortKey(k));
    influenceDiagKSort(k) = influenceDiagK(sortKey(k));
end


end