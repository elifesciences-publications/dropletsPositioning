function bigdrops_wrapper(DIR, M)
% BIGDROPS_WRAPPER a wrapper function for bigdrops_auto_analysis.
% Reads parametr file and filters file and executes BIGDROPS_AUTO_ANALYSIS
% on the filtered tiffs
% Input:
%   param_file - parameters file to be read by READ_PAR.
%   M - line number in filters file, or string to be used as suffix.
% see also emulsion_auto_analysis, read_par
param_file = fullfile(DIR,'params.txt');
if exist(param_file,'file')
    display(fullfile('reading parameters from file: ', param_file));
    PAR = read_par(param_file);
else
    display('not using param_file');
    PAR.DIRNAME = DIR;
    PAR.SCALEFACTOR = 1;
    PAR.PADDING = PAR.SCALEFACTOR*30;
end
    
if isnumeric(M)
    T = readtable(fullfile(DIR,'filters.txt'),'Delimiter',' ','ReadVariableNames',false);
    NAME = table2cell(T(M,end));
    FILTERS = table2cell(T(M,1:end-1));
    PAR.FILTERS = FILTERS;
    PAR.NAME = NAME{1};
elseif ischar(M)
    PAR.NAME = M;
else
    error('montage input not understood');
end
bigdrops_auto_analysis_oop(PAR);
end
