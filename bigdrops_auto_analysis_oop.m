function DATA = bigdrops_auto_analysis_oop(PAR)
% BIGDROPS_AUTO_ANALYSIS run analysis on the directory and parameters in
%   PAR.
%
% Input: PAR structure with fields:
%	PAR.DIRNAME - Name of the directory containing tiff images.
%	PAR.NAME - Suffix to output and input files.
%	PAR.SCALEFACTOR - Scaling of saved images with respect to original.
%	PAR.N - Number of coloumns (OR ROWS????) in montage.
%	PAR.M - Number of rows (OR COLUMNS???) in montage.
%	PAR.LINEOFFX
%	PAR.COLOFFX
%	PAR.LINEOFFY
%	PAR.COLOFFY - Offsets to constructing montage
%	PAR.PADDING - extra padding to save around drop images.
%
% Output: DATA structure containing fields DATA.PAR and DATA.drops
%   DATA.PAR - a copy of input PAR structure.
%	DATA.drops - structure array of saved drops with images and extracted
%	data.
%
% see also read_par, auto_wrapper
% if nargin > 2
%     FILTER = varargin{1};
% else
%     FILTER = '*.tiff';
% end

DATA.PAR = PAR;
DATA.drops = [];
for i=1:length(PAR.FILTERS)
D = dir(fullfile(PAR.DIRNAME,PAR.FILTERS{i}));
fs = {D.name};
display(PAR.FILTERS{i});
for j=1:length(fs);
    tfile = fullfile(DATA.PAR.DIRNAME,fs{j});
    image_stack = load_tiff_file(tfile,PAR.SCALEFACTOR);
    image_stack = cellfun(@(x) double(x)/double(max(max(x))),image_stack,'UniformOutput',false);
    display(sprintf('Position %d of %d', j, length(fs)));
    drops = extract_drops_oop(image_stack,PAR,-1,-1,'nodetect');
    [drops.originFile] = deal(tfile);
    DATA.drops = [DATA.drops,drops];
end

% save drops data
if isfield(DATA.PAR,'NAME')
    out_dir_name = ['analysis_',DATA.PAR.NAME];
else
    out_dir_name = 'analysis';
end
full_path = fullfile(DATA.PAR.DIRNAME,out_dir_name);
if ~exist('out_dir_name','dir')
    mkdir(full_path);
end
save(fullfile(full_path,'data_auto.mat'),'DATA','-v7.3'),
end
