function drops = do_gui_tracking_oop(DIR)
PAR = read_par(fullfile(DIR,'params.txt'));
M = 0;
drops = [];
while true
    PAR.NAME = sprintf('time%03d.mat',M);
    if exist([fullfile(DIR,'analysis_data_auto_oop_'),PAR.NAME],'file')
        TEMP = load([fullfile(DIR,'analysis_data_auto_oop_'),PAR.NAME]);
        drops = [drops,TEMP.DATA.drops];
    else
        break
    end
    M = M + 1;
end

drops = emulsions_gui_oop(drops,DIR);
% save([fullfile(DIR,'analysis_data_'),PAR.NAME],'DATA','-v7.3'),
% emulsion_hist(DATA);
end
