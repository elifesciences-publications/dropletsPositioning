function [ croppedImage ] = circularCrop( image, center, radius )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
s = size(image);
[x,y] = meshgrid(-(center(1)-1):(s(2)-center(1)),-(center(2)-1):(s(1)-center(2)));
c_mask = ((x.^2+y.^2) <= radius^2);
croppedImage = image.*cast(c_mask, 'like', image);
end

