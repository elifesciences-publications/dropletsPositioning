function Figs = plotCircularKymograph(CCData, ind, frameImages, frames)
    % Integrate Kymograph with angular factor to calculate asymmetry
%    imbalance = -sin(theta) * circularKymograph' * 1e-5;
% ----------------------------- Figure ---------------------------------- %
    figureSize = [900, 600];
    positionKym = [0.07, 0.11, 0.37, 0.84];
    positionImbalance = [0.49, 0.11, 0.22, 0.84];
    positionV = [0.76, 0.11, 0.22, 0.84];
    
% ----------------------------- Plot kymograph -------------------------- %
    Fig = figure('Position', [300,100,figureSize]);
    set(Fig,'defaulttextinterpreter','latex')
    KymAx = subplot('Position', positionKym);
    times = CCData.times/60;
    yl = [times(1), times(end)];
    imagesc(CCData.KymographTheta, yl, CCData.Kymograph(:,:,ind));%, [0, intmax(class(image))]);
    KymAx.XTick = [0, 0.5*pi, pi, 1.5*pi, 2*pi];
    KymAx.XTickLabel = {'0','$\frac{1}{2}\pi$', '$\pi$', '$\frac{3}{2}\pi$', '$2\pi$'};
    KymAx.TickLabelInterpreter='latex';
    KymAx.FontSize = 15;
%     ax.YAxisLocation = 'right';
    ylabel('Time [min]');
    xlabel('Angle (Counteclockwize from top)');
    title('Intensity Kymograph');
%     c = colorbar('westoutside');
%     c.Label.String = 'Intensity';
    lineX = 0:0.1:(2*pi);
    lineY = ones(size(lineX));
    hold on
    for f=1:length(frames)
        frame = frames(f);
        t = times(frame);
        plot(lineX, t*lineY, '--k', 'LineWidth', 2);
    end

% ----------------------------- Plot imbalance -------------------------- %
    imbalanceAx = subplot('Position', positionImbalance);
    plot(CCData.Orig.intensityImbalance(ind,:), times);
    imbalanceAx.YDir = 'reverse';
    imbalanceAx.YTickLabel = {};
    ylim(yl);
    title('Intensity Imbalance');
    xlabel('[A.U.]');
    imbalanceAx.FontSize = 15;
    xlim([-0.5,1.5]);
    xl = xlim;
    lineX = xl;
    lineY = ones(size(lineX));
    hold on
    for f=1:length(frames)
        frame = frames(f);
        t = times(frame);
        plot(lineX, t*lineY, '--k', 'LineWidth', 2);
    end
% ----------------------------- Plot velocity --------------------------- %
    vAx = subplot('Position', positionV);
    V = -CCData.Orig.VxSmooth((CCData.lastMagnetFrame + 1):end);
    plot(V,times(CCData.lastMagnetFrame + 1:end),'LineWidth',2);
    vAx.YDir = 'reverse';
    vAx.YTickLabel = {};
%     ax.YTick = [];
    title('Recentering Velocity');
    xlabel('[$\frac{{\mu}m}{min}$]','Interpreter','Latex');
%     xlim([-8,8]);
    ylim(yl);
    hold on;
    plot(zeros(2,1), [yl(1), yl(2)],'k--');
    vAx.FontSize = 15;
    xl = xlim;
    lineX = xl;
    lineY = ones(size(lineX));
    hold on
    for f=1:length(frames)
        frame = frames(f);
        t = times(frame);
        plot(lineX, t*lineY, '--k', 'LineWidth', 2);
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
        
        imshow(imadjust(imageWithRing,stretchlim(imageWithRing(:,:,2))));
        
        viscircles(aggregateCenter, ringRadius(ind),'EnhanceVisibility', false, 'LineWidth', 0.5);
        viscircles(aggregateCenter, ringRadius(ind + 1),'EnhanceVisibility', false, 'LineWidth', 0.5);

    end
end
