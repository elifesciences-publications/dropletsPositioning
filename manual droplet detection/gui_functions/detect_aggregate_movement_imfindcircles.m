function [position, M] = detect_aggregate_movement_imfindcircles(image, in_position, scanRange)
    cropRect = max(0, in_position + [-scanRange, -scanRange, 2*scanRange, 2*scanRange]);
    I = imcrop(image, cropRect);
    [centers,radii,metric] = imfindcircles(I,round(([in_position(3) - scanRange*2, in_position(3) + scanRange*2])/2), 'ObjectPolarity','dark', 'EdgeThreshold',0.01)
    if isempty(metric)
        M = 0;
        position = in_position;
    else
        [M,ind] = max(metric);
        R = radii(ind);
        C = centers(ind,:) + cropRect(1:2);
        position = [C - [R R], 2*[R R]];
    end
end