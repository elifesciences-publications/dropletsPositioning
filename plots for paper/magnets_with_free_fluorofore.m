basefilenames = {'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2019_01_31\with free fluorofore\mix2 sample1\Capture 1_C0',...
    'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2019_01_31\with free fluorofore\mix2 sample1\Capture 2_C0'};
imagefilenames = {{'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2019_01_31\with free fluorofore\mix2 sample1\Capture 1_C0.tiff',...
    'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2019_01_31\with free fluorofore\mix2 sample1\Capture 1_C2.tiff'},...
    {'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2019_01_31\with free fluorofore\mix2 sample1\Capture 2_C0.tiff',...
    'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2019_01_31\with free fluorofore\mix2 sample1\Capture 2_C2.tiff'}};
lastMagnetFrame = [59,44];
%%

clear CCData;
clear drops;
for i = 1:length(basefilenames)
    filename = basefilenames{i};
    dataFilename = [filename,'.mat'];
    data = load(dataFilename);
    drops{i} = data.droplets;
    
% % ----- fix times and save ----- %
%     [~, ~, timeSep] = readCalibration(drops{i}(1).filename);
%     for d=1:numel(drops{i})
%         drops{i}(d).time = (d-1)*timeSep;
%         droplets = drops{i};
%     end
%     save(dataFilename, 'droplets','-v7.3');
% % ------------------------------ %
% % ----- fix calibration and save ----- %
%     for d=1:numel(drops{i})
%         [drops{i}(d).micronsPerPixel] = deal(0.99);
%         droplets = drops{i};
%     end
%     save(dataFilename, 'droplets','-v7.3');
% % ------------------------------------ %
    CCData(i) = smooth_data(drops{i}, -1, 1,[3,35], 1, 7, lastMagnetFrame(i) + 1);
end
for i=1:length(basefilenames)
    if ~isfield(CCData(i), 'lastMagnetFrame') || isempty(CCData(i).lastMagnetFrame)
        CCData(i).lastMagnetFrame = lastMagnetFrame(i);
    end
end
Fig = plot_velocity_paper(CCData,true, true, lastMagnetFrame, false);
FigOneDrop = plot_velocity_paper2(CCData(2),true, true, lastMagnetFrame, true);

if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
    for i=1:length(Fig)
        print(Fig(i),fullfile(outputDir,['magnets_',Fig(i).Name]),format);
    end
    print(FigOneDrop(1),fullfile(outputDir,['magnets_oneDrop_',FigOneDrop(1).Name]),format);
end


% [~,legendNames,~] = cellfun(@fileparts, basefilenames, 'UniformOutput', false);
% legend(legendNames(1:end), 'interpreter', 'none')
%%
plot_mean_recenteringV(CCData, true, true, lastMagnetFrame);
%%
% clear CCData_corr
% for i = 1:length(CCData)
%     MovieFilename = [basefilenames{i},'_with_plots2.avi'];
%     images = load_tiff_file(imagefilenames{i},1);
% %     [imbalance, corr, lags] = imbalanceVelocityCorrelation(CCData(i), images, lastMagnetFrame(i));
%     [CCData_corr(i),  imbalanceFig] = imbalanceVelocityCorrelation(CCData(i), images);
%     
% % %     KymFig = asymmetryAnalysis(CCData(i), images, lastMagnetFrame(i));
% %      drawnow
% %     KymFig.PaperPositionMode = 'auto';
% %     print(KymFig,[basefilenames{1},' Inetsity Imbalance', '.png'],'-dpng');
% 
%     crop = drops{i}(end).dropletPosition + [-10, -10, 20, 20];
%     Movie = MakeMovieWithGraphs(images, CCData(i),false, [1 5], crop, 0, true, -1 ,1:lastMagnetFrame(i), {'droplet','time','scale','planes','size', 'aggregate'});
% %     Movie = MakeMovieWithGraph3(images, droplets{i}, CCData(i), crop, false, -1 ,1:lastMagnetFrame(i));
%     v = VideoWriter(MovieFilename,'Motion JPEG AVI');
%     v.FrameRate = 30;
%     open(v)
%     writeVideo(v,Movie)
%     close(v)
% end
%% Sample Kymograph - Important: Load first droplets in samples section first
    mov = 2;
    clear images
    images{1} = load_tiff_file(imagefilenames{mov}{1},1);
    images{2} = load_tiff_file(imagefilenames{mov}{2},1);
    imagesMean = mean(cellfun(@(x) mean(x(:)),images{2}));
    imagesDivided = cellfun(@(x,y) double(x)./double(y) * double(imagesMean), images{1},images{2},'UniformOutput',false);
    
