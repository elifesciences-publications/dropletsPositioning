function [DIR, filename] = getExperiment(line)
T = readtable('experiments.txt','Delimiter','\t');
if ~exist('line','var')
    line = 1:height(T)
end
fullfilename = T.filename(line);
[DIR,filename,ext] = cellfun(@(x) fileparts(x), fullfilename, 'UniformOutput', false);
[DIR,filename] = cellfun(@fixDirFilename, DIR, filename, ext, 'UniformOutput', false);
% filename = cellfun(@(x,y) [x,y], filename,ext,'UniformOutput',false);
end

function [DIR, filename] = fixDirFilename(DIR, filename, ext)
    DIR = strrep(DIR,'Z:\','W:\phkinnerets\storage\');
    if isempty(ext)
        DIR = fullfile(DIR,filename);
        filename = [];
    else
        filename = [filename,ext];
    end
    
end