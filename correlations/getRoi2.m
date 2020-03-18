function Roi = getRoi2(image, dx, center)
if ~exist('center','var')
    center = size(image)/2;
end
szx = round(max(0,center(1) - dx)):round(min(center(1) + dx,size(image,1)));
szy = round(max(0,center(2) - dx)):round(min(center(2) + dx,size(image,2)));
Roi = image(szx,szy,:);
end
