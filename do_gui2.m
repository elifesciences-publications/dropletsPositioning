function DATA = do_gui2(DIR, LINE)
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
    
T = readtable(fullfile(DIR,'filters.txt'),'Delimiter',' ','ReadVariableNames',false);
NAME = table2cell(T(LINE,end));
PAR.NAME = NAME{1};
linedir = fullfile(DIR,['analysis_',PAR.NAME]);
AUTODATA = load(fullfile(linedir,'data_auto.mat'));
AUTODATA = AUTODATA.DATA;
newfilename = fullfile(linedir,'data.mat');
DATA = emulsions_gui_oop(AUTODATA.drops,newfilename);
% save([fullfile(DIR,'analysis_data_'),PAR.NAME],'DATA','-v7.3'),
% emulsion_hist(DATA);
end
