% figures for paper
% set(0,'defaultAxesFontName', 'Arial')
% set(0,'defaultTextFontName', 'Arial')
format = '-depsc';
outputDir = 'C:\Users\Nivieru\Documents\plots_for_paper\matlabOutput\';
format = -1;
outputDir = -1;

set(0, 'DefaultFigureRenderer', 'painters');
% ---- displacement ---- %
% sectionLines = [60,50;85,50];
sectionLines = -1;
% standard
[DIR_S, ~] = getExperiment(1:4,'../experiments.txt');
[F, sectionsSTD] = scatter_displacement_paper2(DIR_S',1, sectionLines, format, outputDir);
RLimits = [0, sectionsSTD; sectionsSTD, 65]';
hist_vertical_symbreaking_paper(DIR_S', RLimits, format, outputDir);

% ActA
[DIR_ActA, ~] = getExperiment(5,'../experiments.txt');
[~, sectionsActA] =scatter_displacement_paper2(DIR_ActA',1,sectionLines, format, outputDir);

% CCA
[DIR_CCA, ~] = getExperiment(8:9,'../experiments.txt');
[~, sectionsCCA] = scatter_displacement_paper2(DIR_CCA',1,sectionLines, format, outputDir);

%Abp1 + Srv2
[DIR_Abp, ~] = getExperiment(6,'../experiments.txt');
[~, sectionsAbp] = scatter_displacement_paper2(DIR_Abp',1,sectionLines, format, outputDir);

symbreaking_with_100nM_ActA_paper
symbreaking_with_500nM_ActA_paper
symbreaking_with_nocadazole_paper
symbreaking_Iphase_paper

FigTransitionRangeConditions = figure('Position',[100 100 250 250]);
FigTransitionRangeConditions.PaperPositionMode = 'auto';

ax = gca;
secs = [sectionsActA; sectionsSTD; sectionsCCA];
secs(:,3) = 121;
secs(:,2:3) = diff(secs,1,2);
h = area(1:3,secs);
h(1).FaceColor = [253,226,226]./256;
h(2).FaceColor = [255,239,202]./256;
h(3).FaceColor = [233,243,221]./256;
ylim([30,121]);
xlim([1,3]);

% hold on
% plot([1,1],sectionsSTD','b', 'lineWidth', 2);
% plot([2,2],sectionsActA','b', 'lineWidth', 2);
% plot([3,3],sectionsCCA','b', 'lineWidth', 2);
% %     plot([4,4],sectionsAbp','b', 'lineWidth', 2);
% ax=gca;
ax.XTick=1:3;
ax.XTickLabel={'bulk ActA', 'Standard', 'CCA'};
ylabel('Transition size range [um]');
if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
    print(FigTransitionRangeConditions,fullfile(outputDir,'FigTransitionRangeConditions'),format);
end

%time with averageing
symbreaking_time_paper;
sectionsTime

%bodipy
symbreaking_with_bodipy_paper;
sectionsActABodipy

%symmetry breaking angle
SBangle;

%tracking
tracking_paper;

%magnets
magnets_rambam10;
magnets_paper;
magnets_symbreaking_paper

%velocity field for symmetric and polar droplets
Capture_folder{1} = 'W:\phkinnerets\storage\analysis\Niv\rambma6 network flow\asymmetric\2019_03_03\network\Capture 13\';
VDIR{1} = [Capture_folder{1},'Velocity\STICS\ROI[12 12 486 492]DCC30_10\'];
Capture_folder{2} = 'W:\phkinnerets\storage\analysis\Niv\rambma6 network flow\symmetric\2018_07_30\mix1 sample1\Capture 8\';
VDIR{2} = [Capture_folder{2},'Velocity\STICS\ROI[4 4 504 505]DCC30_10\'];


VFig = plotVelocityField_paper(Capture_folder, VDIR);
if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
   vecrast(VFig(1), fullfile(outputDir,'asymmetricVelocity'), 600, 'bottom', 'pdf');
   vecrast(VFig(2), fullfile(outputDir,'symmetricVelocity'), 600, 'bottom', 'pdf');
%     print(VFig(1),fullfile(outputDir,'asymmetricVelocity'),format);
%     print(VFig(2),fullfile(outputDir,'symmetricVelocity'),format);
end

% actin density vs droplet radius
rhoFig = peakActinDensity_paper;
if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
    print(rhoFig,fullfile(outputDir,'peakActinDensity'),format);
end

% calibrated actin density
calibrated_actin_density;

%% symmetry breaking simulation
params.k = 0.5;
params.V0 = 2;
r = [0.1,0.3,0.5,1];
r = 1;
outTimes = [15, 30, 45];
outTimes = 30;
params.dt = 0.1;
params.Tmax = 45;
c = [0.5,0.4,0.3,0.05];
c = 0.05;
FigSim = [];
for j = 1:length(c)
    params.c = c(j);
    params.r = r(j);
    [FigSim(:,j) ,~] = clutch_simulation(params,outTimes, format, outputDir);
end
j=3
% CCA simulation
%     params.c = 0.7;
%     params.r = 0.1;
%     [Fig(4) ,sections(4,:), Movie(4,:)] = clutch_simulation(params,true, -1, -1);

%%
if exist('format', 'var') && ischar(format) && exist('outputDir', 'var') &&ischar(outputDir)
    if strcmp(format,'-depsc')
        ext = '.eps';
    elseif strcmp(format,'-dpdf')
        ext = '.pdf';
    else
        ext = '';
    end
    for j=1:length(c)
        print(Fig(j),fullfile(outputDir,[FigSim(j).Name, ext]),format);
        v = VideoWriter(fullfile(outputDir,[FigSim(j).Name, '.avi']),'Motion JPEG AVI');
        v.FrameRate = 30;
        open(v)
        writeVideo(v,Movie(j,:))
        close(v)
    end
end
%% centering simulation
%plotFluidAndNetwork;
plotSimDroplet;
plotSimForce;
imbalanceVelocityCorrelation_sim_paper;
plotSimDifferentParameters;