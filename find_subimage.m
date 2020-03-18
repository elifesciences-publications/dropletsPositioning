function [center] = find_subimage(subimage, bigPicture)
correlationOutput = normxcorr2(subimage, bigPicture);
% Find out where the normalized cross correlation image is brightest.
[maxCorrValue, maxIndex] = max(abs(correlationOutput(:)));
[yPeak,xPeak] = ind2sub(size(correlationOutput),maxIndex(1))
% Because cross correlation increases the size of the image, 
% we need to shift back to find out where it would be in the original image.
center = [(yPeak-floor(size(subimage,1)/2)), (xPeak-floor(size(subimage,2)/2))];
end
