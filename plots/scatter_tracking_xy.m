function Fig = scatter_tracking_xy(plot_parameters,zoom)
if ~exist('zoom','var')
    zoom = 1;
end
Fig(1) = figure('Position',[100 100 500 590]);
Fig(1).PaperPositionMode = 'auto';
subplot = @(M,N,P) subtightplot(M,N,P,[0.1,0.1],[0.1,0.08],[0.14,0.06]);
title_text = '';
hold on
blobVec = [plot_parameters.BV.blobVec];
x = blobVec(1,:);
y =  blobVec(2,:);
times = plot_parameters.times(find(~cellfun('isempty',{plot_parameters.BV.dropR})));
h1 = subplot(2,1,1);
% plot_parameters.xy = plot(times, blobVec(1,:),'.',times, blobVec(2,:),'.','markersize',10);
% plot_parameters.xy = plot(x, y);
col = times;  % This is the color, vary with x in this case.
colormap('copper');
surface([x;x],[y;y],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',1);
c = colorbar;
c.Label.String = 'time';
c.Label.FontSize = 14;
xlim([-plot_parameters.BV(1).dropR,plot_parameters.BV(1).dropR]/zoom);
ylim([-plot_parameters.BV(1).dropR,plot_parameters.BV(1).dropR]/zoom);
xlabel('x [microns]','FontSize',14);
ylabel('y [microns]','FontSize',14);
axis equal 
h2 = subplot(2,1,2)
[msdVec,stdVec] = msd_vec(x,y,6);
% meanx = mean_vec(x);
% meany = mean_vec(y);
% 
% plot(sqrt(times),rmsVec,'.','markersize',10);
% xlabel('$\sqrt{time [s]}$','FontSize',14,'interpreter','latex');
% xlim(sqrt([times(1),times(end)]));
% hold on
errorbar(times(1:length(msdVec)),msdVec,stdVec,'.','markersize',10);
h2.XScale = 'log';
h2.YScale = 'log';

fit = fitlm(log(times(2:length(msdVec))),log(msdVec(2:end)));
hold on
f = plot(times(2:length(msdVec)),exp(fit.Fitted));

% plot(times,meanx,'.','markersize',10);
% plot(times,meany,'.','markersize',10);
xlabel('log \Delta t','FontSize',14);
xlim([times(1),times(length(msdVec))]);
ylabel('log MSD','FontSize',14);
legend(f,sprintf('slope: %.2f \\pm %.2f',fit.Coefficients.Estimate(2)...
    ,fit.Coefficients.SE(2)));
% legend({'RMS','$\left< \Delta x\right>$','$\left< \Delta y\right>$'},...
%     'interpreter','latex');
hold off
Fig(1).Name = title_text;


