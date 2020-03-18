function [corr_vec,p] = drops_correlations(drops,plane,step,forcePlane,type)
if numel(drops <2)
    error('need at least 2 drops')
end
if ~exist('type','var')
    type = 4;
end
if ~exist('step','var')
    step = 1;
end
if ~exist('forcePlane','var')
    forcePlane = false;
end

corr_vec = zeros(2,(numel(drops)));
p = ones(1,(numel(drops))) * plane;
d0 = 1;
for t=2:(numel(drops))
    if strcmp(forcePlane,'forcePlane')
        planes = plane;
    else
        planes = 1:drops(1).numOfPlanes;
    end
    for i = planes
        [output{i}, crr{i}] = dropCorr(drops(d0),drops(t),[plane,i],type);
    end
    M = cellfun(@(x) max(x(:)),crr);
    [~,ind] = max(M);
    
    corr_vec(:,t) = corr_vec(:,d0) + output{ind}';
    p(t) = ind;
    
    if ~mod(t - 1,step)
        d0 = t;
        plane = ind;
    end
end
corr_vec = corr_vec*drops(1).micronsPerPixel;