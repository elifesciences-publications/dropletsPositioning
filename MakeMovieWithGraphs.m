function Movie = MakeMovieWithGraphs(images, Data, smoothFlag, plotFlags, cropRectIn, planePositions, colorImageFlag, slowFactor, magnetFrames, overlays)
    if ~exist('magnetFrames','var')
        magnetFrames = -1;
    end
    
    if ~exist('slowFactor','var')
        slowFactor = 1;
    end
    if length(slowFactor) > 1
        if length(slowFactor) ~= length(magnetFrames)
            error('slowFactor must be either a scalar or a vector the same length as slowFrames');
        end
    else
        slowFactor = slowFactor * ones(1,length(magnetFrames));
    end
    if ~exist('smoothFlag', 'var')
        smoothFlag = true;
    end

    if ~exist('plotFlags', 'var')
        plotFlags = [1,2,3];
    end
    
    if ~exist('planePositions','var')
        planePositions = 0;
    end
    
    if ~exist('colorImageFlag','var')
        colorImageFlag = false;
    end
    
    if ~exist('overlays', 'var')
        overlays = {};
    end
    overlayFlagNames = {'planes', 'aggregate', 'time', 'droplet', 'scale', 'size'};
    for f=1:numel(overlayFlagNames)
        flagName = overlayFlagNames{f};
        if sum(ismember(overlays, flagName))
            overlayFlags.(flagName) = true;
        else
            overlayFlags.(flagName) = false;
        end
    end

    if iscell(images{1})
        imageSize = flip(size(images{1}{1}));
    else
        imageSize = flip(size(images{1}));
    end
    
    if ~exist('cropRectIn','var') || length(cropRectIn) < 2
        cropRect = [1,1,imageSize];
        cropSize = imageSize;
    elseif length(cropRectIn) == 4
        cropRect = cropRectIn;
        if cropRect(1) + cropRect(3) - 1 > imageSize(1)
            cropRect(3) = imageSize(1) - cropRect(1) + 1;
        end
        if cropRect(2) + cropRect(4) - 1 > imageSize(2)
            cropRect(4) = imageSize(2) - cropRect(2) + 1;
        end
        cropSize = cropRect(3:4);
    elseif length(cropRectIn) == 2
        cropSize = cropRectIn;
    else
        error('cropRect must have 1, 2 or 4 elements');
    end
    
    cropRectCenter = round(cropSize/2);
    
    if smoothFlag
        Xdroplet = Data.XdropletSmooth;
        Ydroplet = Data.YdropletSmooth;
        Xaggregate = Data.XaggregateSmooth;
        Yaggregate = Data.YaggregateSmooth;
        Zaggregate = Data.ZaggregateSmooth;
%         D = CCData.Orig.rSmooth;
%         % V = CCData.Orig.VrSmooth;
%         V = sqrt(CCData.Orig.VxSmooth.^2 + CCData.Orig.VySmooth.^2 + CCData.Orig.VzSmooth.^2);
%         VVcorrNN = [CCData.Orig.VxSmooth(1:end-1); CCData.Orig.VySmooth(1:end-1); CCData.Orig.VzSmooth(1:end-1)] .* [CCData.Orig.VxSmooth(2:end); CCData.Orig.VySmooth(2:end); CCData.Orig.VzSmooth(2:end)];
    else
        Xdroplet = Data.Xdroplet;
        Ydroplet = Data.Ydroplet;
        Xaggregate = Data.Xaggregate;
        Yaggregate = Data.Yaggregate;
        Zaggregate = Data.Zaggregate;
%         D = CCData.Orig.r;
%         % V = CCData.Orig.Vr;
%         V = sqrt(CCData.Orig.Vx.^2 + CCData.Orig.Vy.^2 + CCData.Orig.Vz.^2);
%         VVcorrNN = [CCData.Orig.Vx(1:end-1); CCData.Orig.Vy(1:end-1); CCData.Orig.Vz(1:end-1)] .* [CCData.Orig.Vx(2:end); CCData.Orig.Vy(2:end); CCData.Orig.Vz(2:end)];
    end
    Rdroplet = Data.dropRadius;
    Raggregate = Data.aggRadius;
    RdropletPixels = Rdroplet / Data.calibration;
    RaggregatePixels = Raggregate / Data.calibration;
    D = Data.Orig.rSmooth;
    % V = CCData.Orig.VrSmooth;
    V = sqrt(Data.Orig.VxSmooth.^2 + Data.Orig.VySmooth.^2 + Data.Orig.VzSmooth.^2);
    Vr = Data.Orig.VrSmooth;
    Vx = Data.Orig.VxSmooth;
    timepoints = Data.timepoints;