%     [CCData_corr(mov),  imbalanceFig] = imbalanceVelocityCorrelation_paper(CCData(mov), images{1,:});
%     [CCData_corr(mov),  imbalanceFig] = imbalanceVelocityCorrelation_paper(CCData(mov), images{2});
    [CCData_corr(mov),  imbalanceFig] = imbalanceVelocityCorrelation_paper(CCData(mov), imagesDivided);

%     frames = [37,90,255];

    frames = [39, 100, length(imagesDivided)-10];
%     KymFigs = plotCircularKymograph_paper(CCData_corr(mov),3, images{1,:}(frames),frames);
%     KymFigs = plotCircularKymograph_paper(CCData_corr(mov),3, images{2,:}(frames),frames);
    KymFigs = plotCircularKymograph_paper(CCData_corr(mov),3, imagesDivided(frames),frames);
    KymFigs(1).PaperPositionMode = 'auto';
    KymFigs(1).PaperOrientation = 'landscape' ;
    
%     print(KymFigs(1),[basefilenames{2},' Kymograph.eps'],'-depsc');
if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
    print(KymFigs(1),fullfile(outputDir,'magnets_Kymograph'),format);
end
if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
    for f=2:length(KymFigs)
        KymFigs(f).PaperPositionMode = 'auto';
        print(KymFigs(f),fullfile(outputDir,sprintf('magnets_Kymograph - frame %d', f-1)),format);
    end
    imbalanceFig.PaperPositionMode = 'auto';
    imbalanceFig.PaperOrientation = 'landscape' ;
%     print(imbalanceFig,fullfile('plots for paper','imbalance - velocity correlation.eps'),'-depsc');
    print(imbalanceFig,fullfile(outputDir,'magnets_imbalance - velocity correlation'),format);
end
%% Waves - Load first section (older experiments)
%     ind = 4;
%     images = load_tiff_file(imagefilenames{ind},1);
%     crop = drops{ind}(end).dropletPosition + [-10, -10, 20, 20];
%     [CCData_corr,  imbalanceFig] = imbalanceVelocityCorrelation(CCData(ind), images);
%     Movie = MakeMovieWithGraphs(images, CCData_corr,false, [1 8 7], crop, 0, true, -1 ,1:lastMagnetFrame(ind), {'droplet','time','scale','planes','size', 'aggregate'});
%     MovieFilename = [basefilenames{ind},'_with_plots2.avi'];
%     v = VideoWriter(MovieFilename,'Motion JPEG AVI');
%     v.FrameRate = 30;
%     open(v)
%     writeVideo(v,Movie)
%     close(v)
%     MovieFilename = [basefilenames{ind},'_with_plots2.mp4'];
%     v = VideoWriter(MovieFilename,'MPEG-4');
%     v.FrameRate = 30;
%     open(v)
%     writeVideo(v,Movie)
%     close(v)

%%
% for i=1:3
%     Fig(i).PaperPositionMode = 'auto';
%     print(Fig(i),[basefilenames{1},' ',Fig(i).Name,'.eps'],'-depsc');
%     print(Fig(i),[basefilenames{1},' ',Fig(i).Name,'.pdf'],'-dpdf');
% end