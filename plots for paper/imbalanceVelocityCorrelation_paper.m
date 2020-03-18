function [CCData, Fig] = imbalanceVelocityCorrelation_paper(CCData, images)
    subplot = @(M,N,P) subtightplot(M,N,P,[0.1,0.08],[0.1,0.05],[0.08,0.02]);
    if ~isfield(CCData.Orig,'intensityImbalance') || isempty(CCData.Orig.intensityImbalance)
        ringRadiusWidth = 4;
        ringStart = (2:ringRadiusWidth:20)./CCData.calibration;
        CCData = velocityImbalance(CCData, images, ringRadiusWidth, ringStart);
    end
    CCData.imbalanceVelocityCorr = [];
    V = -CCData.Orig.Vx((CCData.lastMagnetFrame + 1):end);
    Vsmooth = -CCData.Orig.VxSmooth((CCData.lastMagnetFrame + 1):end);

    for i=1:(numel(CCData.KymographRs) - 1)
        imb = CCData.Orig.intensityImbalance(i,(CCData.lastMagnetFrame + 1):end) - mean(CCData.Orig.intensityImbalance(i,(CCData.lastMagnetFrame + 1):end),'omitnan');
        imb(isnan(imb)) = 0;
        [CCData.Orig.imbalanceVelocityCorr(i,:), lags(i,:)] = xcorr(Vsmooth - mean(Vsmooth), imb,'unbiased');
    end
    CCData.imbalanceVelocityLags = lags;
    Fig = figure('Position',[200,200,500,400]);

    % ----------------------------------------------- %
    ax = subplot(2,2,1);
    plot(CCData.times((CCData.lastMagnetFrame + 1):end)/60, CCData.Orig.intensityImbalance(:,(CCData.lastMagnetFrame + 1):end));
%     xlabel('Time [min]');
%     for c = 1:size(CCData.Orig.imbalanceVelocityCorr,1)
%         r1 = CCData.KymographRs(c) * CCData.calibration;
%         r2 = CCData.KymographRs(c+1) * CCData.calibration;
%         legendText{c} = sprintf('%.0f - %.0f {\\mu}m from the aggregate', r1, r2);
%     end
%     legend(legendText);
    axis tight
    ax.FontSize = 8;
    ax.LabelFontSizeMultiplier = 1;
    ax.TitleFontSizeMultiplier = 1.25;
    title('Network intensity imbalance','FontSize', 8);
    ylabel('[a.u]','FontSize', 8);
    
    % ----------------------------------------------- %
    ax = subplot(2,2,3);
    plot(CCData.times((CCData.lastMagnetFrame + 1):end)/60, Vsmooth, 'k', 'LineWidth', 2);
    ax.YTick = [0,4,8];
    ax.FontSize = 8;
    ax.LabelFontSizeMultiplier = 1;
    ax.TitleFontSizeMultiplier = 1.25;
    xlabel('Time [min]','FontSize', 8);
    ylabel('V [{\mu}/sec]','FontSize', 8);
%     ylabel('V [$\frac{\mu}{sec}$]', 'Interpreter','latex','FontSize', 8);
    axis tight
    title('Recentering velocity','FontSize', 8);
    % ----------------------------------------------- %
    ax = subplot(2,2,2);
    frame = 120;

    image = images{frame};
    cropRadius =  CCData.dropRadius(frame)*1.1/CCData.calibration;
    dropCenter = [CCData.Xdroplet(frame), CCData.Ydroplet(frame)];
    maskedImage = circularCrop(image, dropCenter, cropRadius);
    cropRect = [ dropCenter - cropRadius, cropRadius*2, cropRadius*2 ];
    croppedImage = imcrop(maskedImage, cropRect);
    cropOffset = dropCenter - cropRadius;
    aggregateCenter = [CCData.Xaggregate(frame), CCData.Yaggregate(frame)] - cropOffset;
    aggregateRadius = CCData.aggRadius(frame)/CCData.calibration;
    ringRadius = aggregateRadius + CCData.KymographRs;
    %         imSize = size(croppendImage);
    %         [X,Y] = meshgrid(-(aggregateCenter(1)-1):(imSize(2)-aggregateCenter(1)),-(aggregateCenter(2)-1):(imSize(1)-aggregateCenter(2)));
    %         [Theta,R] = cart2pol(X, Y);
    
    %         imageWithRing = zeros([imSize,3]);
    %         imageWithRing(:,:,2) = double(croppendImage)/double(max(croppendImage(:)));
    %         pixels = round(R,0) == round(ringRadius(ind),0) | round(R,0) == round(ringRadius(ind+1),0);
    %
    %         imageWithRing(pixels) = 1;
    %         Figs(1+f) = figure;
    hImage = imshow(imadjust(croppedImage));
    Pixels_Per_Point = (get(0,'ScreenPixelsPerInch')/72);
    S = size(croppedImage);
    ax.Units = 'pixels';
    pixelsScaling = ax.Position(4)/S(1);
    width = (CCData.KymographRs(2) - CCData.KymographRs(1)) * pixelsScaling/Pixels_Per_Point;
    colors = ax.ColorOrder;
    for c = 1:size(CCData.Orig.imbalanceVelocityCorr,1)
        col = colors(c,:);
        viscircles(aggregateCenter, mean(ringRadius(c:(c+1))), 'EnhanceVisibility', false, 'LineWidth', width, 'color', col);
    end
    hold on
    upperImage = imshow(imadjust(croppedImage));
    alpha(upperImage,0.3);
    
        % ----------------------------------------------- %
    ax = subplot(2,2,4);
    lagsLim = floor(size(CCData.imbalanceVelocityLags,2)/4);
    lagsCen = ceil(size(CCData.imbalanceVelocityLags,2)/2);
    lagInds = (-lagsLim:lagsLim) + lagsCen;
    [~, maxCorreletionLagsInds] = max(CCData.Orig.imbalanceVelocityCorr(:,lagInds)');
    inds = sub2ind(size(lags), 1:length(maxCorreletionLagsInds), lagInds(maxCorreletionLagsInds));
    maxCorrLags = lags(inds);
    scatter((CCData.KymographRs(2:end) + CCData.KymographRs(1:end-1))/2, maxCorrLags, 500, colors(1:length(maxCorreletionLagsInds),:), '.');
    xlabel('Distance from aggregate [{\mu}m]','FontSize', 8);
    ylabel('Correlation timelag [sec]','FontSize', 8);
    ax.FontSize = 8;
    ax.LabelFontSizeMultiplier = 1;
    ax.TitleFontSizeMultiplier = 1.25;

    title('Velocity - Imbalance cross-correlation','FontSize', 8);

%     plot(CCData.imbalanceVelocityLags(:,lagInds)'/60, CCData.Orig.imbalanceVelocityCorr(:,lagInds)');
%     xlabel('Time Difference [min]');
%     for c = 1:size(CCData.Orig.imbalanceVelocityCorr,1)
%         [~, maxC] = max(CCData.Orig.imbalanceVelocityCorr(c,lagInds));
%         lMax = lags(c,lagInds(maxC));
%         legendText{c} = sprintf('max correlation: %d seconds', lMax);
%     end
%     legend(legendText);
%     title('Aggregate velocity - Network imbalance cross-correlation');

end
