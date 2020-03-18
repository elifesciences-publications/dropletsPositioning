function position = detect_droplet_movement(cropped_image, in_position, scanRange)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
S = size(cropped_image);
if numel(S) > 2
    cropped_image = cropped_image(:,:,1);
end
img = double(cropped_image)./double(max(cropped_image(:)));
[X,Y] = meshgrid(1:S(2),1:S(1));
cur_pos = in_position;
scanSample = [scanRange; scanRange/2; scanRange/4; scanRange/8; scanRange/16];
for repetition = 1:(length(scanSample) - 1)
    sampleD = scanSample(repetition+1,:);
    cur_Range = ceil(scanSample(repetition,:));
    scanX = -cur_Range(1):sampleD(1):cur_Range(1);
    scanY = -cur_Range(2):sampleD(2):cur_Range(2);
    
    circleMeasure = zeros(numel(scanX), numel(scanY));
    for ix = 1:length(scanX)
        for iy = 1:length(scanY)
            scan_pos = cur_pos + [scanX(ix), scanY(iy), 0, 0];
            scan_cen = scan_pos(1:2) + scan_pos(3:4)/2;
            xsqrd = (X - scan_cen(1)).^2;
            ysqrd = (Y - scan_cen(2)).^2;
            R = sqrt(xsqrd + ysqrd * (scan_pos(3)/scan_pos(4))^2);
            circleMeasure(ix,iy) = sum(img(R - scan_pos(3)/2 < 0));%/sum(R(:) - scan_pos(3)/2 < 0);
        end
    end
    [~,I] = max(circleMeasure(:));
    [Ix, Iy] = ind2sub(size(circleMeasure),I);
    cur_pos = cur_pos + [scanX(Ix), scanY(Iy), 0, 0];
end
position = cur_pos;


end

