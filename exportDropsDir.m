function exportDropsDir(desc,DIR,filename)
if ~exist('filename','var')
    filename = 'data.mat';
end
load(fullfile(DIR,filename));
params.description = desc;
if ~exist('drops','var') && exist('DATA','var')
    drops = DATA.drops;
end
params.BV = drops.blob_vectors;
exportDropsData(params,DIR);