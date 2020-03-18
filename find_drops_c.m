function [centers, radii, metrics] = find_drops_c(montage, micronsPerPixel, Rrange)
if nargin < 3 || ~isnumeric(Rrange) || numel(Rrange) ~= 2
    Rrange = [15 100];
end
Rrange = round(Rrange / micronsPerPixel);

Nrange = ceil((Rrange(end) - Rrange(1))/100);
segRrange = round(linspace(Rrange(1),Rrange(end),Nrange+1));

centers = {[]};
radii = {[]};
metrics = {[]};
for plain = 1:2
    for k = 1:Nrange
        centersD = {};
        radiiD = {};
        metricsD = {};
        
        centersB = {};
        radiiB = {};
        metricsB = {};

        [centersD, radiiD, metricsD] = imfindcircles_wrapper(image,Rrange,'dark');
        [centersB, radiiB, metricsB] = imfindcircles_wrapper(image,Rrange,'bright');

        indI=[];
        for i = 1:length(radiiD)
            for j = 1:length(radiiB)
                diffC = centersD(i,:) - centersB(j,:);
                if diffC*diffC' < ((radiiD(i))^2)/4
                    if radiiD(i) < radiiB(j)
                        radiiB(j) = [];
                        centersB(j,:) = [];
                        metricsB(j) = [];
                        break;
                    else
                        indI = [indI,i];
                    end
                end
            end
        end
        radiiD(indI) = [];
        centersD(indI,:) = [];
        metricsD(indI) = [];
        
        %         centersDark{plain} = [centersDark{plain}; centersD{plain}{k}];
        %         radiiDark{plain} = [radiiDark{plain}; radiiD{plain}{k}];
        %         metricsDark{plain} = [metricsDark{plain}; metricsD{plain}{k}];
        %         centersBright{plain} = [centersBright{plain}; centersB{plain}{k}];
        %         radiiBright{plain} = [radiiBright{plain}; radiiB{plain}{k}];
        %         metricsBright{plain} = [metricsBright{plain}; metricsB{plain}{k}];
        centers{plain} = [centers{plain}; centersD; centersB];
        radii{plain} = [radii{plain}; radiiD; radiiB];
        metrics{plain} = [metrics{plain}; metricsD; metricsB];
        [centers{plain},ind] = sortrows(centers{plain});
        radii{plain} = radii{plain}(ind);
        metrics{plain} = metrics{plain}(ind);
    end
end
end