function [] = MultiPlot(DATA, DMDOrig, DMDCons)
% This function MultiPlot replicates Fig. 10 of the related publication.
% It is only created for the Replicability Stamp.
%


col = [228,026,028;055,126,184;077,175,074;152,078,163;255,127,000;255,255,051;166,086,040;251,180,174;179,205,227;204,235,197;222,203,228;254,217,166;255,255,204;229,216,189]./255;

f = figure('Name','Multi');
set(f,'units','pix')

tiledlayout(8,6, 'TileSpacing','tight' );
%f.Position = [1,223,1473,456];
s = get(0, 'ScreenSize');
f.Position = [1,s(4)/3, s(4)*1.292105263157895, s(4)/2.5];

% Main Boxes:
dim = [0.072 0.1 0.427 0.9];
str = 'DMD';
annotation('textbox',dim,'String',str, 'FontWeight','bold')

dim = [0.501 0.1 0.427 0.9];
str = 'Constrained DMD';
annotation('textbox',dim,'String',str, 'FontWeight','bold')


%% DMD Orig Plots and Constrained DMD Plots
for s=1:2
    if s==1
        DMDPlot = DMDOrig;
        tileNumber = 1;
        I = DMDOrig.filtering;
    else
        DMDPlot = DMDCons;
        tileNumber = 4;
        I = DMDCons.filtering;
    end
    
    tmp = 0;
    tmp_sum = 0;
    
    for l = 1:length(DMDPlot.lambdaSort)
        k = I(l);

        if(imag(DMDPlot.lambdaSort(k)) < 1e-9)
            tmp_plot = real(TOOL_DiagonalAveragingMulti(DMDPlot.ThetaScaledSort(:,k) * DMDPlot.lambdaSort(k).^(0:DATA.m),DATA.delayParameter));
        else
            tmp_plot = 2*real(TOOL_DiagonalAveragingMulti(DMDPlot.ThetaScaledSort(:,k) * DMDPlot.lambdaSort(k).^(0:DATA.m),DATA.delayParameter));
        end

        axisLimits = {[-500, 4000], [-500 4000], [60, 90], 140, 140, 1.40};
        axisSteps = {[1000, 2000, 3000], [1000, 2000, 3000], [60, 70, 80, 90], [-100,100],[-100,100],[-1,1]};

        nexttile(tileNumber) 
        p1=plot(1:length(tmp_plot),tmp_plot(3,:));
        set(p1(1),'LineWidth',1,'Color',col(2,:)); 
        
        if l==1
            setupPlotsI = 1;
            title( sprintf('trend'), 'FontWeight','normal', 'FontSize',10)
        
        else
            setupPlotsI = 4;
            title( sprintf('period: %.3f, magnitude: %.3f' , 2*pi*1j/log(DMDPlot.lambdaSort(k)) , abs(DMDPlot.lambdaSort(k))), 'FontWeight','normal', 'FontSize',10)
        
        end
        
        setupPlotsI = setupPlotsI;
        ref = tmp_plot(3,:);
        setupPlots

        nexttile(tileNumber+1)
        
        p1=plot(1:length(tmp_plot),tmp_plot(2,:));
        set(p1(1),'LineWidth',1,'Color',col(4,:)); 
        setupPlotsI = setupPlotsI+1;
        ref = tmp_plot(2,:);
        setupPlots

        nexttile(tileNumber+2)
        p1=plot(1:length(tmp_plot),tmp_plot(1,:));
        set(p1(1),'LineWidth',1,'Color',col(5,:)); 
        setupPlotsI = setupPlotsI+1;
        ref = tmp_plot(1,:);
        setupPlots

        tmp = tmp + 1;
        tmp_sum = tmp_sum + tmp_plot;

        tileNumber = tileNumber + 6;
        if(tmp == 6)
            break
        end
            
    end

    nexttile(tileNumber, [2 3])

    title( sprintf('superposition -- mean absolute error: %.2f, %.2f, %.2f' , ...
        norm(abs(DATA.timeSeries(3,:)-tmp_sum(3,:)),1)/length(DATA.timeSeries), ...
        norm(abs(DATA.timeSeries(2,:)-tmp_sum(2,:)),1)/length(DATA.timeSeries), ...
        norm(abs(DATA.timeSeries(1,:)-tmp_sum(1,:)),1)/length(DATA.timeSeries)), ...
        'FontWeight','normal', 'FontSize',10)

    
    hold on
    p2=plot(1:length(DATA.timeSeries),DATA.timeSeries(2,:),1:length(tmp_sum),tmp_sum(2,:), ...
        1:length(DATA.timeSeries),DATA.timeSeries(3,:),1:length(tmp_sum),tmp_sum(3,:));
    set(p2(1),'LineWidth',1,'LineStyle', '-','LineStyle', '-','Color',col(11,:)); 
    set(p2(2),'LineWidth',1,'LineStyle', '-', 'LineStyle', '-','Color',col(4,:));
    set(p2(3),'LineWidth',1,'LineStyle', '-','Color',col(9,:)); 
    set(p2(4),'LineWidth',1,'LineStyle', '-','Color',col(2,:)); 
    ph0 = plot(1:length(DATA.timeSeries), 0*ones(length(DATA.timeSeries),1));
    set(ph0(:),'LineWidth',1, 'LineStyle', ':','Color',[0 0 0]); 

    yyaxis right
    p1=plot(1:length(DATA.timeSeries),DATA.timeSeries(1,:),1:length(tmp_sum),tmp_sum(1,:));
    ph = plot(1:length(DATA.timeSeries), ones(length(DATA.timeSeries),2).*[70 80]);
    
    set(ph(:),'LineWidth',1, 'LineStyle', ':','Color',col(12,:)); 

    set(p1(1),'LineWidth',1,'LineStyle', '-', 'Color',col(12,:)); 
    set(p1(2),'LineWidth',1,'LineStyle', '-','Color',col(5,:)); 
    hold off
    axis([-inf, inf, 60, 90])

    set(gca,'xtick',[])
    set(gca,'xticklabel',[])

    set(gca,'ytick',[70,80])
    set(gca,'yticklabel',[70 80])
    set(gca,'YColor',col(12,:))
    
    yyaxis left
    axis([-inf, inf, -500, 4000])
    set(gca,'ytick',[0,1000,2000,3000])
    set(gca,'yticklabel',[0 1000 2000 3000])
    box on
    pbaspect([5 1 1])

end

% Export into figures folder
% exportgraphics(f,'../figures/Fig10.jpg')

end