%     VVcorrNN = [Data.Orig.Vx(1:end-1); Data.Orig.Vy(1:end-1); Data.Orig.Vz(1:end-1)] .* [Data.Orig.Vx(2:end); Data.Orig.Vy(2:end); Data.Orig.Vz(2:end)];
    Vvec = [Data.Orig.Vx; Data.Orig.Vy; Data.Orig.Vz];
    VVcorrelationStep = 3;
    VVcorr = sum(Vvec(:,1:end-VVcorrelationStep) .* Vvec(:,(VVcorrelationStep+1):end));
    VVcorr = VVcorr/mean(sum(Vvec.*Vvec));
    VVcorr = savitzkyGolayFilt(VVcorr, 1,0,5);
    Direction = Vvec./repmat(sqrt(sum(Vvec.^2)),3,1);
    DDcorr = sum(Direction(:,1:end-VVcorrelationStep) .* Direction(:,(VVcorrelationStep+1):end));
    DDcorrSmooth = savitzkyGolayFilt(DDcorr, 1,0,5);
    timeSep = Data.timeSep;
    time = Data.times; %((1:length(D)) - 1)*timeSep/60;
    timepoints = Data.timepoints;
    firstPoint = timepoints(1);
    if magnetFrames(end) < 1
        ReleasedFrames = 1:length(D);
    else
%         ReleasedFrames = (magnetFrames(end)+1):length(D);
        ReleasedFrames = (max(1,magnetFrames(end) + 1 - firstPoint)):length(D);
    end
    
    rightMargin = 10;
    leftMargin = 10;
    topMargin = 10;
    bottomMargin = 60;
    sepH = 80;
    sepV = 40;
    plotSize = [300,150];
    numberOfPlots = numel(plotFlags);
    
    DisplayedImageSize = cropSize * 600/cropSize(2);
    figureHeight = 600;
    if numberOfPlots > 0
    	plotSize(2) = (figureHeight - (bottomMargin + topMargin + sepV*(numberOfPlots - 1)))/numberOfPlots;
        plotSize(1) = plotSize(2)*2;
        DisplayedImageSize = cropSize * (figureHeight - bottomMargin - topMargin)/cropSize(2);
        figureSize = [DisplayedImageSize(1) + plotSize(1) + rightMargin + leftMargin + sepH, figureHeight];
    else
        figureSize = DisplayedImageSize;
    end

%     if numberOfPlots > 0
%     	figureHeight = plotSize(2) * numberOfPlots + bottomMargin + topMargin + sepV*(numberOfPlots - 1);
%         DisplayedImageSize = cropSize * (figureHeight - bottomMargin - topMargin)/cropSize(2);
%         figureSize = [DisplayedImageSize(1) + plotSize(1) + rightMargin + leftMargin + sepH, figureHeight];
%     else
%         DisplayedImageSize = cropSize * 600/cropSize(2);
%         figureSize = DisplayedImageSize;
%     end
    
    rightMarginF = rightMargin/figureSize(1);
    leftMarginF = leftMargin/figureSize(1);
    topMarginF = topMargin/figureSize(2);
    bottomMarginF = bottomMargin/figureSize(2);
    sepHF = sepH/figureSize(1);
    sepVF = sepV/figureSize(2);
    imWidthF = DisplayedImageSize(1)/figureSize(1);
    plotWidthF = plotSize(1)/figureSize(1);
    plotHeigthF = plotSize(2)/figureSize(2);
    
    imAxPos = [leftMarginF,bottomMarginF,imWidthF,1 - topMarginF - bottomMarginF];
    for p=1:numberOfPlots
        figAxPos(p,:) = [leftMarginF + imWidthF + sepHF, bottomMarginF + (p-1)*(plotHeigthF + sepVF), plotWidthF, plotHeigthF];
    end
    
    fig = figure('Position',[100, 100, figureSize]);
    imAx = subplot('Position', imAxPos);
    for p=1:numberOfPlots
        plotAx(p) = subplot('Position',figAxPos(p,:));
    end
    ColorOrder = get(imAx,'ColorOrder');
    col = ColorOrder(1,:);
    j=0;
    for i=1:min(length(images),timepoints(end))
        cla(imAx);
        for p=1:numberOfPlots
            cla(plotAx(p));
        end
        dataInd = max(i-firstPoint+1,1);
        plane = round(Zaggregate(dataInd));
        if iscell(images{1})
            image = images{i}{plane};
        else
            image = images{plane,i};
        end
        
         if length(cropRectIn) == 2
            cropRect = round([-cropRectCenter, cropSize] + [Xaggregate(i), Yaggregate(i), 0, 0]);
            prePadsize = max(0 ,[1 - cropRect(2),1 - cropRect(1)]);
            postPadsize = max(0, [cropRect(2), cropRect(1)] + [cropRect(4), cropRect(3)] - size(image));
            im = imcrop(image,cropRect);
            im = padarray(im,prePadsize,0,'pre');
            im = padarray(im,postPadsize,0,'post');
            dropCenter = cropRectCenter + [Xdroplet(i),Ydroplet(i)] - [Xaggregate(i),Yaggregate(i)];
            aggCenter = cropRectCenter;
