A = ones(200) * 2;
B = ones(200) * 2;

A = circularMask(A,[50,50],10);
A(A==0) = 1;
A(A==2) = 0;
% A = circularCrop(A,[100,100],90);
A = A - mean(A(:));
B = circularMask(B,[150,80],10);
B(B==0) = 1;
% B = circularCrop(B,[100,100],90);
B(B==2) = 0;
B = B - mean(B(:));

figure; imshow(A);
figure; imshow(B);
crr = xcorr2(A,B);
[output, Greg] = dftregistration(fft2(A./mean(A(:))),fft2(B./mean(B(:))));
output([3,4])
figure, surf(crr), shading flat;
figure, plot(crr(:));

[ssr,snd] = max(crr(:));
[ij,ji] = ind2sub(size(crr),snd);
xvec = ij:-1:ij-size(A,1)+1;
yvec = ji:-1:ji-size(B,2)+1;
px = max([0, 1 - xvec(end)]);
py = max([0, 1 - yvec(end)]);
xvec = xvec + px;
yvec = yvec + py;
comb = zeros(size(A) + [px,py]);
comb(px+1:px+size(A,1) , py+1:py+size(A,2)) = A;
comb(xvec,yvec) = (comb(xvec,yvec) + rot90(B,2)) / 2;
figure;imshow(comb);
