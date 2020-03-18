function [micronsPerPixel, micronsPerPlane, timeSep] = readCalibration(filename)
[d,n,e] = fileparts(filename);
if strcmp(e, 'log');
    logfile = filename;
else
    logfile = fullfile(d,[n, '.log']);
end
LF = fopen(logfile);
TS = textscan(LF, '%s %f',3,'Delimiter',':','HeaderLines',5);    
fclose(LF);
micronsPerPixel = TS{2}(1);
micronsPerPlane = TS{2}(2);
timeSep  = TS{2}(3)/1000;
if isnan(timeSep)
    timeSep=0;
end
