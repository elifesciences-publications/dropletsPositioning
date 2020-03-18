function I = ringIntensity(image, center, ringRadius, ringWidth, thetaAxis, doPlot)
    if ~exist('doPlot','var')
        doPlot = false;
    end
    imSize = size(image);
    [X,Y] = meshgrid(-(center(1)-1):(imSize(2)-center(1)),-(center(2)-1):(imSize(1)-center(2)));
    [Theta,R] = cart2pol(X, Y);
    % Move theta=0 to top
    Theta = Theta+0.5*pi;
    % Range 0 to 2pi
    Theta(Theta < 0) = Theta(Theta < 0) + 2*pi;
    % Change direction to counter-clockwise
    Theta = 2*pi - Theta;
    
    t = [thetaAxis, 2*pi];
    I = zeros(size(thetaAxis));
    for i=1:length(thetaAxis)
        pixels = (Theta >= t(i) & Theta < t(i+1) & R >= ringRadius & R <= ringRadius + ringWidth);
        I(i) = sum(image(pixels))./sum(pixels(:));
%         if isnan(I(i))
%             i
%         end
    end
    if doPlot
        imageWithRing = zeros([size(image),3]);
        imageWithRing(:,:,2) = double(image)/double(max(image(:)));
        pixels = ...$(ismembertol(Theta,t,0.004) & R >= ringRadius & R <= ringRadius + ringWidth) |...
            round(R,0) == round(ringRadius,0) | round(R,0) == round(ringRadius + ringWidth,0);
        
        imageWithRing(pixels) = 1;
        figure; imshow(imageWithRing);
    end
end