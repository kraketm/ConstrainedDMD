function [] = VIS_OverviewRepresentation(DATA, DMD, numberComps)
% This function VIS_OverviewRepresentation visualizes the filtered DMD 
% components in an overview representation. The number of shown DMD 
% components is given by the third input parameter 'numberComps'.
%
%
% [] = VIS_OverviewRepresentation(DATA, DMDOrig, numberComps)
%
% Input: A struct DATA, a struct DMD, and a parameter with the following
% properties
%   * DATA.type
%   * DATA.timeSeries
%   * DATA.m
%   * DATA.delayParameter
%   * DMD.lambdaSort
%   * DMD.ThetaScaledSort
%   * DMD.filtering
%   * numberComps
%
% Output: A visualization (figure with name 'Overview')


col = [228,026,028;055,126,184;077,175,074;152,078,163;255,127,000;255,255,051;166,086,040;251,180,174;179,205,227;204,235,197;222,203,228;254,217,166;255,255,204;229,216,189]./255;

I = DMD.filtering;

if DATA.type == "univariate"
    tmp = 0;
    tmp_sum = 0;
    tmp_subplot = 1;
    
    figure('Name','Overview')

    for l = 1:length(DMD.lambdaSort)
        k = I(l);
        
        if(imag(DMD.lambdaSort(k)) < 1e-9)
            tmp_plot = real(TOOL_DiagonalAveraging(DMD.ThetaScaledSort(:,k) * ...
                DMD.lambdaSort(k).^(0:DATA.m)));
        else
            tmp_plot = 2*real(TOOL_DiagonalAveraging(DMD.ThetaScaledSort(:,k) * ...
                DMD.lambdaSort(k).^(0:DATA.m)));
        end
            
        subplot(numberComps,3,tmp_subplot)
        tmp_subplot=tmp_subplot+1;
        p1=plot(1:length(tmp_plot),tmp_plot);
        set(p1(1),'LineWidth',1,'Color',col(2,:));      
        title( sprintf('EV: %.2f%+.2fi \n period: %.3f \n magnitude: %.3f',...
            real(DMD.lambdaSort(k)), imag(DMD.lambdaSort(k)) , ...
            2*pi*1j/log(DMD.lambdaSort(k)./abs(DMD.lambdaSort(k))) , abs(DMD.lambdaSort(k)) )  )
        box off

        subplot(numberComps,3,tmp_subplot)
        tmp_subplot=tmp_subplot+1;
        tmp_sum = tmp_sum + tmp_plot;
        p2=plot(1:length(DATA.timeSeries),DATA.timeSeries,1:length(tmp_sum),tmp_sum);
        set(p2(1),'LineStyle','-','LineWidth',1,'Color',col(9,:));
        set(p2(2),'LineWidth',1,'Color',col(2,:));
        title( sprintf('absolute error -- mean: %.2f%', string(norm(abs(DATA.timeSeries-tmp_sum),1)/length(DATA.timeSeries))  ) )
        box off

        subplot(numberComps,3,tmp_subplot)
        tmp_subplot=tmp_subplot+1;
        DataOrigSubsampled = interp1(1:length(DATA.timeSeries),DATA.timeSeries,1:0.1:length(DATA.timeSeries));
        tmp_sum_Subsampled = interp1(1:length(tmp_sum),tmp_sum,1:0.1:length(tmp_sum));
        p3=plot( 1:0.1:length(DATA.timeSeries),abs(DataOrigSubsampled-tmp_sum_Subsampled) ); %./abs(DataOrig) )
        set(p3(1),'LineWidth',1,'Color',col(2,:));
        title( sprintf('absolute error -- mean: %.2f%', string(norm(abs(DATA.timeSeries-tmp_sum),1)/length(DATA.timeSeries))  ) )
        axis([-inf inf -inf inf])
        
        tmp = tmp + 1;
        
        if(tmp == numberComps)
            break 
        end
            
    end
