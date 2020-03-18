function DATA = do_gui_oop(DIR, LINE)
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

AUTODATA = load([fullfile(DIR,'analysis_data_auto_oop_'),PAR.NAME]);
AUTODATA = AUTODATA.DATA;
newfilename = [fullfile(DIR,'analysis_data_oop_'),PAR.NAME];
DATA = emulsions_gui_oop(AUTODATA.drops,newfilename);
% save([fullfile(DIR,'analysis_data_'),PAR.NAME],'DATA','-v7.3'),
% emulsion_hist(DATA);
end
