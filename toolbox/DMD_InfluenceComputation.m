function [DMD] = DMD_InfluenceComputation(DATA,DMD)
% This function DMD_InfluenceComputation computes the influence of DMD
% components (see Eq. 20)
%
%
% [DMD] = DMD_InfluenceComputation(DATA,DMD)
%
% Input: a struct DATA and a struct DMD with the following properties 
%   * DATA.type
%   * DATA.scalingDiag <-- optional and only for multivariate data
%   * DMD.lambda
%   * DMD.ThetaScaled
%
% Output: 
%   * DMD.influenceDiagK

if(DATA.type == "univariate")
    
    for k = 1:length(DMD.lambda)
        DMD.influenceDiagK(k) = norm(TOOL_DiagonalAveragingMulti(real(DMD.ThetaScaled(:,k) * DMD.lambda(k).^(0:DATA.m)),DATA.delayParameter), "fro");
    end

elseif(DATA.type == "multivariate")

    if(isfield(DATA,'scalingDiag'))
        scalingMatrix = diag(1./vecnorm(DATA.timeSeries,2,2)) * diag(DATA.scalingDiag);
    else
        scalingMatrix = diag(1./vecnorm(DATA.timeSeries,2,2));
    end
    
    for k = 1:length(DMD.lambda)
        DMD.influenceDiagK(k) = norm(scalingMatrix*TOOL_DiagonalAveragingMulti(real(DMD.ThetaScaled(:,k) * DMD.lambda(k).^(0:DATA.m)),DATA.delayParameter), "fro");
    end

end

end