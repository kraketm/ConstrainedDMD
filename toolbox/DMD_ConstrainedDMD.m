function [DMD] = DMD_ConstrainedDMD(DATA, DMDOrig, constraints)
% This function DMD_ConstrainedDMD implements the method: Constrained 
% Dynamic Mode Decomposition. The method is described in Algorithm 1 in
% more detail in the related publication.
% Depending on the number of inputs, this function either computes original
% DMD (1 input) or constraind DMD (3 inputs) incorporating constraints into
% the original decomposition with DMD.
%
%
% [DATA] = DMD_ConstrainedDMD(DATA)
%
% Input: A struct DATA with the following properties 
%   * DATA.delayedTimeSeries    
%   * DATA.n                    
%   * DATA.m                    
%
% Output: A strcut DMD with the following properties
%   * DMD.U, DMD.Sigma, DMD.V   as part of the SVD: U*Sigma*V' = X
%   * DMD.r             rank of the matrix X
%   * DMD.S             low-dimensional representation S 
%   * DMD.lambda        DMD eigenvalues (stored as a vector)
%   * DMD.Theta         DMD modes (columns of the matrix)
%   * DMD.a             DMD amplitudes (stores as a vector)
%   * DMD.ThetaScaled   scaled DMD modes (columns of the matrix)
%
%
% [DATA] = DMD_ConstrainedDMD(DATA, DMDOrig, constraints)
%
% Input: A struct DATA, a struct DMDOrig (original DMD), and constraints
% with the following properties 
%   * DATA.delayedTimeSeries
%   * DATA.n
%   * DATA.m
%   * DMDOrig.U, DMDOrig.Sigma, DMDOrig.V
%   * DMDOrig.lambda      
%   * DMDOrig.influenceDiagK
%
% Output: A strcut DMD with the following properties
%   * DMD.U, DMD.Sigma, DMD.V   as part of the SVD: U*Sigma*V' = X
%   * DMD.r             rank of the matrix X
%   * DMD.S             low-dimensional representation S 
%   * DMD.lambda        updated DMD eigenvalues (stored as a vector)
%   * DMD.Theta         updated DMD modes (columns of the matrix)
%   * DMD.a             updated DMD amplitudes (stores as a vector)
%   * DMD.ThetaScaled   updated scaled DMD modes (columns of the matrix)

if(nargin==1)

    fprintf('Computing original DMD ... ')
    
    % lines 1-2
    X = DATA.delayedTimeSeries(:,1:end-1);
    Y = DATA.delayedTimeSeries(:,2:end);

    % line 3
    [DMD.U,DMD.Sigma,DMD.V] = svd(X, 'econ');
    DMD.r = sum( diag(DMD.Sigma) > max(DATA.n,DATA.m+1)*eps(norm(DMD.Sigma,inf)) );
    
    if(DMD.r ~= DATA.m)
        warning('The data is not linearly independent - this may cause problems!')
    end

    % line 4    
    DMD.S = DMD.U' * Y * DMD.V / DMD.Sigma;
    
    % line 5
    [VS, LambdaS] = eig(DMD.S);
    
    % line 6
    DMD.Theta = Y * DMD.V / DMD.Sigma * VS / LambdaS;

    % line 7
    [DMD.a,~] = lsqr(DMD.Theta * LambdaS, Y(:,1), 1e-12,1000);
    
    % combine DMD modes and DMD amplitudes to scaled DMD modes:
    DMD.ThetaScaled = DMD.Theta * diag(DMD.a);
    % define DMD eigenvalues:
    DMD.lambda = diag(LambdaS);
    

elseif(nargin==3)

    fprintf('Computing constrained DMD ... ')
    
    % line 9
    DMD.constraints = constraints;

    % line 11
    G = DMDOrig.lambda.^(0:DATA.m-1);
  % b = DMDOrig.lambda.^DATA.m;         <-- listed due to consistency
    GTild = constraints.^(0:DATA.m-1);
    bTild = constraints.^DATA.m;

    K = DMDOrig.influenceDiagK;

    % line 12
    Kappa = G' * (diag(K)' * diag(K)) * G;
    KappaInvGTildTrans = Kappa \ GTild';

    % line 13
    c = DMDOrig.V / DMDOrig.Sigma * DMDOrig.U' * DATA.delayedTimeSeries(:,end);

    % line 14
    cTild = c + KappaInvGTildTrans * inv(GTild * KappaInvGTildTrans) * (bTild - GTild * c);

    % line 15
    CTild = zeros(DATA.m, DATA.m);
    CTild(2:end, 1:end-1) = eye(length(cTild)-1);
    CTild(:,end) = cTild;
    STild = DMDOrig.Sigma * DMDOrig.V' * CTild * DMDOrig.V / DMDOrig.Sigma;
    
    % line 16
    [VSTild, LambdaSTild] = eig(STild);
    
    % line 17
    DMD.Theta = DATA.delayedTimeSeries(:,2:end) * DMDOrig.V / DMDOrig.Sigma * VSTild / LambdaSTild;

    % line 18
    [DMD.a,~] = lsqr(DMD.Theta * LambdaSTild, DATA.delayedTimeSeries(:,2), 1e-12, 1000);

    % combine DMD modes and DMD amplitudes to scaled DMD modes:
    DMD.ThetaScaled = DMD.Theta * diag(DMD.a);
    % define DMD eigenvalues:
    DMD.lambda = diag(LambdaSTild);


else

    error('Wrong input for constrained DMD! Either one or three inputs!')

end


fprintf('done \n\n')

end