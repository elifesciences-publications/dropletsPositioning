function smoothed = gaussianSmoothing(x,y,sigma)
%     nanInds = isnan(y);
%     y(nanInds) = [];
%     x(nanInds) = [];
    x = reshape(x, 1, []);
    y = reshape(y, 1, []);
    yi = repmat(y,length(y),1);
    [xi,x0] = meshgrid(x,x);
    d = xi - x0;
    expo = exp(-(d.^2)/(2*sigma^2));
    norm = sum(expo);
    smoothed = sum(yi'.*expo)./norm;


