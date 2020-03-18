function Roi = getRoi(drop, plane, dx)
c = drop.center;
img = cat(3,drop.images{plane});
szx = round(max(0,c(1) - dx)):round(min(c(1) + dx,size(img,1)));
szy = round(max(0,c(2) - dx)):round(min(c(2) + dx,size(img,2)));
szz = 1:length(plane);
Roi = img(szx,szy,szz);
end
