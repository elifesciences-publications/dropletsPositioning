function Movie = MakeMovieWithGraph2(images, dropletPosition, aggregatePosition, timeSep, color,slowFactor,slowFrames)
if ~exist('slowFrames','var')
    slowFrames = -1;
end
if ~exist('slowFactor','var')
    slowFactor = 1;
end
if ~exist('color','var')
    color = false;
end
if ~exist('timeSep','var')
    timeSep = 1; % seconds
end

if length(slowFactor) > 1
    if length(slowFactor) ~= length(slowFrames)
        error('slowFactor must be either a scalar or a vector the same length as slowFrames');
    end
else
    slowFactor = slowFactor * ones(1,length(slowFrames));
end
pixelsPerMicron =  1.2; % pixles per micron
calibration = 1/pixelsPerMicron; % microns per pixel
for i=1:numel(dropletPosition)
    Xdroplet{i}=ceil(dropletPosition{i}(1,:)+(dropletPosition{i}(3,:)/2));
    Ydroplet{i}=ceil(dropletPosition{i}(2,:)+(dropletPosition{i}(4,:)/2));
    Xaggregate{i}=ceil(aggregatePosition{i}(1,:)+(aggregatePosition{i}(3,:)/2));
    Yaggregate{i}=ceil(aggregatePosition{i}(2,:)+(aggregatePosition{i}(4,:)/2));
    Rdroplet{i} = dropletPosition{i}(3,:)/2;
    D{i} = sqrt((Xaggregate{i}-Xdroplet{i}).^2 + (Yaggregate{i}-Ydroplet{i}).^2) * calibration;
end
time = ((1:length(D{1})) - 1)*timeSep/60;
imageSize = size(images{1});
graphSize = [imageSize(1),imageSize(1)*1.5];
% widhtFactor = imageSize(2)/graphSize(2);
rightMargin = 20;
leftMargin = 50;
topMargin = 20;
bottomMargin = 80;
sep = 80;

figureSize = [imageSize(2)+ graphSize(2) + rightMargin + leftMargin + sep, imageSize(1) + topMargin + bottomMargin];

rightMarginF = rightMargin/figureSize(1);
leftMarginF = leftMargin/figureSize(1);
topMarginF = topMargin/figureSize(2);
bottomMarginF = bottomMargin/figureSize(2);
sepF = sep/figureSize(1);
imWidthF = imageSize(2)/figureSize(1);
figWidthF = 1 - imWidthF - sepF - rightMarginF - leftMarginF;
imAxPos = [leftMarginF,bottomMarginF,imWidthF,1 - topMarginF - bottomMarginF];
figAxPos = [leftMarginF + imWidthF + sepF, bottomMarginF, figWidthF, 1 - topMarginF - bottomMarginF];
% subplot = @(M,N,P) subtightplot(M,N,P,[0.01,0.05],[0.18,0.05],[0,0.02]);
j=0;
for i=1:length(images)
    %fig = figure('Position',[100 100 620 205]);
%    fig = figure('Position',[100, 100, 1800 500]);
    fig = figure('Position',[100, 100, figureSize]);
%     subplot(1,2,1);
    imAx = subplot('Position', imAxPos);
    plotAx = subplot('Position',figAxPos);
    im = images{i};
    axes(imAx);
    if color
        imRGB = zeros([size(im),3]);
        imRGB(:,:,2) = double(im)./double(max(im(:)));
        imshow(imRGB);
    else
        imshow(im);
    end
    hold on
    ColorOrder = get(imAx,'ColorOrder');
    ColorOrder(2,:) = [];
    magentLine = [0,max([D{:}])];
    for k=1:numel(Xdroplet)
        col = ColorOrder(k,:);
%         subplot(1,2,1);
        axes(imAx);
        plot(Xaggregate{k}(i),Yaggregate{k}(i),'Color',col,'Marker','+', 'MarkerSize',10,'LineWidth',2);
        v = viscircles([Xdroplet{k}(i),Ydroplet{k}(i)], Rdroplet{k}(i),'Color',col,'EnhanceVisibility',false);
%         axF = subplot(1,2,2);
        axes(plotAx);
        plot(time,D{k},'LineWidth',2,'Color',col);
        hold on
        if slowFrames(end) > 1
            plot([1,1]*slowFrames(end)*timeSep/60,magentLine,'r--');
            text(timeSep/60, magentLine(end), {'Magnet','on'},'FontSize',16, 'Color', 'g');
            text(slowFrames(end)*timeSep/60 + timeSep/60, magentLine(end), {'Magnet','off'},'FontSize',16, 'Color', 'r');
        end
        plotAx.FontSize = 16;
        ylabel('distance from center [{\mu}m]')
        xlabel('time [min]')
        %     [DMax, DMaxInd] = max(D);
        %     tMagnetOff = time(DMaxInd);
        %     [X,Y] = DataToNormalized([tMagnetOff + 100, tMagnetOff+2],[DMax+1 DMax], axF);
        %     a = annotation('textarrow',X, Y,'String', 'Magnet Off','FontSize',18);
        %     a.Color = 'red';
        plot(time(i),D{k}(i),'Color','none','Marker','+','MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2);
    end
    ylim([0,60])
    Movie(i+j) = getframe(fig);
    [~, loc] = ismember(i,slowFrames)
    if loc
        for n=1:(slowFactor(loc) - 1)
            j = j+1;
            Movie(i+j) = getframe(fig);
        end
    end
    close(fig);
end
%     v = VideoWriter(fullfile(Dir,[Name,'_movie_with_graph.mp4']),'MPEG-4');
%     v.FrameRate = 20;
%     open(v)
%     writeVideo(v,Movie)
%     close(v)
%     poster_image = frame2im(Movie(1));
%     imwrite(poster_image,fullfile(Dir,[Name,'_movie_with_graph-poster.png']));
end
