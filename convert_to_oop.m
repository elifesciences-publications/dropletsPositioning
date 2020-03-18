function newFilename = convert_to_oop(filename)
    [pathstr,name,ext] = fileparts(filename);
    newFilename = fullfile(pathstr,[name,'_oop',ext]);
    if ~exist(filename,'file')
        warning('File not found, aborting. %s', filename);
        return;
    elseif exist(newFilename,'file')
        warning('New file exists, aborting. %s', newFilename);
        return;
    else
        load(filename);
        if exist('DATA_OUT','var')
            DATA_OLD = DATA_OUT;
            clear DATA_OUT;
        elseif exist('DATA','var')
            DATA_OLD = DATA;
            clear DATA;
        end
        DATA.PAR = DATA_OLD.PAR;
        DATA.drops = drop(DATA_OLD.drops);
        save(newFilename,'DATA','-v7.3');
    end
end

    