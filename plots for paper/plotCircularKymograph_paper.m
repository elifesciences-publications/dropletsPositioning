function Figs = plotCircularKymograph_paper(CCData, bandNum, frameImages, frames, background_value, cl)
    % Integrate Kymograph with angular factor to calculate asymmetry
%    imbalance = -sin(theta) * circularKymograph' * 1e-5;
if ~exist('background_value','var')
    background_value = 0;
end
% ----------------------------- Figure ---------------------------------- %
    figureSize = [500, 300];
    positionKym = [0.07, 0.125, 0.37, 0.825];
    positionImbalance = [0.49, 0.125, 0.22, 0.825];
    positionV = [0.76, 0.125, 0.22, 0.825];
    
% ----------------------------- Plot kymograph -------------------------- %
    Fig = figure('Position', [300,100,figureSize]);
%     set(Fig,'defaulttextinterpreter','latex')
    KymAx = subplot('Position', positionKym);
    startInd = CCData.lastMagnetFrame + 1;
    times = CCData.times/60;
    times = times - times(startInd);
    yl = [times(startInd), times(end)];
    im = imagesc(CCData.KymographTheta, yl, CCData.Kymograph(startInd:end,:,bandNum)-background_value);%, [0, intmax(class(image))]);
    if exist('cl','var')
        clim = KymAx.CLim.*cl;
        KymAx.CLim = clim;
    end
    KymAx.XTick = [0, 0.5*pi, pi, 1.5*pi, 2*pi];
    KymAx.XTickLabel = {'top','left', 'bottom', 'right', 'top'};
%     KymAx.XTickLabel = {'0','$\frac{1}{2}\pi$', '$\pi$', '$\frac{3}{2}\pi$', '$2\pi$'};
%     KymAx.TickLabelInterpreter='latex';
    
    KymAx.FontSize = 8;
    KymAx.LabelFontSizeMultiplier = 1;
    KymAx.TitleFontSizeMultiplier = 1.25;

%     ax.YAxisLocation = 'right';
    ylabel('Time [min]');
    xlabel('Angle');
    title('Intensity Kymograph','FontSize',8);
%     c = colorbar('westoutside');
%     c.Label.String = 'Intensity';
    lineX = 0:0.1:(2*pi);
    lineY = ones(size(lineX));
    hold on
    for f=1:length(frames)
        frame = frames(f);
        t = times(frame);
        plot(lineX, t*lineY, '--', 'Color',[0.96,0.96,0.96], 'LineWidth', 0.5);
    end
    clim = KymAx.CLim;
    cb = colorbar('Ticks', [clim(2)/2,clim(2)], 'TickLabels', {'0.5','1'});
    cb.Label.String = 'Intensity [A.U.]';
%     cb.Location = 'manual';
     cb_pos = cb.Position;
     cb_pos(1) = 0.454;
     cb.Position = cb_pos;

% ----------------------------- Plot imbalance -------------------------- %
    imbalanceAx = subplot('Position', positionImbalance);
    plot(CCData.Orig.intensityImbalance(bandNum,:), times);
    imbalanceAx.YDir = 'reverse';
    imbalanceAx.YTickLabel = {};
    imbalanceAx.FontSize = 8;
    imbalanceAx.LabelFontSizeMultiplier = 1;
    imbalanceAx.TitleFontSizeMultiplier = 1.25;

    ylim(yl);
    title('Intensity Imbalance','FontSize',8);
    xlabel('[a.u.]');
    xlim([-0.5,1.5]);
    xl = xlim;
    lineX = xl;
    lineY = ones(size(lineX));
    hold on
    for f=1:length(frames)
        frame = frames(f);
        t = times(frame);
        plot(lineX, t*lineY, '--', 'Color',[0.4,0.4,0.4], 'LineWidth', 0.5);
    end
% ----------------------------- Plot velocity --------------------------- %
    vAx = subplot('Position', positionV);
    V = -CCData.Orig.VxSmooth((CCData.lastMagnetFrame + 1):end);
    plot(V,times(startInd:end),'LineWidth',2);
    vAx.FontSize = 8;
    vAx.LabelFontSizeMultiplier = 1;
    vAx.TitleFontSizeMultiplier = 1.25;

    vAx.YDir = 'reverse';
    vAx.YTickLabel = {};
%     ax.YTick = [];
    title('Recentering Velocity','FontSize',8);
    xlabel('[{\mu}m/min]','Interpreter','tex');
%     xlabel('[$\frac{{\mu}m}{min}$]','Interpreter','Latex');

%     xlim([-8,8]);
    ylim(yl);
    hold on;
    plot(zeros(2,1), [yl(1), yl(2)],'k--');
    xl = xlim;
    lineX = xl;
    lineY = ones(size(lineX));
    hold on
    for f=1:length(frames)
        frame = frames(f);
        t = times(frame);
        plot(lineX, t*lineY, '--', 'Color',[0.4,0.4,0.4], 'LineWidth', 0.5);
    end
% ----------------------------- Plot frames ----------------------------- %
%     fAx = subplot('Position', positionV);
    Figs(1) = Fig;
    for f = 1:length(frames)
        image = frameImages{f};
        frame= frames(f);
        cropRadius =  CCData.dropRadius(frame)*1.1/CCData.calibration;
        dropCenter = [CCData.Xdroplet(frame), CCData.Ydroplet(frame)];
        maskedImage = circularCrop(image, dropCenter, cropRadius);
        cropRect = [ dropCenter - cropRadius, cropRadius*2, cropRadius*2 ];
        croppedImage = imcrop(maskedImage, cropRect);
        cropOffset = dropCenter - cropRadius;
        aggregateCenter = [CCData.Xaggregate(frame), CCData.Yaggregate(frame)] - cropOffset;
        aggregateRadius = CCData.aggRadius(frame)/CCData.calibration;
        ringRadius = aggregateRadius + CCData.KymographRs;
        Figs(1+f) = figure;
%         imshow(imadjust(croppedImage));
        imSize = size(croppedImage);
%         [X,Y] = meshgrid(-(aggregateCenter(1)-1):(imSize(2)-aggregateCenter(1)),-(aggregateCenter(2)-1):(imSize(1)-aggregateCenter(2)));
%         [Theta,R] = cart2pol(X, Y);
        
        imageWithRing = zeros([imSize,3]);
        imageWithRing(:,:,2) = double(croppedImage)/double(max(croppedImage(:)));
%         pixels = round(R,0) == round(ringRadius(ind),0) | round(R,0) == round(ringRadius(ind+1),0);
%         
%         imageWithRing(pixels) = 1;
        
        sl = stretchlim(imageWithRing(:,:,2));
        
%         imshow(imadjust(imageWithRing,stretchlim(imageWithRing(:,:,2))));
        imshow(imageWithRing);

        viscircles(aggregateCenter, ringRadius(bandNum),'EnhanceVisibility', false, 'LineWidth', 0.5);
        viscircles(aggregateCenter, ringRadius(bandNum + 1),'EnhanceVisibility', false, 'LineWidth', 0.5);

    end
end
