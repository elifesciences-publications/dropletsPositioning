doMovie = false;
warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning');
DIRS{3} = {'W:\phkinnerets\storage\analysis\Niv\tracking\2018_05_16'};
limits{3} = {1:69, 1:80, 1:110, [], 1:115};
PI{3} = [1:3,5];
Reg{3} = '*Position %d*';
planePositionsFun{3} = @(dropletPlane) (-10:5:10) + (dropletPlane - 3) * 5;
DIRS{1} = {'W:\phkinnerets\storage\analysis\Niv\tracking\2018_06_19';...
    'W:\phkinnerets\storage\analysis\Niv\tracking\2018_06_18';...
    'W:\phkinnerets\storage\analysis\Niv\tracking\2018_08_05\mix1 sample1';...
    'W:\phkinnerets\storage\analysis\Niv\tracking\2018_08_05\mix2 sample1';...
    'W:\phkinnerets\storage\analysis\Niv\tracking\2018_08_02\mix1 sample1'};
PI{1} = 1:5;
Reg{1} = '*Position %d*';
planePositionsFun{1} = @(dropletPlane) (-20:5:20) + (dropletPlane - 5) * 5;
DIRS{2} = {'W:\phkinnerets\storage\analysis\Niv\tracking\2018_07_30'};
PI{2} = [77,78,80,81]; % 79 is weird - huge aggregate
Reg{2} = 'P*%d*';
planePositionsFun{2} = @(dropletPlane) (-20:5:20) + (dropletPlane - 5) * 5;

clear CCDATA
count = 0;
for di = 1:numel(DIRS)
    for dj = 1:numel(DIRS{di})
        DIR = DIRS{di}{dj};
        for posIndex = PI{di};
            filename_regexp = sprintf([Reg{di}, '_C0.tiff'], posIndex);
            fs = ls(fullfile(DIR,filename_regexp));
            if length(fs) == 0
                filenames = {};
            else
                for i=1:size(fs,1)
                    filenames{i} = fullfile(DIR,fs(i,:));
                end
            end
            if ~isempty(filenames)
                [D,F,E] = fileparts(filenames{1});
                dfs = ls(fullfile(D,sprintf([Reg{di}, '.mat'], posIndex)));
                for i=1:size(dfs,1)
                    count = count + 1;
                    imageFilenames{count} = filenames;
                    dataFilename{count} = fullfile(D,dfs(i,:));
                    if size(dfs,1) == 1
                        MovieFilename{count} = fullfile(DIR,sprintf('tracking movie%d.mp4', posIndex));
                    elseif size(dfs,1) >1
                        MovieFilename{count} = fullfile(DIR,sprintf('tracking movie%d_%d.mp4', posIndex,i));
                    else
                        error('size(dfs,1) = 0');
                    end
                    data = load(dataFilename{count});
                    if isempty(limits{di})
                        limitsP = 1:length(data.droplets);
                    else
                        limitsP = limits{di}{posIndex};
                    end
                    timeSep = 30;
%                     CCDATA(count) = smooth_data(data.droplets(limitsP), timeSep, 1, 5, 1, 3, -1);
    %no smoothing:
                    CCDATA(count) = smooth_data(data.droplets(limitsP), timeSep, 2, 3, 2, 3, -1);
                    planesPositions{count} = planePositionsFun{di}(data.droplets(1).dropletPlane);
                end
            end
        end
    end
end
%% export data for alex
for i=1:numel(CCDATA)
    track(i).t = CCDATA(i).times;
    track(i).x = CCDATA(i).Orig.x;
    track(i).y = CCDATA(i).Orig.y;
    track(i).z = CCDATA(i).Orig.z;
    track(i).dropRadius = mean(CCDATA(i).dropRadius);
end

save('tracks.mat','track');
%%
if (doMovie)
    for count=1:numel(CCDATA)
        clear images
        if numel(imageFilenames{count}) > 1
            for i=1:numel(imageFilenames{count})
                images{i} = load_tiff_file(imageFilenames{count}{i},1);
            end
        elseif numel(imageFilenames{count}) > 0
            images = load_tiff_file(imageFilenames{count}{1},1);
            images = reshape(images,9,[]);
        end
        [centers, radii] = positionsToCR([data.droplets.dropletPosition]);
        Rmax = max(radii);
        cropRect = [Rmax, Rmax]*2;
        Movie = MakeMovieWithGraphs(images, CCDATA(count), false, [1,9,5], cropRect, planesPositions{count}, true, 1, -1, {'droplet','time','scale', 'planes', 'aggregate', 'size'});
        MovieFilename{count}
        v = VideoWriter(MovieFilename{count},'MPEG-4');
        v.FrameRate = 10;
        v.Quality = 100;
        open(v)
        writeVideo(v,Movie)
        close(v)
    end
end
%%
indsC=[];
indsB=[];
for c=1:numel(CCDATA)
    if max(CCDATA(c).Orig.r./CCDATA(c).dropRadius) < 0.3
        indsC = [indsC, c];
    else
        indsB = [indsB, c];
    end
end
SBDATA = [];
SDATA = [];
for ind = indsB
    sb = CCDATA(ind).Orig.r./CCDATA(ind).dropRadius;
    IFirst = find(sb<0.05,1, 'last');
    [~,ILast] = max(sb);
    if isempty(IFirst) || IFirst == 1
        IFirst=1;
    else
        SDATA = [SDATA, truncate(CCDATA(ind),1:IFirst)];
    end
    SBDATA = [SBDATA, truncate(CCDATA(ind),IFirst:ILast)];
end

[FigXY(1) ,ma(1)] = plot_movement_xy5(CCDATA(indsC), 'Centered droplets');
[FigXY(2) ,ma(2)] = plot_movement_xy5(SDATA, 'Symmetry breaking droplets - before symmetry breaking');
[FigXY(3) ,ma(3)] = plot_movement_xy5(SBDATA, 'Symmetry breaking droplets - during symmetry breaking');
[FigXY(4) ,ma(4)] = plot_movement_xy5(CCDATA(indsB), 'Symmetry breaking droplets');
[FigXY(5) ,ma(5)] = plot_movement_xy5(CCDATA, 'All droplets');

% [FigBursts, fit] = plot_numberOfBursts(CCDATA,0.5);

%%
for f=1:numel(FigXY)
    print(FigXY(f),fullfile(DIR,['tracks2 ',FigXY(f).Name,'.png']),'-dpng');
    print(FigXY(f),fullfile(DIR,['tracks2 ',FigXY(f).Name,'.eps']),'-depsc');
    print(FigXY(f),fullfile(DIR,['tracks2 ',FigXY(f).Name,'.pdf']),'-dpdf');
end
print(FigBursts(2),fullfile(DIR,['bursts', FigBursts(2).Name,'.png']),'-dpng');
print(FigBursts(2),fullfile(DIR,['bursts', FigBursts(2).Name,'.eps']),'-depsc');
print(FigBursts(2),fullfile(DIR,['bursts', FigBursts(2).Name,'.pdf']),'-dpdf');
