function Movie = MakeMovieWithGraph(Filename,slowFactor,slowFrames)
if ~exist('slowFrames','var')
    slowFrames = -1;
end
if ~exist('slowFactor','var')
    slowFactor = 1;
end
if length(slowFactor) > 1
    if length(slowFactor) ~= length(slowFrames)
        error('slowFactor must be either a scalar or a vector the same length as slowFrames');
    end
else
    slowFactor = slowFactor * ones(1,length(slowFrames));
end
[Dir,Name,Ext] = fileparts(Filename);
if ~strcmp(Ext,'.tiff') && ~strcmp(Ext,'.tif')
    error('Not a tiff file')
end
images = load_tiff_file(Filename,1);
pixelsPerMicron = 3.878724; % pixles per micron
calibration = 1/pixelsPerMicron; % microns per pixel
timeSep = 2; % seconds
if ~exist(fullfile(Dir,[Name,'_dropletPosition.txt']),'file') || ~exist(fullfile(Dir,[Name,'_aggregatePosition.txt']),'file')
    [dropletPosition,aggregatePosition] = ManualTrackMovie(Filename);
else
    dropletPosition = load(fullfile(Dir,[Name,'_dropletPosition.txt']));
    aggregatePosition = load(fullfile(Dir,[Name,'_aggregatePosition.txt']));
end
Xdroplet=ceil(dropletPosition(:,1)+(dropletPosition(:,3)/2));
Ydroplet=ceil(dropletPosition(:,2)+(dropletPosition(:,4)/2));
Xaggregate=ceil(aggregatePosition(:,1)+(aggregatePosition(:,3)/2));
Yaggregate=ceil(aggregatePosition(:,2)+(aggregatePosition(:,4)/2));

D = sqrt((Xaggregate-Xdroplet).^2 + (Yaggregate-Ydroplet).^2) * calibration;
time = ((1:length(D)) - 1)*timeSep;

subplot = @(M,N,P) subtightplot(M,N,P,[0.01,0.05],[0.18,0.05],[0,0.02]);
j=0;
for i=1:length(images)
    %fig = figure('Position',[100 100 620 205]);
    fig = figure('Position',[100 100 1800 500]);
    subplot(1,2,1);
    imshow(images{i})
    hold on 
    plot(Xaggregate(i),Yaggregate(i),'Color','none','Marker','+','MarkerEdgeColor','w', 'MarkerSize',10,'LineWidth',2);
    axF = subplot(1,2,2);
    plot(time,D,'LineWidth',2)
    axF.FontSize = 18;
    ylabel('distance from center [{\mu}m]')
    xlabel('time [sec]')
    [DMax, DMaxInd] = max(D);
    tMagnetOff = time(DMaxInd);
    [X,Y] = DataToNormalized([tMagnetOff + 100, tMagnetOff+2],[DMax+1 DMax], axF);
    a = annotation('textarrow',X, Y,'String', 'Magnet Off','FontSize',18); 
    a.Color = 'red';
    hold on
    plot(time(i),D(i),'Color','none','Marker','+','MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2);
    Movie(i+j) = getframe(fig);
    if ismember(i,slowFrames)
        for n=1:(slowFactor(i) - 1)
            j = j+1;
            Movie(i+j) = getframe(fig);
        end
    end
    close(fig);
end
    v = VideoWriter(fullfile(Dir,[Name,'_movie_with_graph.mp4']),'MPEG-4');
    v.FrameRate = 20;
    open(v)
    writeVideo(v,Movie)
    close(v)
    poster_image = frame2im(Movie(1));
    imwrite(poster_image,fullfile(Dir,[Name,'_movie_with_graph-poster.png']));
end
