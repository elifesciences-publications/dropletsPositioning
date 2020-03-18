calibration = 0.833333;
timeSep = 2;
startFromTimePoint = 92;

magDir = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_01_03';
dataFilename = fullfile(magDir,'Capture 9_XY1514999422_Z0_interp3.mat');
data = load(dataFilename);
droplets = data.droplets;
positions = reshape([droplets.dropletPosition],4,[]);
dropRadius = positions(3,:) * droplets(1).micronsPerPixel / 2;
AggPositions = reshape([droplets.aggregatePosition],4,[]);
dropInd = (dropRadius == dropRadius(1)); % pick the first droplet

dropletPosition = positions(:,dropInd);
aggregatePosition = AggPositions(:,dropInd);

Xdroplet = ceil(dropletPosition(1,:)+(dropletPosition(3,:)/2));
Ydroplet = ceil(dropletPosition(2,:)+(dropletPosition(4,:)/2));
Xaggregate = ceil(aggregatePosition(1,:)+(aggregatePosition(3,:)/2));
Yaggregate = ceil(aggregatePosition(2,:)+(aggregatePosition(4,:)/2));
Rdroplet = dropletPosition(3,:)/2;
D = sqrt((Xaggregate-Xdroplet).^2 + (Yaggregate-Ydroplet).^2) * calibration;

Dcut = D(startFromTimePoint:end);
span1 = 55;
span2 = 55;
Scut = 10;
smoothD = smooth(Dcut,span1);
smoothDcut = smoothD(Scut:end);
V = diff(smoothDcut)*60/timeSep;
Vsmooth = smooth(V,span2);
time = ((1:length(Vsmooth)) + startFromTimePoint + Scut) * timeSep / 60;

Fig1 = figure('Position',[100 100 500 300]);
plot(time,-Vsmooth,'LineWidth',2)
 hold on
% plot(time,smoothDcut(2:end)/10,'LineWidth',2)

% keyFrames = [106,179,391,641];
% keyTimes = keyFrames * timeSep/60;
% for k = 1:length(keyTimes)
%     plot([1,1]*keyTimes(k), [0,max(-Vsmooth)], 'k--');
% end
ylim([min(-Vsmooth),max(-Vsmooth)]);
xlim(time([1,end]));

xlabel('Time [min]');
ylabel('Velocity [$\frac{{\mu}m}{min}$]','Interpreter','Latex');
% set(gca,'FontSize',16);
Fig1.PaperPositionMode = 'auto';
% print(Fig1,fullfile(magDir,'velocity.eps'),'-depsc');
print(Fig1,fullfile(magDir,'velocity.png'),'-dpng');

Fig2 = figure('Position',[200 100 500 300]);
plot(-smoothDcut(1:end-1),-Vsmooth,'LineWidth',2)
xlabel('Contraction Center Position [{\mu}m]');
ylabel('Velocity [$\frac{{\mu}m}{min}$]','Interpreter','Latex');
hold on
xl = xlim;
plot(xl(1):xl(2), zeros(size(xl(1):xl(2))),'k--');
% yl = ylim;
% ylim([0,yl(2)])
% set(gca,'FontSize',16);
Fig2.PaperPositionMode = 'auto';
print(Fig2,fullfile(magDir,'velocity-position.png'),'-dpng');
