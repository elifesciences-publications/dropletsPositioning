function launchDropletDetectDir(dirname,filterString, askCont, loadFlag, timeZero, reShape)
if ~exist('filterString','var') || ~ischar(filterString) || isempty(timeZero)
    filterString = '*_C0.tiff';
end
if ~exist('askCont','var')
    askCont = true;
end
if ~exist('loadFlag','var')
    loadFlag = false;
end
if ~exist('timeZero','var') || isempty(timeZero)
    timeZero = 0;
end
if ~exist('reShape','var')
    reshapeFlag = false;
else
    reshapeFlag = true;
end

dirListing = dir(fullfile(dirname,'**',filterString));
for fileNum = 1:numel(dirListing)
    file = dirListing(fileNum);
    [~, basefilename, ~] = fileparts(file.name);
    fullname = fullfile(file.folder, file.name);
    fullnameMat = fullfile(file.folder, [basefilename,'.mat']);
    images = load_tiff_file(fullname,1);
    if reshapeFlag
        images = reshape(images,reShape{:});
    end
    if loadFlag && exist(fullnameMat, 'file')
        waitfor(one_position_gui_obj({fullname}, images, fullnameMat,timeZero));
    else
        waitfor(one_position_gui_obj({fullname}, images, -1, timeZero));
    end
    if askCont && fileNum < numel(dirListing)
        cont = questdlg('Open next sample?', 'Continue', 'Yes', 'No', 'Yes');
        if ~strcmp(cont, 'Yes')
            break;
        end
    end
end
end

