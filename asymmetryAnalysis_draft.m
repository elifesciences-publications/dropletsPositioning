function [sumDiff, avgDiff] = asymmetryAnalysis_draft(CCData, images)
    if iscell(images{1})
        imageSize = flip(size(images{1}{1}));
    else
        imageSize = flip(size(images{1}));
    end
    plane = 1;
    for frame=1:length(CCData.Xdroplet)
        if iscell(images{1})
            image = images{frame}{plane};
        else
            image = images{plane,frame};
        end
        cropRadius =  CCData.dropRadius(frame)*1.1/CCData.calibration;
        dropCenter = [CCData.Xdroplet(frame), CCData.Ydroplet(frame)];
        maskedImage = circularCrop(image, dropCenter, cropRadius);
        %         cropOffset = dropCenter - cropRadius;
        aggregateCenter = [CCData.Xaggregate(frame), CCData.Yaggregate(frame)];% - cropOffset;
        aggregateRadius = CCData.aggRadius(frame)/CCData.calibration;
        aggregateVerticalSpan = 1:imageSize(2);%round(aggregateCenter(2) + [-aggregateRadius : aggregateRadius]);
        aggregateHorizontalBounds = round(aggregateCenter(1) + [-aggregateRadius : aggregateRadius]);
        leftHalfImage = maskedImage(aggregateVerticalSpan,1:aggregateHorizontalBounds(1));
        rightHalfImage = maskedImage(aggregateVerticalSpan,aggregateHorizontalBounds(2):end);
        %         Fig =figure; imshow(imadjust(image));
        %         figure; imshow(maskedImage);
        %         figure; imshow(leftHalfImage);
        %         figure; imshow(rightHalfImage);
        sumLeft = sum(leftHalfImage(:));
        sumRight = sum(rightHalfImage(:));
        
        areaLeft = sum(leftHalfImage(:) > 0);
        areaRight = sum(rightHalfImage(:) > 0);
        
        avgLeft = sumLeft/areaLeft;
        avgRight = sumRight/areaRight;
        
        sumDiff(frame) = sumLeft - sumRight;
        avgDiff(frame) = avgLeft - avgRight;
    end
end
