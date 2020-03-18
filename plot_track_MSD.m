function Fig = plot_track_MSD(DIRS,factor)
Fig = figure('Position',[100 100 500 500]);
Fig.PaperPositionMode = 'auto';
if ~exist('factor','var')
    factor = 6;
end
fields={'blobXYZ','times','dropRadius'};
dropVectors = loadDropsVectors(DIRS,fields,true);
DIR=DIRS{1};
XYZ = dropVectors.blobXYZ;
t = dropVectors.times;
dropRadius = dropVectors.dropRadius;

x = XYZ(1,:);
y =  XYZ(2,:);

hold on
[msdVec,stdVec] = msd_vec(x,y,factor); %calculate MSD up to differance of 1/6 of total time

%plot data
data = errorbar(t(1:length(msdVec)),msdVec,stdVec,'.','markersize',15);

ax = gca;
ax.XScale = 'log';
ax.YScale = 'log';
ax.FontSize = 18;
% plot linear fit to log-log
ax.ColorOrderIndex = 1;
fit = fitlm(log(t(2:length(msdVec))),log(msdVec(2:end)));
f = plot(t(2:length(msdVec)),exp(fit.Fitted),'LineWidth',1);

% plot line with slope 1 (on log-log) starting at the same position
slope1 = plot(t(1:length(msdVec)),t(1:length(msdVec))*msdVec(2)/t(2),'LineWidth',1);

% plot expected MSD for brownian motion for aggregate in extract
K = 1.4e-23;% Boltzmann const. [Joule/Kelvin]
T = 300; % Temperature [kelvin]
eta = 10; % extract viscosity [cP]
etaSI = eta/10;% 1 cP = 0.1 Pa*s = 0.1 J*s/m^3
r = dropRadius(1)/4 *1e-6; % aggregate radius [m]
unitConversion = 1e12; %1 m^2 = 1e12 um^2
BrownianMSD = unitConversion * 4*K*T/(6 *pi *etaSI*0.1 *r) * t(1:length(msdVec));
brownian = plot(t(1:length(msdVec)),BrownianMSD,'LineWidth',1);

xlabel('{\Delta}t [seconds] (log scale)');%,'FontSize',14);
xlim([t(1),t(length(msdVec))]);
% ylim([ax.YLim(1),10]);
ax.XTick = [2,10,ax.XLim(2) - rem(ax.XLim(2),10)];
ax.XTickLabel = {'2', '10', num2str(ax.XLim(2) - rem(ax.XLim(2),10))};

ylabel('MSD [{\mu}m] (log scale)');%,'FontSize',14);
legend([data, f, slope1, brownian], 'data', sprintf('fit slope: %.2f \\pm %.2f',fit.Coefficients.Estimate(2)...
    ,fit.Coefficients.SE(2)), 'slope 1 comparison', 'expected brownian motion');
% save figures
print(Fig,fullfile(DIR,'xy_MSD.eps'),'-depsc');
end
