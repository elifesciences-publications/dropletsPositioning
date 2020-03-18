function [translation, theta,plane] = rotation_translation_correlation(z_drop, t_drop, around_plane,delta_planes)
r = z_drop.getRadius('pixels');
dx = round(r*0.8/sqrt(2));
im1 = getRoi2(t_drop.images{1}, dx, t_drop.center);
[maskr,maskc]=meshgrid(hann(size(im1,1)),hann(size(im1,2)));
window=maskr.*maskc;
masked_im1 = (im1 - mean(im1(:))).*window;
Fim1 = abs(fftshift(fft2(masked_im1)));

blob0_center = z_drop.getBlobCenter - dx;
% blob0_center = [142,129];
blob0_r = z_drop.getRadius('pixels') * z_drop.blobRfactor;
% blob0_r = 66;

polarIm1 = ImToPolar2(Fim1,0.04,0.5,300,900);
z_planes = max(1,around_plane - delta_planes):min(z_drop.numOfPlanes,around_plane + delta_planes);
C = cell(1,length(z_planes));
for p_ind = 1:length(z_planes)
    p = z_planes(p_ind)
    im0 = getRoi2(z_drop.images{p},dx,z_drop.center);
    masked_im0 = circularCrop2(im0,blob0_center,blob0_r);
    Fim0 = abs(fftshift(fft2(masked_im0)));
    polarIm0 = ImToPolar2(Fim0,0.04,0.5,300,900);
    C{p_ind} =xcorr2(polarIm0 - mean(polarIm0(:)),polarIm1 - mean(polarIm1(:)));
    [~,I(p_ind)] = max(C{p_ind}(:));
    [pks(p_ind),locs(p_ind),w(p_ind),~] = findCorrPeak(C{p_ind});
%     [ij,ji] = ind2sub(size(C),I);
end
% [pks,locs,w,p] = cellfun(@findCorrPeak, C);
[~,plane_ind] = max(pks./w);
plane = z_planes(plane_ind);
[ij,ji] = ind2sub(size(C{plane_ind}),I(plane_ind));
theta = (ji-900)/ 900 * 360;
im0 = getRoi2(z_drop.images{plane},dx,z_drop.center);
masked_im0 = circularCrop2(im0,blob0_center,blob0_r);
rot_masked_Im0 = rotateAround(masked_im0,blob0_center(2),blob0_center(1),theta,'bicubic');
product = (fft2(masked_im1)) .* conj(fft2(ifftshift(rot_masked_Im0)));
correlation = real(ifft2(product));
[~,It] = max(correlation(:));
[ijt,jit] = ind2sub(size(correlation),It);
translation = size(im1)/2 - [jit,ijt];
end
% figure; imshow(rotIm0);
% figure; surf(C), shading flat;

% % figure; imshow(im0);
% % figure; imshow(im1);
% % figure; imshow(masked_im0);
% % figure; imshow(masked_im1);
% % figure; imagesc(Fim0);
% % figure; imagesc(Fim1);
% figure; imagesc(polarIm0);
% figure; imagesc(polarIm1);
