% setupPlot

hold on
ph = plot(1:length(DATA.timeSeries), ones(length(DATA.timeSeries),length(axisSteps{setupPlotsI})).*axisSteps{setupPlotsI});
set(ph(:),'LineWidth',1, 'LineStyle', ':','Color',[0.8 0.8 0.8]);
ph0 = plot(1:length(DATA.timeSeries), 0*ones(length(DATA.timeSeries),1));
set(ph0(:),'LineWidth',1, 'LineStyle', ':','Color',[0 0 0]); 
hold off

if length(axisLimits{setupPlotsI})==1
    minaxis = axisLimits{setupPlotsI};
    if max(abs(ref))>minaxis
        minaxis = max(abs(ref))+0.1;
        axis([-inf inf -minaxis minaxis])
    else
        minaxis = minaxis + 0.1;
        axis([-inf inf -minaxis minaxis])
    end
else
    axis([-inf inf, axisLimits{setupPlotsI}])
end


set(gca,'xtick',[])
set(gca,'xticklabel',[])

set(gca,'ytick',[])
set(gca,'yticklabel',[])

pbaspect([6 1 1])