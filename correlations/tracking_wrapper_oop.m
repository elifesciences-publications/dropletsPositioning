function tracking_wrapper_oop(param_file, Rrange, micronsPerPixel)
% BIGDROPS_WRAPPER a wrapper function for bigdrops_auto_analysis.
% Reads parametr file and filters file and executes BIGDROPS_AUTO_ANALYSIS
% on the filtered tiffs
% Input:
%   param_file - parameters file to be read by READ_PAR.
%   M - line number in filters file, or string to be used as suffix.
% see also emulsion_auto_analysis, read_par
if exist(param_file,'dir')
    param_file = fullfile(param_file,'params.txt')
end
if ~exist(param_file,'file')
    exit
end
display(fullfile('reading parameters from file: ', param_file));
PAR = read_par(param_file);
if nargin < 3 || isempty(micronsPerPixel)
    micronsPerPixel = -1;
end

if nargin < 2 || isempty(Rrange)
    if exist(fullfile(PAR.DIRNAME,'Rrange.txt'),'file')
        Rrange = dlmread(fullfile(PAR.DIRNAME,'Rrange.txt'));
    else
        Rrange = -1;
    end
end
Rrange = sort(Rrange);
    
M = 0
while true
    PAR.FILTERS = {sprintf('*T%03d_C0.tiff',M)};
    PAR.NAME = sprintf('time%03d.mat',M);
    D = dir(fullfile(PAR.DIRNAME,PAR.FILTERS{1}));
    if numel(D) == 0
        break
    end
    tracking_auto_analysis_oop(PAR,Rrange,micronsPerPixel);
    M = M + 1;
end
end
