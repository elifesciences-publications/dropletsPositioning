function [corr_vec,p] = correlation_test3(drops,plane,step)
if ~exist('step','var')
    step = 1;
end
SE = strel('ball',20,20,0);
corr_vec = zeros(2,(numel(drops)));
d0 = 1;
for t=1:(numel(drops))
    r = drops(t).getRadius('pixels');
    dx = round(r*0.8/sqrt(2));
    for i = 1:5
        Roi1 = getRoi(drops(d0),plane,dx);
        Roi2 = getRoi(drops(t),i,dx);
        R1F = imtophat(Roi1,SE);
        R2F = imtophat(Roi2,SE);
        [output{i}, Greg] = dftregistration(fft2(R1F),fft2(R2F),10);
        fGreg = fft2(Greg);
        crr{i} = xcorr2(R1F,fGreg)/mean(fGreg(:));
    end
    M = cellfun(@(x) max(x(:)),crr);
    [~,ind] = max(M);
    
    corr_vec(:,t) = corr_vec(:,d0) + output{ind}([3,4])';
    p(t) = ind;
    
    if ~mod(t - 1,step)
        d0 = t;
%         plane = ind;
    end
end
corr_vec = corr_vec*drops(1).micronsPerPixel;