elseif DATA.type == "multivariate"
    tmp = 0;
    tmp_sum = 0;
    tmp_subplot = 1;
    
    figure('Name','Overview')

    for l = 1:length(DMD.lambdaSort)
        k = I(l);
        
        if(imag(DMD.lambdaSort(k)) < 1e-9)
            tmp_plot = real(TOOL_DiagonalAveragingMulti(DMD.ThetaScaledSort(:,k) * DMD.lambdaSort(k).^(0:DATA.m),DATA.delayParameter));
        else
            tmp_plot = 2*real(TOOL_DiagonalAveragingMulti(DMD.ThetaScaledSort(:,k) * DMD.lambdaSort(k).^(0:DATA.m),DATA.delayParameter));
        end
       
        subplot(numberComps,4,tmp_subplot)
        tmp_subplot=tmp_subplot+1;
        p1=plot(1:length(tmp_plot),tmp_plot(1,:));
        set(p1(1),'LineWidth',1,'Color',col(5,:)); 
        title( sprintf('EV: %f%+fi \t FREQ: %.3f \t ABS:%.4f' , real(DMD.lambdaSort(k)), imag(DMD.lambdaSort(k)) , 2*pi*1j/log(DMD.lambdaSort(k)./abs(DMD.lambdaSort(k))) , abs(DMD.lambdaSort(k)) )  )
        axis([-inf, inf, -inf inf])
        box off

        subplot(numberComps,4,tmp_subplot)
        tmp_subplot=tmp_subplot+1;
        p1=plot(1:length(tmp_plot),tmp_plot(2,:));
        set(p1(1),'LineWidth',1,'Color',col(4,:)); 
        title( sprintf('EV: %f%+fi \t FREQ: %.3f \t ABS:%.4f' , real(DMD.lambdaSort(k)), imag(DMD.lambdaSort(k)) , 2*pi*1j/log(DMD.lambdaSort(k)./abs(DMD.lambdaSort(k))) , abs(DMD.lambdaSort(k)) )  )
        axis([-inf, inf, -inf inf])
        box off

        subplot(numberComps,4,tmp_subplot)
        tmp_subplot=tmp_subplot+1;
        p1=plot(1:length(tmp_plot),tmp_plot(3,:));
        set(p1(1),'LineWidth',1,'Color',col(2,:)); 
        title( sprintf('EV: %f%+fi \t FREQ: %.3f \t ABS:%.4f' , real(DMD.lambdaSort(k)), imag(DMD.lambdaSort(k)) , 2*pi*1j/log(DMD.lambdaSort(k)./abs(DMD.lambdaSort(k))) , abs(DMD.lambdaSort(k)) )  )
        axis([-inf, inf, -inf inf])
        box off

        subplot(numberComps,4,tmp_subplot)
        tmp_subplot=tmp_subplot+1;
        tmp_sum = tmp_sum + tmp_plot;
        hold on
        p2=plot(1:length(DATA.timeSeries),DATA.timeSeries(2:3,:),1:length(tmp_sum),tmp_sum(2:3,:));
             
        set(p2(1),'LineWidth',1,'Color',col(11,:)); 
        set(p2(2),'LineWidth',1,'Color',col(9,:)); 
        set(p2(3),'LineWidth',1,'Color',col(4,:)); 
        set(p2(4),'LineWidth',1,'Color',col(2,:)); 

        yyaxis right
        p3=plot(1:length(DATA.timeSeries),DATA.timeSeries(1,:),1:length(tmp_sum),tmp_sum(1,:));
        set(p3(1),'LineWidth',1,'LineStyle', '-','Color',col(12,:)); 
        set(p3(2),'LineWidth',1, 'LineStyle', '-','Color',col(5,:));
        hold off
        axis([-inf, inf, -inf inf])

        title( strcat(num2str(norm(abs(DATA.timeSeries(1,:)-tmp_sum(1,:)),1)/length(DATA.timeSeries)), ",", ...
        num2str(norm(abs(DATA.timeSeries(2,:)-tmp_sum(2,:)),1)/length(DATA.timeSeries)), ",", ...
        num2str(norm(abs(DATA.timeSeries(3,:)-tmp_sum(3,:)),1)/length(DATA.timeSeries)) ))
        
        tmp = tmp + 1;
        
        if(tmp == numberComps)
            break
        end

    end
    

end


end