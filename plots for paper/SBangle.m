DIR = 'W:\phkinnerets\storage\analysis\Niv\symmetry breaking statistics\30um\2018_09_02\';
filenameRegexp = 'Capture 1 - Position *_C0.mat';
dataFiles = ls(fullfile(DIR,filenameRegexp));
for i = 1:size(dataFiles,1)
    dataSquished = load(fullfile(DIR,dataFiles(i,:)));
    dropsStructSquished(i,1:4) = dataSquished.droplets;
end
clear dataSquished
BVSquishedAll = blob_vectors(dropsStructSquished);
ind60Squished = round([BVSquishedAll.time]./60,-1) == 60;
indSmallSquished = [BVSquishedAll.dropR] < 85/2;
IndSquished = ind60Squished & indSmallSquished;
BVSquished = BVSquishedAll(IndSquished);
RTPSquished = [BVSquished.blobRThetaPhi];
ThetaSquished = RTPSquished(2,:);
dropRadiusSquished = [BVSquished.dropR];

[DIR_S, FN_S] = getExperiment(1:4,'../experiments.txt');
for i=1:length(DIR_S);
    dataSphere = load(fullfile(DIR_S{i}, FN_S{i}));
    BVSphereAll{i} = blob_vectors(dataSphere.DATA.drops);
end
clear dataSphere
RTPSphere=[];
dropRadiusSphere = [];
for i=1:length(BVSphereAll)
    RTPSphereAll = [RTPSphere,[BVSphereAll{i}.blobRThetaPhi]];
    dropRadiusSphereAll = [dropRadiusSphere, BVSphereAll{i}.dropR];
end
IndSphere = dropRadiusSphereAll < 850/2;
RTPSphere = RTPSphereAll(:,IndSphere);
dropRadiusSphere = dropRadiusSphereAll(IndSphere);
ThetaSphere = RTPSphere(2,:);

% figure; scatter(dropRadiusSquished(end,:)*2, ThetaSquished);
% hold on 
% scatter(dropRadiusSphere(end,:)*2, ThetaSphere);
% 
% ax = gca;
% ylim([0, pi]);
% ax.YTick = [0, pi/4, pi/2, pi*3/4, pi];
% ax.YTickLabel = {'$0$', '$\frac{1}{4}\pi$', '$\frac{1}{2}\pi$', '$\frac{3}{4}\pi$', '$\pi$'};
% ax.TickLabelInterpreter = 'latex';
% xlabel('Droplet Diameter');
% ylabel('Displacement angle');
subplot = @(M,N,P) subtightplot(M,N,P,[0.02,0.02],[0.25,0.03],[0.09,0.015]);

numOfBars = 7;
Fig = figure('Position',[0,0,400,150]);
Fig.PaperPositionMode = 'auto';
ax(1) = subplot(1,2,1);
histogram(ax(1), ThetaSquished,linspace(0,pi,numOfBars + 1),'Normalization', 'pdf')
% hold on
ax(2) = subplot(1,2,2);
% ax(2).ColorOrderIndex = 2;
% hold(ax(2), 'on');
histogram(ax(2) , ThetaSphere,linspace(0,pi,numOfBars + 1),'Normalization', 'pdf')
% s=[];
% for i=linspace(0,pi,200);
%     s = [s,ones(1,round(sin(i)*100))*i];
% end
% histogram(s,linspace(0,pi,numOfBars + 1),'Normalization', 'pdf', 'facealpha', 0.5)
TickLabel{1} = '$0$';
TickLabel{5} = '$\pi$';
for j=2:4
    g = gcd(j-1,4);
    TickLabel{j} = sprintf('$\\frac{%d}{%d}\\pi$',(j-1)/g, 4/g);
end

for i = 1:2
    hold(ax(i), 'on');
    plot(ax(i),linspace(0,pi,50),sin(linspace(0,pi,50))/2,'k--');
    ax(i).FontSize = 8;
    ax(i).LabelFontSizeMultiplier = 1;
    ax(i).TitleFontSizeMultiplier = 1.25;
    xlim(ax(i),[0,pi]);
    ax(i).XTick = linspace(0,pi,5);
    ax(i).TickLabelInterpreter = 'latex';
    ax(i).XTickLabel = TickLabel;
    xlabel(ax(i),'Aggregate position angle');
    ax(i).YTick = [0,0.5,1];
    ax(i).YLim = [0,1];
end
    ylabel(ax(1),'PDF');
    ax(2).YTickLabel = '';
% legend('Squished', 'Spherical', 'Isotropic');
if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
    print(Fig, fullfile(outputDir,'Aggregate position angle'), format)
end
