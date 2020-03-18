function RGB = miniImage(image,drop,micronsPerPixel,relScale,Lmu,thickness)
if ~exist('Lmu','var')
    Lmu = 120;
end
if ~exist('thickness','var')
    thickness = -1;
end
L = Lmu/micronsPerPixel;
xmin = drop.location(2)/relScale - L/2;
ymin = drop.location(1)/relScale - L/2;
xshift = max([1-xmin,0]);
if xshift ==0
    xshift = min([size(image,2) - (xmin + L),0]);
end
yshift = max([1-ymin,0]);
if yshift ==0
    yshift = min([size(image,1) - (ymin + L),0]);
end

BV = blob_vectors(drop);
xmin = xmin + xshift;
ymin = ymin + yshift;
I = im2double(imadjust(imcrop(image,[xmin,ymin,L,L])));

[x,y] = meshgrid((-ceil(L/2):ceil(L/2)) + xshift - BV.blobVec(1)/micronsPerPixel,(-ceil(L/2):ceil(L/2)) + yshift - BV.blobVec(2)/micronsPerPixel);
c_mask = ((x.^2+y.^2) <= (drop.getRadius*0.2537/micronsPerPixel)^2);
if(thickness > 0)
    mask_thickness = ((x.^2+y.^2) >= ((drop.getRadius*0.2537/micronsPerPixel - thickness)^2));
    c_mask = c_mask & mask_thickness;
end
S = size(I);
% if S(1) > S(2)
%     s = S(2);
% else 
%     s = S(1);
% end
% I = I(1:s,1:s);
c_mask = c_mask(1:S(1),1:S(2));
rN = BV.blobRThetaPhiNormalized(1);
color = [rN,1 - rN,0]*2/3;
IR = (I+c_mask*color(1))/2;
IG = (I+c_mask*color(2))/2;
IB = (I+c_mask*color(3))/2;
%     RGB = repmat(I,1,1,3);
%     RGB(:,:,2) = max(I,c_mask*color(2));
RGB = cat(3,IR,IG,IB);
end