function corr_vec = correlation_test(drops,step,plane)
if ~exist('plane','var')
    plane = 1;
end
if ~exist('step','var')
    step = 1;
end
corr_vec = zeros(2,(numel(drops) - step + 1));
for t=0:(numel(drops) - step)
%     r = drops(t).getRadius('pixels');
%     dx = round(r*0.8/sqrt(2));
%     Roi1 = getRoi(drops(t),plane,dx);
%     Roi2 = getRoi(drops(t+step),plane,dx);
%     [output, ~] = dftregistration3(fft2(Roi1),fft2(Roi2),10);
%     corr_vec(:,t) = corr_vec(:,max(1,t-1)) + (output(3:5)')/step;
    [output, ~] = dropCorr(drops(max(t,1)),drops(t+step),plane);
    corr_vec(:,t) = corr_vec(:,max(1,t-1)) + (output')/step;
%     corr_vec(:,t) = (output')/step;
end
corr_vec = corr_vec*drops(1).micronsPerPixel;
% i=100;
% c0 = control1.DATA.drops(1).blobCenters(1,:);
% c = -(corr_vec_xcorr3(1:2,i-1)'/control1.DATA.drops(1).micronsPerPixel) + c0
% figure;
% imshow(control1.DATA.drops(i).images{2})
% hold on
% scatter(c(1),c(2))

% 
% figure; plot(crr(:));
% [ssr,snd] = max(crr(:));
% [ij,ji] = ind2sub(size(crr),snd)