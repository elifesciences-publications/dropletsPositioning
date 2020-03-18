function [position, M] = detect_aggregate_movement(cropped_image, in_position, scanRange, origSize)
    S = size(cropped_image);
    if numel(S) > 2
        cropped_image = cropped_image(:,:,1);
    end
    % in_center = in_position(1:2) + in_position(3:4)/2;
    img = double(cropped_image)./double(max(cropped_image(:)));
    [X,Y] = meshgrid(1:S(2),1:S(1));
    cur_pos = in_position;
    scanSample = [scanRange; scanRange/2; scanRange/4; scanRange/8];
    
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
        circleMeasure = zeros(numel(scanX), numel(scanX), numel(scanY), numel(scanY));
        for ixl = 1:length(scanX)
            for ixr = 1:length(scanX)
                for iyt = 1:length(scanY)
                    for iyb = 1:length(scanY)
                        scan_pos = cur_pos + [scanX(ixl), scanY(iyb), scanX(ixr), scanY(iyt)];
%                         if abs(scan_pos(3) - in_position(3)) > 1 || abs(scan_pos(4) - in_position(4)) > 1
%                             break;
%                         end
                        if scan_pos(3) < origSize(1)*0.9
                            break;
                        end
                        if scan_pos(3) > origSize(1)*1.1
                            break;
                        end
                        if scan_pos(4) < origSize(2)*0.9
                            break;
                        end
                        if scan_pos(4) > origSize(2)*1.1
                            break;
                        end
%                         if scan_pos(3) < scan_pos(4)*0.95
%                             break;
%                         end
%                         if scan_pos(3) > scan_pos(4)*1.05
%                             break;
%                         end
%                         if scan_pos(3)/cur_pos(3) < 0.99
%                             break;
%                         end
%                         if scan_pos(3)/cur_pos(3) > 1.01
%                             break;
%                         end

                        R = ellipseR(scan_pos, X, Y);
%                     inds = find(abs(R - scan_pos(3)) < 2);
                        circleMeasure(ixl,ixr,iyt,iyb) = mean(img(abs(R - scan_pos(3)/2) < 2));
                    end
                end
            end
        end
        [~,I] = max(circleMeasure(:));
        [Ixl, Ixr, Iyt, Iyb] = ind2sub(size(circleMeasure),I);
        cur_pos = cur_pos + [scanX(Ixl), scanY(Iyb), scanX(Ixr), scanY(Iyt)];
        % Measure ellipse circumference average area average:
        R = ellipseR(cur_pos, X,Y);
%         M = mean(img(abs(R - cur_pos(3)/2) < 2)) / mean(img(R - cur_pos(3)/2 < 0)) - 1;
         M = mean(img(abs(R - cur_pos(3)/2) < 1)) / mean(img(abs(R - cur_pos(3)/2) < 3)) - 1;

% 
%         if repetition == 2
%             [fxl, fxr, fxt, fxb] = gradient(circleMeasure);
%             G = sqrt(fxl.^2 + fxr.^2 + fxt.^2 + fxb.^2);
%             M = G(I);
%         end
    end
    position = cur_pos;
end

function R = ellipseR(scan_pos, X, Y)
    scan_cen = scan_pos(1:2) + scan_pos(3:4)/2;
    xsqrd = (X - scan_cen(1)).^2;
    ysqrd = (Y - scan_cen(2)).^2;
    R = sqrt(xsqrd + ysqrd * (scan_pos(3)/scan_pos(4))^2);
end
