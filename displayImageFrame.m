function displayImageFrame(ax, image, dropCenter, dropR, aggCenter, aggR, col, colorImageFlag)
    im = imcrop(image,cropRect);
    if colorImageFlag
        imRGB = zeros([size(im),3]);
        imRGB(:,:,2) = double(im)./double(max(im(:)));
        imshow(imadjust(imRGB), 'Parent', ax);
    else
        imshow(imadjust(im), 'Parent', ax);
    end
    hold(ax, 'on');
    plot(ax, aggCenter(1), aggCenter(2) ,'Color',col,'Marker','+', 'MarkerSize',10,'LineWidth',2);
    
    viscircles(ax, dropCenter, dropR,'Color',col,'EnhanceVisibility',false);
    viscircles(ax, aggCenter, aggR,'Color',col,'EnhanceVisibility',false);
end
