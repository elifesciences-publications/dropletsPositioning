function [centers, radii, metrics] = find_drops(montage, micronsPerPixel, Rrange)
display('searching for drops in montage...');
if nargin < 3 || ~isnumeric(Rrange) || numel(Rrange) ~= 2
    Rrange = [15 100];
end
Rrange = round(Rrange / micronsPerPixel);

Nrange = ceil((Rrange(end) - Rrange(1))/100);
segRrange = round(linspace(Rrange(1),Rrange(end),Nrange+1));

centersD = cell(length(montage),length(segRrange));
radiiD = cell(length(montage),length(segRrange));
metricsD = cell(length(montage),length(segRrange));
centersB = cell(length(montage),length(segRrange));
radiiB = cell(length(montage),length(segRrange));
metricsB = cell(length(montage),length(segRrange));
% centersDark = cell(size(montage));
% radiiDark = cell(size(montage));
% metricsDark = cell(size(montage));
% centersBright = cell(size(montage));
% radiiBright = cell(size(montage));
% metricsBright = cell(size(montage));
centers = cell(size(montage));
radii = cell(size(montage));
metrics = cell(size(montage));
for plain = 1:length(montage)
    display(sprintf('searching for drops in plain %d of %d', plain, length(montage)));
    for i = 1:Nrange
        [centersD{plain,i}, radiiD{plain,i}, metricsD{plain,i}] = imfindcircles(montage{plain},[segRrange(i), segRrange(i+1)],'ObjectPolarity','dark','Sensitivity',0.95);
        [centersB{plain,i}, radiiB{plain,i}, metricsB{plain,i}] = imfindcircles(montage{plain},[segRrange(i), segRrange(i+1)],'ObjectPolarity','bright','Sensitivity',0.85);
    end
end
for plain = 1: length(montage)
    for k = 1:Nrange
        indI=[];
        for i = 1:length(radiiD{plain,k})
            for j = 1:length(radiiB{plain,k})
                diffC = centersD{plain,k}(i,:) - centersB{plain,k}(j,:);
                if diffC*diffC' < ((radiiD{plain,k}(i))^2)/4
                    if radiiD{plain,k}(i) < radiiB{plain,k}(j)
                        radiiB{plain,k}(j) = [];
                        centersB{plain,k}(j,:) = [];
                        metricsB{plain,k}(j) = [];
                        break;
                    else
                        indI = [indI,i];
                    end
                end
            end
        end
        radiiD{plain,k}(indI) = [];
        centersD{plain,k}(indI,:) = [];
        metricsD{plain,k}(indI) = [];
        
        %         centersDark{plain} = [centersDark{plain}; centersD{plain}{k}];
        %         radiiDark{plain} = [radiiDark{plain}; radiiD{plain}{k}];
        %         metricsDark{plain} = [metricsDark{plain}; metricsD{plain}{k}];
        %         centersBright{plain} = [centersBright{plain}; centersB{plain}{k}];
        %         radiiBright{plain} = [radiiBright{plain}; radiiB{plain}{k}];
        %         metricsBright{plain} = [metricsBright{plain}; metricsB{plain}{k}];
        centers{plain} = [centers{plain}; centersD{plain,k}; centersB{plain,k}];
        radii{plain} = [radii{plain}; radiiD{plain,k}; radiiB{plain,k}];
        metrics{plain} = [metrics{plain}; metricsD{plain,k}; metricsB{plain,k}];
        [centers{plain},ind] = sortrows(centers{plain});
        radii{plain} = radii{plain}(ind);
        metrics{plain} = metrics{plain}(ind);
    end
end
end