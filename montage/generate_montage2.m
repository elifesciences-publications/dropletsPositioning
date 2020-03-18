function [ montage ] = generate_montage2( images ,N, M, lineOverlap, colOverlap, lineOffX, colOffY)
% GENERATE_MONTAGE2 build a montage from a series of images
%
% Input:
%   images - Cell array of images of uniform size, ordered for a sanke montage.
%   N - Number of rows of images in montage.
%   M - Number of columns of images in montage.
%   lineOverlap - Vertical overlap between lines of images.
%   colOverlap - Horizontal overlap between columns of images.
%   lineOffX - Horizontal offset to add to each line of images.
%   colOffY - Vertical offset to add to each column of images.
%
% Output:
%   montage - Snake montage of input images
   
s = size(images{1});
if lineOffX < 0
    baseOffX = -lineOffX*(N-1);
else
    baseOffX = 0;
end;

if colOffY < 0
    baseOffY = -colOffY*(M-1);
else
    baseOffY = 0;
end;

sizeOffX = max(baseOffX - colOverlap*(M-1),baseOffX + lineOffX*(N-1) - colOverlap*(M-1));
sizeOffY = max(baseOffY - lineOverlap*(N-1),baseOffY + colOffY*(M-1) - lineOverlap*(N-1));
montage = zeros(s(1)*N + sizeOffY,s(2)*M + sizeOffX);

for i=1:N
    for j=1:M
        if mod(i,2) == 1
            x = [(j-1)*s(2)+1,j*s(2)] + baseOffX + lineOffX*(i-1) - colOverlap*(j-1);
            y = [(i-1)*s(1)+1,i*s(1)] + baseOffY - lineOverlap*(i-1) + colOffY*(j-1);
        else
            x = [(M-j)*s(2)+1,(M-j+1)*s(2)] + baseOffX + lineOffX*(i-1) - colOverlap*(M-j);
            y = [(i-1)*s(1)+1,i*s(1)] + baseOffY - lineOverlap*(i-1) + colOffY*(M-j);
        end
        montage(y(1):y(2),x(1):x(2)) = images{M*(i-1)+j};
    end
end
%montage = imadjust(montage/max(montage(:)));
end

