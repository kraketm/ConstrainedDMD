function [] = TeaserPlot(DATA, DMDOrig, DMDCons)
% This function TeaserPlot replicates Fig. 1 of the related publication.
% It is only created for the Replicability Stamp.
%


col = [228,026,028;055,126,184;077,175,074;152,078,163;255,127,000;255,255,051;166,086,040;251,180,174;179,205,227;204,235,197;222,203,228;254,217,166;255,255,204;229,216,189]./255;

timeSeries  = DATA.timeSeries;
trend       = 2*(1:length(timeSeries)) + 50*ones(size(timeSeries));
frequency1  = 8*sin(2*pi*(0:size(timeSeries,2)-1)/7);
frequency2  = 20*sin(2*pi*(0:size(timeSeries,2)-1)/28);
noise       = DATA.timeSeries-trend-frequency1-frequency2;

patterns = [trend; frequency2; frequency1];

s = get(0, 'ScreenSize');
f = figure('Name','Teaser');
set(f,'units','pix')

tiledlayout(3,6, 'TileSpacing','compact' );
%f.Position = [1 (s(4)/3) (s(3)/1.0769) (s(4)/3)];
f.Position = [1 (s(4)/3) s(4)*1.485746123131210 (s(4)/3)];


%% DMD Orig Plots

I = DMDOrig.filtering;
    
tmp = 0;
tmp_sum = 0;
plotnum = 1;

for l = 1:length(DMDOrig.lambdaSort)
    nexttile(plotnum, [1 2])
    k = I(l);
    
    if(imag(DMDOrig.lambdaSort(k)) < 1e-9)
        tmp_plot = real(TOOL_DiagonalAveraging(DMDOrig.ThetaScaledSort(:,k) * ...
            DMDOrig.lambdaSort(k).^(0:DATA.m)));
    else
        tmp_plot = 2*real(TOOL_DiagonalAveraging(DMDOrig.ThetaScaledSort(:,k) * ...
            DMDOrig.lambdaSort(k).^(0:DATA.m)));
    end

    tmp_sum = tmp_sum + tmp_plot;
    p2=plot(1:length(DATA.timeSeries),patterns(l,:),1:length(tmp_sum),tmp_plot);
    set(p2(1),'LineStyle','-','LineWidth',1,'Color',col(9,:));
    set(p2(2),'LineWidth',1,'Color',col(2,:));
    
    if l==1
        title( 'trend', 'FontWeight','normal' )
        box off
        axis([-inf inf -20 170])
    else
        title(sprintf('period: %.2f', 2*pi*1j/log(DMDOrig.lambdaSort(k))), 'FontWeight','normal')
        box off
        axis([-inf inf min(min(patterns(l,:)), min(tmp_plot)) max(max(patterns(l,:)), max(tmp_plot))])
    end

    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    pbaspect([6 1 1])
    box on

    tmp = tmp + 1;

    if(tmp == 3)
        break
    end
        
    plotnum= plotnum + 6;
end

%f.Position = [1 378 1560 350];


dim = [0.0628 0.1 0.285 0.9];
str = 'Dynamic Mode Decomposition';
annotation('textbox',dim,'String',str, 'FontWeight','bold')

dim = [0.3576 0.1 0.285 0.9];
str = 'Input';
annotation('textbox',dim,'String',str, 'FontWeight','bold')

dim = [0.6527 0.1 0.285 0.9];
str = 'Constrained Dynamic Mode Decomposition';
annotation('textbox',dim,'String',str, 'FontWeight','bold')

%% Time Series Plots
nexttile(3)
plot(trend)
axis([-inf inf min(trend) max(trend)])
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
pbaspect([6 1 1])
box on
pbaspect([4 1 1])
title( 'trend: linear increase','FontWeight','normal');
        
nexttile(4)
plot(noise)
axis([-inf inf -20 20])
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
pbaspect([6 1 1])
box on
pbaspect([4 1 1])
title('noise: 5.00%', 'FontWeight','normal' )

nexttile(9)
plot(frequency2)
axis([-inf inf min(frequency2) max(frequency2)])
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
pbaspect([6 1 1])
box on
pbaspect([4 1 1])
title( sprintf('seasonal pattern - period: %.2f', 28.00) , 'FontWeight','normal')

nexttile(10)
plot(frequency1)
axis([-inf inf min(frequency1) max(frequency1)])
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
pbaspect([6 1 1])
box on
pbaspect([4 1 1])
title( sprintf('seasonal pattern - period: %.2f', 7.00), 'FontWeight','normal' )

nexttile(15, [1 2])
plot(DATA.timeSeries)

axis([-inf inf min(timeSeries) max(timeSeries)])
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
pbaspect([6 1 1])
box on
title( sprintf('time series') , 'FontWeight','normal')


%% Constrained DMD Plots

I = DMDCons.filtering;

tmp = 0;
tmp_sum = 0;
plotnum = 5;

for l = 1:length(DMDCons.lambdaSort)
    nexttile(plotnum, [1 2])
    k = I(l);
        
    if(imag(DMDCons.lambdaSort(k)) < 1e-9)
        tmp_plot = real(TOOL_DiagonalAveraging(DMDCons.ThetaScaledSort(:,k) * ...
            DMDCons.lambdaSort(k).^(0:DATA.m)));
    else
        tmp_plot = 2*real(TOOL_DiagonalAveraging(DMDCons.ThetaScaledSort(:,k) * ...
            DMDCons.lambdaSort(k).^(0:DATA.m)));
    end

    tmp_sum = tmp_sum + tmp_plot;
    p2=plot(1:length(DATA.timeSeries),patterns(l,:),1:length(tmp_sum),tmp_plot);
    set(p2(1),'LineStyle','-','LineWidth',1,'Color',col(9,:));
    set(p2(2),'LineWidth',1,'Color',col(2,:));
    box off
    

    if l==1
        title( 'trend', 'FontWeight','normal')
        box off
        axis([-inf inf -20 170])
    else
        title(sprintf('period: %.2f', 2*pi*1j/log(DMDCons.lambdaSort(k))), 'FontWeight','normal')
        box off
        axis([-inf inf min(min(patterns(l,:)), min(tmp_plot)) max(max(patterns(l,:)), max(tmp_plot))])
    end


    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    pbaspect([6 1 1])
    box on
    pbaspect([6 1 1])
    
    tmp = tmp + 1;

        if(tmp == 3)
            break
        end
    
    plotnum= plotnum + 6;
end

% Export into figures folder
% exportgraphics(f,'../figures/Fig01.jpg')

end