%         if length(cropRectIn) == 2
%             cropRect = round([-cropRectCenter, cropSize] + [Xdroplet(i), Ydroplet(i), 0, 0]);
%             prePadsize = max(0 ,[1 - cropRect(2),1 - cropRect(1)]);
%             postPadsize = max(0, [cropRect(2), cropRect(1)] + [cropRect(4), cropRect(3)] - size(image));
%             im = imcrop(image,cropRect);
%             im = padarray(im,prePadsize,0,'pre');
%             im = padarray(im,postPadsize,0,'post');
%             dropCenter = cropRectCenter;
%             aggCenter = cropRectCenter - [Xdroplet(i),Ydroplet(i)] + [Xaggregate(i),Yaggregate(i)];
        else
            im = imcrop(image,cropRect);
            if i >= firstPoint
                dropCenter = [Xdroplet(dataInd),Ydroplet(dataInd)] - cropRect(1:2);
                aggCenter = [Xaggregate(dataInd),Yaggregate(dataInd)] - cropRect(1:2);
            else
                dropCenter = -1;
                aggCenter = - 1;
            end
        end
        if i < firstPoint
            imageFrame(imAx, im, dropCenter, RdropletPixels(i), aggCenter, RaggregatePixels(i), col, colorImageFlag, false, false);
        else
            imageFrame(imAx, im, dropCenter, RdropletPixels(dataInd), aggCenter, RaggregatePixels(dataInd), col, colorImageFlag, overlayFlags.droplet, overlayFlags.aggregate);
            if overlayFlags.size
                text(cropSize(1) - 60, 10,sprintf('D=%d{\\mu}m',round(2 * mean(Rdroplet))),'FontSize',25,'Color','w', 'Parent', imAx);
            end
            if overlayFlags.time
                text(5, 10,sprintf('%02d:%02d',floor(time(dataInd)/60), mod(round(time(dataInd)),60)),'FontSize',25,'Color','w', 'Parent', imAx);
            end
            if overlayFlags.scale
                scalebarPos = flip(size(im)) - [40/Data.calibration, 16];
                scalebar(imAx, 'Position', scalebarPos,'XLen',20,'YLen',2, 'XUnit', '{\mu}m',...
                    'hTextX_Pos', [2,5], 'Border', 'LN', 'FontSize', 25, 'Calibration',...
                    Data.calibration, 'Color', 'w', 'LineWidth', 3);
            end
            if overlayFlags.planes && length(planePositions) > 1
                zStackDiagram(imAx, [5,120,30,30] * cropSize(2)/150, RdropletPixels(1), planePositions / Data.calibration , plane);
            end
            for p=1:numberOfPlots
                if p == 1
                    xAxFlag = true;
                else
                    xAxFlag = false;
                end
                callPlot(plotAx(p), plotFlags(p),xAxFlag);
            end
        end
        Movie(i+j) = getframe(fig);
        
        [~, loc] = ismember(i,magnetFrames);
        if loc
            for n=1:(slowFactor(loc) - 1)
                j = j+1;
                Movie(i+j) = getframe(fig);
            end
        end
    end
    close(fig);
    
    function callPlot(ax, plotFlag, xAxFlag)
        flipAx = (magnetFrames(1) >=0);
        if magnetFrames(end) >= firstPoint
            ReleasedIndex = i - magnetFrames(end);
        else
            ReleasedIndex = dataInd;
        end
        switch plotFlag
            case 1
                positionPlotFrame(ax, D, time/60, dataInd, mean(Rdroplet) - max(Raggregate), col, magnetFrames(end)*timeSep/60, xAxFlag);
            case 2
                VTPlotFrame(ax, V(ReleasedFrames), time(ReleasedFrames)/60, ReleasedIndex , col, i - magnetFrames(end), xAxFlag);
            case 3
                VDPlotFrame(ax, V(ReleasedFrames), D(ReleasedFrames), ReleasedIndex, col, i - magnetFrames(end), flipAx, xAxFlag);
            case 4
                first = ceil((VVcorrelationStep+1)/2);
                last = ceil((VVcorrelationStep)/2);
                VVCorrPlotFrame(ax, VVcorr(ReleasedFrames(1:end-VVcorrelationStep)), time(ReleasedFrames(1:end-VVcorrelationStep))/60,...
                    Vr(ReleasedFrames(first:end-last)),  ReleasedIndex, col, i - magnetFrames(end), xAxFlag);
            case 5
                VTPlotFrame(ax, Vr(ReleasedFrames), time(ReleasedFrames)/60, ReleasedIndex , col, i - magnetFrames(end), xAxFlag);
            case 6
                VDPlotFrame(ax, Vr(ReleasedFrames), D(ReleasedFrames), ReleasedIndex, col, i - magnetFrames(end), flipAx, xAxFlag);
            case 7
                if ~isfield(Data.Orig,'intensityImbalance') || isempty(Data.Orig.intensityImbalance)
                    Data = velocityImbalance(CCData, images);
                end
                imbalancePlotFrame(ax, Data.Orig.intensityImbalance(3,ReleasedFrames), time(ReleasedFrames)/60, ReleasedIndex, col, i - magnetFrames(end), xAxFlag);
            case 8
                VTPlotFrame(ax, -Vx(ReleasedFrames), time(ReleasedFrames)/60, ReleasedIndex , col, i - magnetFrames(end), xAxFlag);
            case 9
                first = ceil((VVcorrelationStep+1)/2);
                last = ceil((VVcorrelationStep)/2);
                yLabel = '$\hat{v}(t)\cdot \hat{v}(t+dt)$';
                VVCorrPlotFrame(ax, DDcorrSmooth(ReleasedFrames(1:end-VVcorrelationStep)), time(ReleasedFrames(1:end-VVcorrelationStep))/60,...
                    Vr(ReleasedFrames(first:end-last)),  ReleasedIndex, col, i - magnetFrames(end), xAxFlag, yLabel);
        end
    end
