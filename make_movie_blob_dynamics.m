function make_movie_blob_dynamics(dyn,dropScale)
DIR = fileparts(dyn.filename{1});
movieDIR = fullfile(DIR,'movie');
if ~exist(movieDIR,'dir')
    mkdir(DIR,'movie');
end

scale = 1;
relScale = dropScale/scale;
micronsPerPixel = dyn.DATA.drops(1).micronsPerPixel * relScale;
% micronsPerPixel = 0.0973 / scale;
Lmu = max(dyn.DATA.drops.getRadius)*2 + 10;
for i=1:numel(dyn.DATA.drops)
    drop = dyn.DATA.drops(i);
    plane = min(max(1,drop.centerPlane),drop.numOfPlanes);
    [ ~, image ] = load_tiff_file_num_plane( DIR , scale, i, plane, '*_C0.tiff');
    RGB = miniImage2(image,drop,micronsPerPixel,relScale,Lmu,2);
     if i == 1
         S = size(RGB);
         S = S(1:2);
     else
         RGB = imresize(RGB,S);
     end
%     image = repmat(image,1,1,3);
%     d = dyn.BV(i).blobRThetaPhiNormalized(1);
%     color = [d,1 - d,0]*2/3;
%     c = drop.getBlobCenter * scale;
%     r =  drop.getRadius('pixels')*drop.blobRfactor * scale;
%     rs = r:r+1;
%     y = round(min(max(c(1) + rs'*sin(0:0.01:(2*pi)),1),size(image,1)));
%     x = round(min(max(c(2) + rs'*cos(0:0.01:(2*pi)),1),size(image,2)));
%     indsR = sub2ind(size(image),x,y,ones(size(x)));
%     indsG = sub2ind(size(image),x,y,2*ones(size(x)));
%     indsB = sub2ind(size(image),x,y,3*ones(size(x)));
%     image(indsR) = color(1);
%     image(indsG) = color(2);
%     image(indsB) = color(3);
    imwrite(RGB,fullfile(movieDIR,sprintf('frame_%d.png',i)));
end


