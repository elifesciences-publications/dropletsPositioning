function Fig = scatter_tracking_xyz(plot_parameters)
Fig(1) = figure;
subplot = @(M,N,P) subtightplot(M,N,P,[0.07,0.1],[0.1,0.08],[0.1,0.02]);
S = size(plot_parameters);
for i = 1:S(1)
    title_text = '';
    subplot(min(2,S(1)),ceil(S(1)/2),i);
    hold on
    for j = 1:S(2)
        blobVec = [plot_parameters(i,j).BV.blobVec];
        times = plot_parameters.times(find(~cellfun('isempty',{plot_parameters.BV.dropR})));
        plot_parameters(i,j).s = plot(times, blobVec(1,:),'.',times, blobVec(2,:),'.',times, blobVec(3,:),'.');
        legend({'x','y','z'},'FontSize',14);
        xlabel('time [s]','FontSize',14);
        ylabel('Displacement','FontSize',14);
        xlim([times(1),times(end)]);
    end
    plot(times , ones(size(times))*plot_parameters(i,j).BV(1).dropR,'k--');
    plot(times , ones(size(times))*plot_parameters(i,j).BV(1).dropR*(1-plot_parameters(i,j).DATA.drops(1).blobRfactor),'r--');
    hold off
end
Fig(1).Name = title_text;


