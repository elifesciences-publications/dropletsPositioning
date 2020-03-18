function captureTime = readCaptureTime(filename)
[d,n,e] = fileparts(filename);
if strcmp(e, 'log');
    logfile = filename;
else
    logfile = fullfile(d,[n, '.log']);
end
LF = fopen(logfile);
TS = textscan(LF, 'Capture Date-Time: %s',1,'Delimiter','\n','HeaderLines',1);    
fclose(LF);
captureTime = datetime(TS{1}{1},'InputFormat','MM/dd/yyyy HH:mm:ss');
