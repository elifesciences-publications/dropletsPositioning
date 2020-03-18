for num = (num+1):length(check)
    clear filenames images fLoad;
    [DIR,f,e] = fileparts(check{num});
    files = fullfile(DIR,[f, '*.tiff']);
    fs = ls(files);
    for i=1:size(fs,1)
        filenames{i} = fullfile(DIR,fs(i,:));
        images{i} = load_tiff_file(filenames{i},1);
    end
    k = strfind(filenames{1}, '_T0');
    if ~isempty(k);
        ind = max(k(end) - 1, 1);
        fLoad = [filenames{1}(1:ind),'.mat'];
    end
    num
    copyfile(check{num},[check{num},'.bak']);
    waitfor(one_position_gui_obj(filenames, images, fLoad));
    cont = questdlg('Open Next Position?', 'Continue', 'Yes', 'No', 'Yes');
    if ~strcmp(cont, 'Yes')
        break;
    end
end