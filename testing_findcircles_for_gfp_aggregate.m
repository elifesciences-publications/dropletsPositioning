cropRect = [207 238 174 171];
for i=1:5
    I = imcrop(images{1}{i},cropRect);    
    I = imgaussfilt(I,3);
    hy = fspecial('sobel');
    hx = hy';
    Iy = imfilter(double(I), hy, 'replicate');
    Ix = imfilter(double(I), hx, 'replicate');
    Ig = sqrt(Ix.^2 + Iy.^2);
    figure; imshow(double(I)/double(intmax(class(I))));
    figure; imshow(Ig/double(intmax(class(I))));
    [centers{i},radii{i},metric{i}] = imfindcircles(Ig,[15 30], 'ObjectPolarity','bright');
end
centers
radii
metric
%%
for i=1:5
    I = imcrop(images{1}{i},cropRect);
    I = imgaussfilt(I,3);
    [Ix, Iy] = gradient(double(I)/double(intmax(class(I))));
    Ig = sqrt(Ix.^2 + Iy.^2);
    figure; imshow(Ig/double(intmax(class(I))));
    figure; imshow(Ig);
    [centers{i},radii{i},metric{i}] = imfindcircles(Ig,[15 30], 'ObjectPolarity','dark');
end
%%
for i=1:5
    I = images{1}{i};
    figure; imshow(double(I)/double(intmax(class(I))));
end
%%
for i=1:5
    I = imcrop(images{1}{i},cropRect);
    I = imgaussfilt(I,3);
    [centers{i},radii{i},metric{i}] = imfindcircles(I,[15 30], 'ObjectPolarity','dark');
end
centers
radii
metric