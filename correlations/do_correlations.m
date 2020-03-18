function do_correlations(drops,plane,step,type)
if ~exist('type','var')
    type = 4;
end
if ~exist('step','var')
    step = 1;
end
[corr_vec,p] = drops_correlations(drops,plane,step,false,type);
c0 = drops(1).blobCenters(plane,:);
for i=2:length(corr_vec)
    drops(i).blobCenters = repmat(c0 - flip(corr_vec(:,i)') / drops(1).micronsPerPixel,5,1);
    drops(i).blobPlane = p(i);
end
