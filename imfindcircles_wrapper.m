function [centers, radii, metrics] = imfindcircles_wrapper(image,Rrange,ld)
if strcmp(ld,'dark')
    [centers, radii, metrics] = imfindcircles(image,Rrange,'ObjectPolarity','dark','Sensitivity',0.95);
else
    [centers, radii, metrics] = imfindcircles(image,Rrange,'ObjectPolarity','bright','Sensitivity',0.85);
end
end