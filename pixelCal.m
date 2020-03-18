function [planesPerPixel, micronsPerPixel, micronsPerPlane] = pixelCal(PAR,micronsPerPixel)
if ischar(PAR)
    DIR = PAR;
    SCALEFACTOR = 1;
else
    DIR = PAR.DIRNAME;
    SCALEFACTOR = PAR.SCALEFACTOR;
end
DL = dir(fullfile(DIR,'*.log'));
logfile = fullfile(DIR,DL(1).name);
LF = fopen(logfile);
TS = textscan(LF, '%s %f',2,'Delimiter',':','HeaderLines',5);
fclose(LF);
if nargin < 2 || micronsPerPixel < 0
    micronsPerPixel = TS{2}(1)/SCALEFACTOR;
end
micronsPerPlane = TS{2}(2);
planesPerPixel = micronsPerPixel/micronsPerPlane;
end
