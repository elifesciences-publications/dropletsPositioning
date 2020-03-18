function drops = extract_drops_oop_c(image_stack, PAR, Rrange, micronsPerPixel,nodetect,nofindcenter)
% EXTRACT_DROPS extract drop images and info from image_stack
%
% Input: PAR structure with fields:
%	PAR.DIRNAME - Name of the directory containing tiff images.
%	PAR.NAME - Suffix to output and input files.
%	PAR.SCALEFACTOR - Scaling of saved images with respect to original.
%	PAR.PADDING - extra padding to save around drop images.
%
% Output: drops - structure array of drops with images and extracted data.
% 
% see also read_par, auto_wrapper
if nargin < 4 || isempty(micronsPerPixel)
    micronsPerPixel = -1;
end
if nargin < 3 || isempty(Rrange)
    Rrange = -1;
end
if isfield(PAR,'PADDING')
    PADDING = PAR.PADDING;
else
    PADDING = 30;
end
[planesPerPixel, micronsPerPixel, micronsPerPlane] = pixelCal(PAR, micronsPerPixel);
    % if drops circle_data.mat not found, search for drops in montage
    % takes a *LONG* time, better run on aluf
[centers, radii, metrics] = find_drops_c(image_stack, micronsPerPixel, Rrange);

% seperate drops from montage and find center plains and blobs
drops = seperate_drops_oop(image_stack, centers, radii, metrics,PADDING);
if isempty(drops)
    return
end
clear image_stack
[drops.planesPerPixel] = deal(planesPerPixel);
[drops.micronsPerPixel] = deal(micronsPerPixel);
[drops.micronsPerPlane] = deal(micronsPerPlane);

clear centerPlains;
for D=1:length(drops)
    if ~exist('nofindcenter','var') || ~strcmp(nofindcenter,'nofindcenter')
        drops(D).findCenterPlane();
    end
    if ~exist('nodetect','var') || ~strcmp(nodetect,'nodetect')
		drops(D).detectBlob2();
    end
end
end
