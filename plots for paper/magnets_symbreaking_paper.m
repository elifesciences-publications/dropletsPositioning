%%
clear basefilenames imagefilenames lastMagnetFrame
basefilenames(1:3) = {'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_08\mix1 sample1\Capture 4_C0',...
        'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_09\mix1 sample1\Capture 5_C0',...
        'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_13\mix2 sample3 17_35\Capture 1_C0'};
imagefilenames(1:2) = cellfun(@(s) [s, '.tiff'], basefilenames(1:2), 'UniformOutput', false);
imagefilenames(3) = {'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_13\mix2 sample3 17_35\Capture 1_C0.tiff'};
lastMagnetFrame(1:3) = [45, 35,35];

%%

clear CCData;
clear drops;
for i = 1:length(basefilenames)
    filename = basefilenames{i};
    dataFilename = [filename,'.mat'];
    data = load(dataFilename);
    drops{i} = data.droplets;
    timesep = mean(diff([drops{i}(2:end).time]));
    drops{i}(1).time = drops{i}(2).time - timesep;
    lastMagnetFrameAdjusted(i) = max(1,lastMagnetFrame(i) - drops{i}(1).timepoint); %Fix for series that don't start at first frame
    CCData(i) = smooth_data3(drops{i}, -1, 1,[3,71], 1, 15, lastMagnetFrame(i) + 1);
end
% ind=[];
% for i=1:length(CCData)
%     if((CCData(i).Orig.r(end) - CCData(i).Orig.r(1))/CCData(i).dropRadius(end)) > 0.3
%         ind=[ind,i]
%         drops{i}(1).filename
%     end
% end

for i=1:length(basefilenames)
    if ~isfield(CCData(i), 'lastMagnetFrame') || isempty(CCData(i).lastMagnetFrame)
        CCData(i).lastMagnetFrame = lastMagnetFrame(i);
    end
end

Fig = plot_velocity_paper_symbreaking(CCData,true, true, lastMagnetFrame, true);
if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
% for i=1:length(Fig)
    i = 1;
    print(Fig(i),fullfile(outputDir,['magnets_symbreaking_',Fig(i).Name]),format);
% end
end
