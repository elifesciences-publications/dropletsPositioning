function DATA = do_gui3(DIR)
AUTODATA = load(fullfile(DIR,'data_auto.mat'));
AUTODATA = AUTODATA.DATA;
newfilename = fullfile(DIR,'data.mat');
DATA = emulsions_gui_oop(AUTODATA.drops,newfilename);
end
