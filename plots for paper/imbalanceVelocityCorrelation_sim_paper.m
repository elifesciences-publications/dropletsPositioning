% function [CCData, Fig] = imbalanceVelocityCorrelation_paper(filename)
% filename = 'C:\Users\Nivieru\Documents\MATLAB\emulsions_code\plots for paper\from Alex\KerenLab_SimulationResults\Data\dynAgg_radDrop=50';
% filename = 'C:\Users\Nivieru\Documents\MATLAB\emulsions_code\plots for paper\from Alex\KerenLab_SimulationResults\Data\fullResults\dynAgg_radDrop=60_pushed_full';
filename = 'C:\Users\Nivieru\Documents\MATLAB\emulsions_code\plots for paper\from Alex\KerenLab_SimulationResults\Data\fullResults\dynAgg_radDrop=50_pushed_fine.mat';
load(filename);
dropRadius = round(vAggPos(1)/0.7);
% Trim initial time
% startInd = 1;
% allResults = allResults(startInd:end);
% vAggPos = vAggPos(startInd:end);
% vAggSpeed = vAggSpeed(startInd:end); 
% vTime = vTime(startInd:end);
% -------------------%
givenDensData = [allResults.givenDensData];
dens = {givenDensData.dens};
simDensity = cellfun(@(x) flip(x*5e3,2), dens,'UniformOutput', false);
CCDataSim.Xdroplet = round(ones(size(vAggPos)) * size(simDensity{1},1)/2 +1);
CCDataSim.Ydroplet = round(ones(size(vAggPos)) * size(simDensity{1},2)/2 +1);
CCDataSim.calibration = allResults(1).givenDensData.X(1,2) - allResults(1).givenDensData.X(1,1);
CCDataSim.Orig = struct;
CCDataSim.dropRadius = dropRadius*ones(size(vAggPos));
CCDataSim.Xaggregate = -vAggPos/CCDataSim.calibration + CCDataSim.Xdroplet;
CCDataSim.Yaggregate = CCDataSim.Ydroplet;
CCDataSim.aggRadius = CCDataSim.dropRadius/10;
CCDataSim.Theta = 0;
CCDataSim.lastMagnetFrame = 0;
CCDataSim.Orig.Vx = vAggSpeed;
CCDataSim.Orig.VxSmooth = vAggSpeed;
CCDataSim.times = vTime*60;

    subplot = @(M,N,P) subtightplot(M,N,P,[0.1,0.08],[0.1,0.05],[0.08,0.02]);
    if ~isfield(CCDataSim.Orig,'intensityImbalance') || isempty(CCDataSim.Orig.intensityImbalance)
        ringRadiusWidth = 4;
        ringStart = (2:ringRadiusWidth:20)./CCDataSim.calibration;
        CCDataSim = velocityImbalance(CCDataSim, simDensity, ringRadiusWidth, ringStart);
    end
    CCDataSim.imbalanceVelocityCorr = [];
    V = -CCDataSim.Orig.Vx((CCDataSim.lastMagnetFrame + 1):end);
    Vsmooth = -CCDataSim.Orig.VxSmooth((CCDataSim.lastMagnetFrame + 1):end);
    for i=1:(numel(CCDataSim.KymographRs) - 1)
        imb = CCDataSim.Orig.intensityImbalance(i,(CCDataSim.lastMagnetFrame + 1):end) - mean(CCDataSim.Orig.intensityImbalance(i,(CCDataSim.lastMagnetFrame + 1):end),'omitnan');
        imb(isnan(imb)) = 0;
        [CCDataSim.Orig.imbalanceVelocityCorr(i,:), lags(i,:)] = xcorr(Vsmooth - mean(Vsmooth), imb,'unbiased');
    end
    CCDataSim.imbalanceVelocityLags = lags;
    Fig = figure('Position',[200,200,500,400]);

    % ----------------------------------------------- %
    ax = subplot(2,2,1);
    plot(CCDataSim.times((CCDataSim.lastMagnetFrame + 1):end)/60, CCDataSim.Orig.intensityImbalance(:,(CCDataSim.lastMagnetFrame + 1):end));
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
    plot(CCDataSim.times((CCDataSim.lastMagnetFrame + 1):end)/60, Vsmooth, 'k', 'LineWidth', 2);
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
    frame = 5;
    image = simDensity{frame};
    cropRadius =  CCDataSim.dropRadius(frame)*1.1/CCDataSim.calibration;
    dropCenter = [CCDataSim.Xdroplet(frame), CCDataSim.Ydroplet(frame)];
    maskedImage = circularCrop(image, dropCenter, cropRadius);
    cropRect = [ dropCenter - cropRadius, cropRadius*2, cropRadius*2 ];
    croppedImage = imcrop(maskedImage, cropRect);
    cropOffset = dropCenter - cropRadius;
    aggregateCenter = [CCDataSim.Xaggregate(frame), CCDataSim.Yaggregate(frame)] - cropOffset;
    aggregateRadius = CCDataSim.aggRadius(frame)/CCDataSim.calibration;
    ringRadius = aggregateRadius + CCDataSim.KymographRs;
    %         imSize = size(croppendImage);
    %         [X,Y] = meshgrid(-(aggregateCenter(1)-1):(imSize(2)-aggregateCenter(1)),-(aggregateCenter(2)-1):(imSize(1)-aggregateCenter(2)));
    %         [Theta,R] = cart2pol(X, Y);
    
    %         imageWithRing = zeros([imSize,3]);
    %         imageWithRing(:,:,2) = double(croppendImage)/double(max(croppendImage(:)));
    %         pixels = round(R,0) == round(ringRadius(ind),0) | round(R,0) == round(ringRadius(ind+1),0);
    %
    %         imageWithRing(pixels) = 1;
    %         Figs(1+f) = figure;
    hImage = imshow(imadjust(croppedImage./max(croppedImage(:))));
    Pixels_Per_Point = (get(0,'ScreenPixelsPerInch')/72);
    S = size(croppedImage);
    ax.Units = 'pixels';
    pixelsScaling = ax.Position(4)/S(1);
    width = (CCDataSim.KymographRs(2) - CCDataSim.KymographRs(1)) * pixelsScaling/Pixels_Per_Point;
    colors = ax.ColorOrder;
    for c = 1:size(CCDataSim.Orig.imbalanceVelocityCorr,1)
        col = colors(mod(c-1,size(ax.ColorOrder,1)) + 1,:);
        viscircles(aggregateCenter, mean(ringRadius(c:(c+1))), 'EnhanceVisibility', false, 'LineWidth', width, 'color', col);
    end
    hold on
    upperImage = imshow(imadjust(croppedImage));
    alpha(upperImage,0.3);
    
        % ----------------------------------------------- %
    ax = subplot(2,2,4);
    lagsLim = floor(size(CCDataSim.imbalanceVelocityLags,2)/4);
    lagsCen = ceil(size(CCDataSim.imbalanceVelocityLags,2)/2);
    lagInds = (-lagsLim:lagsLim) + lagsCen;
    [~, maxCorreletionLagsInds] = max(CCDataSim.Orig.imbalanceVelocityCorr(:,lagInds)');
    inds = sub2ind(size(lags), 1:length(maxCorreletionLagsInds), lagInds(maxCorreletionLagsInds));
    maxCorrLags = lags(inds);
    scatter((CCDataSim.KymographRs(2:end) + CCDataSim.KymographRs(1:end-1))/2, maxCorrLags, 500, colors(mod((1:length(maxCorreletionLagsInds)) - 1,size(ax.ColorOrder,1)) + 1,:), '.');
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

% end
% for i=1:(length(CCDataSim.KymographRs) - 1)

%--- Make Kympgraph sliglty saturated, and with the same range as experiemntal ---%
background_substraction = 1.2e4;
K = CCDataSim.Kymograph(:,:,3);
MaxS = max(K(:));
MinS = min(K(:));
MaxE = 1.7284e4;
% MaxE = max(max(CCData_corr(mov).Kymograph(:,:,3))) - background_substraction;
MinE = 1.8734e3; 
% MinE = min(min(CCData_corr(mov).Kymograph(:,:,3))) - background_substraction;
MaxSnew = MinS*MaxE/MinE;

K(K>MaxSnew) = MaxSnew;
% K = K*MaxE/MaxS;
% K(K<MinE) = MinE;
% % --- ---%
CCDataSim2 = CCDataSim;
CCDataSim2.Kymograph(:,:,3) = K;
YL = [-0.0167, 8.3512]; %YL = KymFigs(1).Children(4).YLim;

KymFig = plotCircularKymograph_paper(CCDataSim2,3, [],[]);
for p=[1,2,4]
    KymFig.Children(p).YLim = YL;
end

KymFig.PaperPositionMode = 'auto';
KymFig.PaperOrientation = 'landscape' ;

%     print(KymFigs(1),[basefilenames{2},' Kymograph.eps'],'-depsc');
if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
    print(KymFig,fullfile(outputDir,'simulation_Kymograph'),format);
end
