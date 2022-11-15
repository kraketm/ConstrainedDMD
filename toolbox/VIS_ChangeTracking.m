function [] = VIS_ChangeTracking(DMD1, DMD2)
% This function VIS_ChangeTracking implements the change tracking of 
% eigenvalues, where the update of eigenvalues (due to the human-in-the-
% loop) is visualized with vector-like connections in the complex plane. 
% For more details, please have a look into the related publication.
%
%
% [] = VIS_ChangeTracking(DMDOrig, DMDCons)
%
% Input: Two structs DMD1 and DMD2 with the following properties
%   * DMD1.lambda and DMD2.lambda
%   * DMD1.Theta and DMD2.Theta
%
% Output: A visualization (figure with name 'Tracking of eigenvalues')


DistLambda = zeros(length(DMD1.lambda));
DistTheta  = zeros(length(DMD1.lambda));

% Distance matrix for DMD eigenvalues
for k=1:length(DMD1.lambda)
    for l=1:length(DMD1.lambda)
        DistLambda(k,l) = abs(DMD2.lambda(k)-DMD1.lambda(l));
    end
end

% Distance matrix for DMD modes
for k=1:length(DMD1.lambda)
    for l=1:length(DMD1.lambda)
        a_tmp = pinv(DMD2.Theta(:,k))*DMD1.Theta(:,l);
        DistTheta(k,l) = norm(DMD2.Theta(:,k)*a_tmp-DMD1.Theta(:,l));
    end
end

% User-defined combination parameter
CombParameter = 0.5;

% Combined Distance matrix
DistCombined = CombParameter*DistLambda/max(max(DistLambda))+(1-CombParameter)*DistTheta/max(max(DistTheta));


SortKeyViaDist = zeros(length(DMD1.lambda),1);

[Dist_RowSorted,Ind_Dist_RowSorted] = sort(DistCombined,2);
listOfAlreadySelectedRows = [];
while( ~all(isinf(Dist_RowSorted(:,1))) )
    [~,ind_min] = min(Dist_RowSorted(:,1));
    Dist_RowSorted(ind_min,1) = inf; % this row will never be chosen again
    
    for l=1:length(Ind_Dist_RowSorted(ind_min,:))
        if(ismember( Ind_Dist_RowSorted(ind_min,l) , listOfAlreadySelectedRows))
            % do nothing if row was already selected ... 
        else
            SortKeyViaDist(ind_min) = Ind_Dist_RowSorted(ind_min,l);
            listOfAlreadySelectedRows = [listOfAlreadySelectedRows, Ind_Dist_RowSorted(ind_min,l)]; % append detected row:
            break;
        end
    end  
end

DMDConsTracked.lambda = DMD1.lambda(SortKeyViaDist);


%% Visualization
figure('Name','Tracking of eigenvalues')

col = [228,026,028;055,126,184;077,175,074;152,078,163;255,127,000;255,255,051;166,086,040;251,180,174;179,205,227;204,235,197;222,203,228;254,217,166;255,255,204;229,216,189]./255;

t = linspace(0,2*pi,1000);
plot(sin(t),cos(t),'LineWidth',1.25,'Color',col(9,:))

axis([-1.05 1.05 -1.05 1.05])
xL = xlim;
yL = ylim;
line([0 0], yL,'LineWidth',1.25,'Color',col(9,:));  %x-axis
line(xL, [0 0],'LineWidth',1.25,'Color',col(9,:));  %y-axis
pbaspect([1 1 1])

hold on
plot(real(DMDConsTracked.lambda),imag(DMDConsTracked.lambda),'o','LineWidth',1,'MarkerSize',10,'Color',col(2,:))

for k = 1:length(DMD2.lambda)
    p2 = [real(DMDConsTracked.lambda(k)), imag(DMDConsTracked.lambda(k))];
    p1 = [real(DMD2.lambda(k)), imag(DMD2.lambda(k))];
    uv = (p2-p1);
    q=quiver(p1(1),p1(2),uv(1),uv(2),'Color',col(5,:));
    q.ShowArrowHead = 'off';
    q.Marker = '.';
    q.LineWidth = 2;
    q.MarkerSize = 12;
end

set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'XColor','none')
set(gca,'ytick',[])
set(gca,'yticklabel',[])
set(gca,'YColor','none')

    
end