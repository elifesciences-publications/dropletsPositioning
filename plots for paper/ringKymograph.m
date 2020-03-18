function [circularKymograph, theta] = ringKymograph(CCData, images, ringStartFactor ,ringRadiusFactor, factorType, plotFrames)
    if iscell(images{1})
        imageSize = flip(size(images{1}{1}));
    else
        imageSize = flip(size(images{1}));
    end
    if ~exist('factorType', 'var') || ~ischar(factorType)
        factorType = 'multiplicative';
    end
    plane = 1;
    
    angularResolution = pi/18; %10 deg resolution;
    t = 0:angularResolution:(2*pi);
    theta = t(1:end-1);
    
    for frame=1:length(CCData.Xdroplet)
        if iscell(images{1})
            image = images{frame}{plane};
        else
            image = images{plane,frame};
        end
        cropRadius =  CCData.dropRadius(frame)*1.1/CCData.calibration;
        dropCenter = [CCData.Xdroplet(frame), CCData.Ydroplet(frame)];
        maskedImage = circularCrop(image, dropCenter, cropRadius);
        cropRect = [ dropCenter - cropRadius, cropRadius*2, cropRadius*2 ];
        croppendImage = imcrop(maskedImage, cropRect);
        cropOffset = dropCenter - cropRadius;
        aggregateCenter = [CCData.Xaggregate(frame), CCData.Yaggregate(frame)] - cropOffset;
        aggregateRadius = CCData.aggRadius(frame)/CCData.calibration;
        if strcmp(factorType, 'multiplicative');
            ringStart = aggregateRadius*ringStartFactor;
            ringRadius = aggregateRadius*ringRadiusFactor;
        elseif strcmp(factorType, 'additive');
            ringStart = aggregateRadius + ringStartFactor;
            ringRadius = ringRadiusFactor;
        else 
            error('unknown factorType');
        end
        if ismember(frame, plotFrames)
            doPlot = true;
        else
            doPlot = false;
        end
        circularKymograph(frame,:) = ringIntensity(croppendImage, aggregateCenter, ringStart, ringRadius, theta, doPlot);
    end
    theta = theta + angularResolution/2;
end