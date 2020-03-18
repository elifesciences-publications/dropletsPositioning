function PAR = read_par(filename)
% READ_PAR reads parameter file for emulsion analysis
%   Output: PAR structure containing fields:
%	PAR.DIRNAME - Directory containing the input file.
%	PAR.SCALEFACTOR - Scaling of saved images with respect to original.
%	PAR.N - Number of coloumns (OR ROWS????) in montage.
%	PAR.M - Number of rows (OR COLUMNS???) in montage.
%	PAR.LINEOFFX
%	PAR.COLOFFX
%	PAR.LINEOFFY
%	PAR.COLOFFY - Offsets to constructing montage
%	PAR.PADDING - extra padding to save around drop images.

% see also emulsion_auto_analysis, auto_wrapper
[DIR,~,~] = fileparts(filename);
FID = fopen(filename);
C = textscan(FID, '%f %d %d %f %f %f %f %f',1,'delimiter',';');
PAR.DIRNAME = DIR;
PAR.SCALEFACTOR = C{1};
PAR.N = C{2};
PAR.M = C{3};
PAR.LINEOFFX = round(C{4}*PAR.SCALEFACTOR);
PAR.COLOFFX = round(C{5}*PAR.SCALEFACTOR);
PAR.LINEOFFY = round(C{6}*PAR.SCALEFACTOR);
PAR.COLOFFY = round(C{7}*PAR.SCALEFACTOR);
PAR.PADDING = C{8}*PAR.SCALEFACTOR;
end
