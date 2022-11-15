function [pointsNew,sortKey] = TOOL_SortByAngle(pointsOld, tol)
% This function TOOL_SortByAngle sorts complex numbers by their argument.
% The tolerance tol ensures capturing all complex numbers with small
% negative imaginary part.
%
%
% [pointsNew,sortKey] = TOOL_SortByAngle(pointsOld, tol)
%
% Input: 
%   * pointsOld 
%   * tol
%
% Output: 
%   * pointsNew
%   * sortKey


pointsRad = angle(pointsOld);
pointsRad = pointsRad + 2*pi*tol;
pointsRad = mod(pointsRad, 2*pi);

n = length(pointsOld);

pointsNew    = zeros(n,1);
pointsRadNew = zeros(n,1);
sortKey      = zeros(n,1);

for k = 1:n
    tmpMin = 0;
    j0     = 0;

    for j = 1:n
        if(0 <= pointsRad(j))
            tmpMin = pointsRad(j);
            j0     = j;
            break;
        end
    end
    
    for j = 1:n
        if(0 <= pointsRad(j) && pointsRad(j) <= tmpMin)
            tmpMin = pointsRad(j);
            j0     = j;
        end
    end
    
    pointsRad(j0)   = -1;
    pointsRadNew(k) = tmpMin;
    sortKey(k)      = j0;
    
end

for k = 1:n
    pointsNew(k) = pointsOld(sortKey(k)); 
end

end