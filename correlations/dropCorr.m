function [output, crr] = dropCorr(drop1,drop2,plane,type,show)
    if numel(plane) == 1
        plane(2) = plane(1);
    end
    
    r1 = drop1.getRadius('pixels');
    dx1 = round(r1*0.8/sqrt(2));
    Roi1 = getRoi(drop1,plane(1),dx1);
%     r2 = drop2.getRadius('pixels');
%     dx2 = round(r1*0.8/sqrt(2));
    Roi2 = getRoi(drop2,plane(2),dx1);
    if ~exist('type','var')
        type = 3;
    end
    switch type
        case 1
            crr = xcorr2(Roi1,Roi2)/mean(Roi2(:));
        case 2
            crr = xcorr2(Roi1 - mean(Roi1(:)),Roi2 - mean(Roi2(:)));
        case 3
            SE = strel('ball',50,10,0);
            R1F = imtophat(Roi1,SE);
            R2F = imtophat(Roi2,SE);
            crr = xcorr2(R1F,R2F)/mean(R2F(:));
        case 4
            SE = strel('ball',50,10,0);
            R1F = imtophat(Roi1,SE);
            R2F = imtophat(Roi2,SE);
            crr = xcorr2(R1F - mean(R1F(:)),R2F - mean(R2F(:)));
        case 5
            SE = strel('ball',50,10,0);
            R1F = imtophat(Roi1,SE);
            R2F = imtophat(Roi2,SE);
            crr = xcorr2(R1F - mean(R1F(:)),R2F - mean(R2F(:)));
            [out,~] = dftregistration(fft2(R1F),fft2(R2F),10);
            output = out([3,4]);
            return
    end
%     crr = xcorr2(R1F,R2F)/mean(R2F(:));
%     crr = xcorr2(R1F,R2F)/mean(R2F(:));
%     crr = xcorr2(Roi1,Roi2)/mean(Roi2(:));

%     crr = normxcorr2(R1F,R2F);
%     crr = normxcorr2_general(R1F,R2F);

%     crr = convn(Roi1,Roi2(end:-1:1,end:-1:1,end:-1:1));
% 
%     figure; imshow(getRoi(drop2,plane,1.1));
    
    [ssr,snd] = max(crr(:));
    [ij,ji] = ind2sub(size(crr),snd);
    if exist('show','var') && strcmp(show,'show')
        figure; imshow(Roi1);
        figure; imshow(Roi2);
%         comb = Roi1;
        xvec = ij:-1:ij-size(Roi2,1)+1;
        yvec = ji:-1:ji-size(Roi2,2)+1;
        px = max([0, 1 - xvec(end)]);
        py = max([0, 1 - yvec(end)]);
        xvec = xvec + px;
        yvec = yvec + py;
        comb = zeros(size(Roi1) + [px,py]);
        comb(px+1:px+size(Roi1,1) , py+1:py+size(Roi1,2)) = Roi1;
        comb(xvec,yvec) = rot90(Roi2,2);
        figure;imshow(comb);
    end
    output = [ij,ji] - size(Roi2)/2 - size(Roi1)/2;
end
