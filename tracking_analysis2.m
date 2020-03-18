doMovie = false;
warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning');
DIRS{3} = {'Z:\analysis\Niv\tracking\2018_05_16'};
limits{3} = {1:69, 1:80, 1:110, [], 1:115};
PI{3} = [1:3,5];
Reg{3} = '*Position %d*';
planePositionsFun{3} = @(dropletPlane) (-10:5:10) + (dropletPlane - 3) * 5;
DIRS{1} = {'Z:\analysis\Niv\tracking\2018_06_19';...
    'Z:\analysis\Niv\tracking\2018_06_18';...
    'Z:\analysis\Niv\tracking\2018_08_05\mix1 sample1';...
    'Z:\analysis\Niv\tracking\2018_08_05\mix2 sample1';...
    'Z:\analysis\Niv\tracking\2018_08_02\mix1 sample1'};
PI{1} = 1:5;
Reg{1} = '*Position %d*';
planePositionsFun{1} = @(dropletPlane) (-20:5:20) + (dropletPlane - 5) * 5;
DIRS{2} = {'Z:\analysis\Niv\tracking\2018_07_30'};
PI{2} = [77,78,80,81]; % 79 is weird - huge aggregate
Reg{2} = 'P*%d*';
planePositionsFun{2} = @(dropletPlane) (-20:5:20) + (dropletPlane - 5) * 5;

% for posIndex = [1:3,5];
clear CCDATA
count = 0;
for di = 1:numel(DIRS)
    for dj = 1:numel(DIRS{di})
        DIR = DIRS{di}{dj};
        for posIndex = PI{di};
            %          filename_regexp = sprintf('P*%d*_C0.tiff', posIndex);
            filename_regexp = sprintf([Reg{di}, '_C0.tiff'], posIndex);
            
            
            clear filenames images;
            fs = ls(fullfile(DIR,filename_regexp));
            if size(fs,1) > 1
                for i=1:size(fs,1)
                    filenames{i} = fullfile(DIR,fs(i,:));
                    if (doMovie)
                        images{i} = load_tiff_file(filenames{i},1);
                    end
                end
            elseif size(fs,1) > 0
                filenames = {fullfile(DIR,fs)};
                if (doMovie)
                    images = load_tiff_file(filenames{1},1);
                    images = reshape(images,9,[]);
                end
            else continue;
            end
            %
            %         % one_position_gui_obj(filenames, images);
            %
            %
            %         % dataFilename = fullfile(DIR,sprintf('Capture 2 - Position %d_Z0.mat', posIndex));
            %         % dataFilename = fullfile(DIR,sprintf('Capture 5 - Position %d.mat', posIndex));
            %         % dataFilename = fullfile(DIR,sprintf('Capture 3 - Position %d.mat', posIndex));
            [D,F,E] = fileparts(filenames{1});
            %         dfs = ls(fullfile(D,[F, '*.mat']));
            dfs = ls(fullfile(D,sprintf([Reg{di}, '.mat'], posIndex)));
            for i=1:size(dfs,1)
                count = count + 1;
                dataFilename{count} = fullfile(D,dfs(i,:));
                %
                data = load(dataFilename{count});
                %             limitsP = limits{posIndex};
                if isempty(limits{di})
                    limitsP = 1:length(data.droplets);
                else
                    limitsP = limits{di}{posIndex};
                end
                
                timeSep = 30;
                CCDATA(count) = smooth_data(data.droplets(limitsP), timeSep, 1, 5, 1, 3, -1);
                if (doMovie)
                    [centers, radii] = positionsToCR([data.droplets.dropletPosition]);
                    % Cmin = min(centers');
                    % Cmax = max(centers');
                    Rmax = max(radii);
                    cropRect = [Rmax, Rmax]*2;
                    % cropRect = [Cmin(1) - Rmax, Cmin(2) - Rmax, Cmax(1) - Cmin(1) + 2*Rmax, Cmax(2) - Cmin(2) + 2*Rmax];
                    % dropPos1 = data.droplets(Imin).dropletPosition;
                    % dropPos2 = data.droplets(Imax).dropletPosition;
                    % dropPosDiff = dropPos2 - dropPos1;
                    % cropRect = [min(dropPos1(1:2), dropPos2(1:2)), max(dropPos1(3:4), dropPos2(3:4)) + abs(dropPosDiff(1:2))];
                    %             planePositions = (-10:5:10) + (data.droplets(1).dropletPlane - 3) * 5;
                    planesPositions = planePositionsFun{di}(data.droplets(1).dropletPlane);
                    
                    Movie = MakeMovieWithGraphs(images, CCDATA(count), false, [1,4,5], cropRect, planesPositions, true, 1, -1, {'droplet','time','scale', 'plane', 'aggregate'});
                    
                    if size(dfs,1) == 1
                        MovieFilename = fullfile(DIR,sprintf('tracking movie%d.mp4', posIndex));
                    elseif size(dfs,1) >1
                        MovieFilename = fullfile(DIR,sprintf('tracking movie%d_%d.mp4', posIndex,i));
                    else
                        error('size(dfs,1) = 0');
                    end
                    MovieFilename
                    v = VideoWriter(MovieFilename,'MPEG-4');
                    
                    v.FrameRate = 10;
                    open(v)
                    writeVideo(v,Movie)
                    close(v)
                end
            end
        end
    end
end
%     CCDATA_C = CCDATA([1:17,19:end]);
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
    [FigBursts, fit] = plot_numberOfBursts(CCDATA,3.5);
%%
    for f=1:numel(FigXY)
        print(FigXY(f),fullfile(DIR,['tracks2 ',FigXY(f).Name,'.png']),'-dpng');
        print(FigXY(f),fullfile(DIR,['tracks2 ',FigXY(f).Name,'.eps']),'-depsc');
        print(FigXY(f),fullfile(DIR,['tracks2 ',FigXY(f).Name,'.pdf']),'-dpdf');
    end
    print(FigBursts,fullfile(DIR,['bursts', FigBursts.Name,'.png']),'-dpng');
    print(FigBursts,fullfile(DIR,['bursts', FigBursts.Name,'.eps']),'-depsc');
    print(FigBursts,fullfile(DIR,['bursts', FigBursts.Name,'.pdf']),'-dpdf');
