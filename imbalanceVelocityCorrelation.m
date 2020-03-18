function [CCData, Fig] = imbalanceVelocityCorrelation(CCData, images)
    if ~isfield(CCData.Orig,'intensityImbalance') || isempty(CCData.Orig.intensityImbalance)
            CCData = velocityImbalance(CCData, images);
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
    Fig = figure('Position',[200,200,900,600]);

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
    title('Network intensity imbalance');
    axis tight
    ax.FontSize = 15;
    ylabel('[a.u]');
    
    % ----------------------------------------------- %
    ax = subplot(2,2,3);
    plot(CCData.times((CCData.lastMagnetFrame + 1):end)/60, Vsmooth, 'k', 'LineWidth', 2);
    xlabel('Time [min]');
    ylabel('V [$\frac{\mu}{sec}$]', 'Interpreter','latex');
    title('Recentering velocity');
    axis tight
    ax.FontSize = 15;
    
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
    imshow(imadjust(croppedImage));
    colors = ax.ColorOrder;
    for c = 1:size(CCData.Orig.imbalanceVelocityCorr,1)
        col = colors(c,:);
        viscircles(aggregateCenter, mean(ringRadius(c:(c+1))), 'EnhanceVisibility', false, 'LineWidth', 4, 'color', col);
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
    xlabel('Distance from aggregate [{\mu}m]');
    ylabel({'Correlation timelag', '[sec]'});
    title('Velocity - Imbalance cross-correlation');
    ax.FontSize = 15;

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
