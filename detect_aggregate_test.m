function position = detect_aggregate_test(cropped_image, in_position, scanRange)
S = size(cropped_image);
if numel(S) > 2
    cropped_image = cropped_image(:,:,1);
end
% in_center = in_position(1:2) + in_position(3:4)/2;
img = double(cropped_image)./double(max(cropped_image(:)));
[X,Y] = meshgrid(1:S(2),1:S(1));
cur_pos = in_position;
scanSample = [scanRange;2*scanRange/4;1,1;0.5,0.5];

for repetition = 1:(length(scanSample) - 1)
    sampleD = scanSample(repetition+1,:);
    cur_Range = ceil(scanSample(repetition,:));
    scanX = -cur_Range(1):sampleD(1):cur_Range(1);
    scanY = -cur_Range(2):sampleD(2):cur_Range(2);

% cur_cen = cur_pos(1:2) + cur_pos(3:4)/2;
% rsX = cur_pos(3)/2 + (-scanRad:scanRad);
% rsY = cur_pos(4)/2 + (-scanRad:scanRad);
% 
% radX = zeros([numel(rsX),numel(rsY)]);
% radY = zeros([numel(rsX),numel(rsY)]);
circleAvg = zeros(numel(scanX), numel(scanX), numel(scanY), numel(scanY));
for ixl = 1:length(scanX)
    for ixr = 1:length(scanX)
        for iyt = 1:length(scanY)
            for iyb = 1:length(scanY)
                scan_pos = cur_pos + [scanX(ixl), scanY(iyb), scanX(ixr), scanY(iyt)];
                scan_cen = scan_pos(1:2) + scan_pos(3:4)/2;
                    xsqrd = (X - scan_cen(1)).^2;
                    ysqrd = (Y - scan_cen(2)).^2;
                    R = sqrt(xsqrd + ysqrd * (scan_pos(3)/scan_pos(4))^2);
%                     inds = find(abs(R - scan_pos(3)) < 2);
                    circleAvg(ixl,ixr,iyt,iyb) = mean(img(abs(R - scan_pos(3)/2) < 2));
            end
        end
    end
end
[~,I] = max(circleAvg(:));
[Ixl, Ixr, Iyt, Iyb] = ind2sub(size(circleAvg),I);
cur_pos = cur_pos + [scanX(Ixl), scanY(Iyb), scanX(Ixr), scanY(Iyt)];
end
position = cur_pos;