end

function imageFrame(ax, image, dropCenter, dropR, aggCenter, aggR, col, colorImageFlag, dropletFlag, aggregateFlag)
    if colorImageFlag
        imRGB = zeros([size(image),3]);
        imRGB(:,:,2) = imadjust(double(image)./double(max(image(:))));
        imshow(imRGB, 'Parent', ax);
    else
        imshow(imadjust(image, stretchlim(image,[0.5,1 - 0.02])), 'Parent', ax);
        imshow(imadjust(image), 'Parent', ax);
    end
    hold(ax, 'on');
    if aggregateFlag
        plot(ax, aggCenter(1), aggCenter(2) ,'Color',col,'Marker','+', 'MarkerSize',10,'LineWidth',2);
        viscircles(ax, aggCenter, aggR,'Color',col,'EnhanceVisibility',false);
    end
    if dropletFlag
        viscircles(ax, dropCenter, dropR,'Color',col,'EnhanceVisibility',false);
    end
end

function zStackDiagram(ax, pos, dropletRadius, planePositions, curPlane)
    text(pos(1), pos(2) - 2, 'Imaging Plane', 'color', 'w', 'Parent', ax, 'FontSize',20);
    center = pos(1:2) + pos(3:4)/2;
    radius = min(pos(3:4)/2.5);
    factor = radius/dropletRadius;
    planeNormalisedPositions = flip(planePositions) * factor;
    viscircles(ax, center, radius, 'EnhanceVisibility', false, 'color', 'w', 'lineWidth', 0.5);
    X = repmat([pos(1), pos(1)+pos(3)]', 1,length(planePositions));
    Y = [planeNormalisedPositions; planeNormalisedPositions] + center(2);
    line(X, Y, 'color' ,'y', 'Parent', ax);
    line(X(:,curPlane), Y(:,curPlane), 'color' ,'r', 'lineWidth', 2, 'Parent', ax);
end

function positionPlotFrame(ax, D, time, index, maxR, col, magnetLinePos, xAxFlag)
    magentLine = [0,max(D) + 10];
    plot(ax, time, D, 'LineWidth', 2, 'Color', col);
    hold(ax, 'on');
    plot(ax, time, maxR * ones(size(time)), 'k--');
    if exist('magnetLinePos', 'var') && magnetLinePos > 0
        plot(ax, [1,1]*magnetLinePos,magentLine,'r--');
        text(magnetLinePos * 1.1, magentLine(end) - 10, {'Magnet','off'},'FontSize',14, 'Color', 'r', 'Parent', ax);
    end
    ax.FontSize = 15;
    ylabel(ax, 'Position [{\mu}m]')
    if xAxFlag
        xlabel(ax, 'Time [min]');
    else
        ax.XTickLabel=[];
    end
    plot(ax, time(index),D(index),'Color','none','Marker','+','MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2);
    ylim(ax, [0,max(max(D), maxR) + 5])
    xlim(ax, [0, max(time)]);
end

function VTPlotFrame(ax, V, time, index, col, putMarker, xAxFlag)
    plot(ax, time, V, 'LineWidth', 2, 'Color', col);
    hold(ax, 'on');
    if putMarker > 0
        plot(ax, time(index),V(index),'Color','none','Marker','+','MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2);
    end
    ax.FontSize = 15;
    ylabel(ax, 'Velocity [$\frac{{\mu}m}{min}$]', 'Interpreter', 'latex');
    ylim(ax, [min([0,V - 0.5]), max([0, V + 0.5])]);
    plot(ax, time, 0 * time, 'k--');
    if xAxFlag
        xlabel(ax, 'Time [min]');
    else
        ax.XTickLabel=[];
    end
    xlim(ax, [0, max(time)]);
end

function VVCorrPlotFrame(ax, VVcorr, time, Vr, index, col, putMarker, xAxFlag, yLabel)
    if ~exist('yLabel','var')
        yLabel = '$\left|v(t)\cdot v(t+dt)\right|$';
    end
    thredhold = 0.5;
    plot(ax, time, VVcorr, 'LineWidth', 2, 'Color', col);
    [L, numberOfBursts] = bwlabel(VVcorr > thredhold & Vr > 0);
    hold(ax, 'on');
    for i = 1:numberOfBursts
        ind = find((L == i));
        if ind(1) > 1
            ind = [ind(1)-1, ind];
        end
        if ind(end) < length(VVcorr)
            ind = [ind, ind(end)+1];
        end
        plot(ax, time(ind), VVcorr(ind), 'LineWidth', 2, 'Color', [1,0.5,0.5]);
    end
    if putMarker > 0 && index <= length(VVcorr)
        plot(ax, time(index),VVcorr(index),'Color','none','Marker','+','MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2);
    end
    ax.FontSize = 15;
    ylabel(ax, yLabel,'Interpreter', 'latex');
    ylim(ax, [min([0,VVcorr - 0.5]), max([0, VVcorr + 0.5])]);
    plot(ax, time, 0 * time, 'k--');
    if xAxFlag
        xlabel(ax, 'Time [min]');
    else
        ax.XTickLabel=[];
    end
    xlim(ax, [0, max(time)]);
end

function VDPlotFrame(ax, V, D, index, col, putMarker, flipAx, xAxFlag)
    plot(ax, D,V,'LineWidth',2,'Color',col);
    hold(ax, 'on');
    if putMarker > 0
        plot(ax, D(index), V(index),'Color','none','Marker','+','MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2);
    end
    ax.FontSize = 15;
    ylabel(ax, 'Velocity [$\frac{{\mu}m}{min}$]', 'Interpreter', 'latex');
    xlabel(ax, 'Position [{\mu}m]')
    ylim(ax, [min([0,V - 0.5]), max([0, V + 0.5])]);
    plot(ax, D, 0 * D, 'k--');
    if flipAx
        set(ax, 'XDir','reverse')
    end
    xlim(ax, [0, max(D)]);
end

function imbalancePlotFrame(ax, intensityImbalance,time, index, col, putMarker, xAxFlag)
    plot(ax, time, intensityImbalance, 'LineWidth', 2, 'Color', col);
    hold(ax, 'on');
    if putMarker > 0
        plot(ax, time(index),intensityImbalance(index),'Color','none','Marker','+','MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2);
    end
    ax.FontSize = 15;
    ylabel(ax, {'Intensity', 'imbalance [A.U.]'}, 'Interpreter', 'latex');
    ylim(ax, [min([0,intensityImbalance - 0.5]), max([0, intensityImbalance + 0.5])]);
%     plot(ax, time, 0 * time, 'k--');
    if xAxFlag
        xlabel(ax, 'Time [min]');
    else
        ax.XTickLabel=[];
    end
    xlim(ax, [0, max(time)]);
end
