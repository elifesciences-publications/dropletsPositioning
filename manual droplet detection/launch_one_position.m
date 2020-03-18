warning('off','imageio:tiffmexutils:libtiffWarning');
%% New way
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\I-phase\2020_01_08';
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\0.5uM ActA\2020_01_08';
timeZero = 45*60;
launchDropletDetectDir(DIR,-1, false, true, timeZero, {[],1})
%% Old way
%%

DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\nocadazole\2019_10_27 33uM nocadazole mix1 sample1';
filenameTemplateBF = 'Capture * - Position *.tiff';
regexpStr = '\d*.tiff';
fileList = ls(fullfile(DIR,filenameTemplateBF));
fileNums = regexp(string(fileList), regexpStr, 'match');
fileNums = convertContainedStringsToChars(fileNums);
[fileNums, I] = sort(cellfun(@(x) str2num(x(1:end-5)), fileNums));
fileList = fileList(I,:);
startPos = 0;
endPos = 0;
startInd = find(fileNums == startPos);
endInd = find(fileNums == endPos);
if isempty(startInd)
    startInd = 43;
end
if isempty(endInd)
    endInd = length(fileList);
end

for num = startInd:endInd
    filenameBF = fullfile(DIR, fileList(num,:));
    indexOfDot = strfind(filenameBF,'.tiff');
    filenameBaseBF = filenameBF(1:(indexOfDot - 1));
    imagesBF = load_tiff_file(filenameBF,1);
    imagesBF = reshape(imagesBF,[],4); %why?
%     imagesBF = imagesBF';
    dataFilename = [filenameBaseBF, '.mat'];
     if exist(dataFilename, 'file')
         waitfor(one_position_gui_obj({filenameBF}, imagesBF, dataFilename));
     else
         waitfor(one_position_gui_obj({filenameBF}, imagesBF));
     end
     cont = questdlg('Open Next Position?', 'Continue', 'Yes', 'No', 'Yes');
     if ~strcmp(cont, 'Yes')
         break;
     end
end
%%
% DIR = 'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2017_12_21\mix1 sample2\';
% posRegexp = 'p15138523%d*.tiff'; num=13; %:48
% DIR = 'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2017_12_21\mix1 sample1\';
% posRegexp = 'p1513847%d*.tiff'; num=574; %:611
% DIR = 'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2017_12_20\sample2\';
% posRegexp = 'p15137721%d*.tiff'; % num=72; %:96
% DIR = 'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2017_12_21\mix2 sample1';
% posRegexp = 'p1513858%d*.tiff'; % num=560; %:603
% DIR = 'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2018_01_18\sample2';
% posRegexp = 'p1516274%d*.tiff'; %num=171; %:217
DIR = 'Z:\analysis\Niv\symmetry breaking statistics\2018_05_10\60% control\mix1 sample1';
posRegexp = 'P1525943%d*.tiff'; num=174; %:206
num = 174;
% for num = 175:206 % 172:217 %561:603 %73:96 %575:611 %14:48
for num=(num+1):206

    num
    clear filenames images fLoad;
    fileUniqueName=sprintf(posRegexp,num);
    fs = ls(fullfile(DIR,fileUniqueName));
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
    if exist('fLoad', 'var') && ~isempty(fLoad) && exist(fLoad, 'file')
        waitfor(one_position_gui_obj(filenames, images, fLoad));
    else
        waitfor(one_position_gui_obj(filenames, images));
    end
    num
    cont = questdlg('Open Next Position?', 'Continue', 'Yes', 'No', 'Yes');
    if ~strcmp(cont, 'Yes')
        break;
    end
end
%% 05/09/2018
DIR = 'Z:\analysis\Niv\symmetry breaking statistics\30um\2018_09_02\';
filenameTemplateBF = 'Capture 1 - Position %d_C0';
filenameTemplateGFP = 'Capture 1 - Position %d_C1';

for num=1:31 %1:31
    filenameBaseBF = sprintf(filenameTemplateBF,num);
    filenameBF = fullfile(DIR,[filenameBaseBF, '.tiff']);
    filenameBaseGFP = sprintf(filenameTemplateGFP,num);
    filenameGFP = fullfile(DIR,[filenameBaseGFP, '.tiff']);
    imagesGFP = load_tiff_file(filenameGFP,1);
    imagesGFP = reshape(imagesGFP,[],4);
    imagesBF = load_tiff_file(filenameBF,1);
    imagesBF = reshape(imagesBF,[],4);
    dataFilename = fullfile(DIR,[filenameBaseBF, '.mat']);
    if exist(dataFilename, 'file')
        waitfor(one_position_gui_obj({filenameBF}, cat(3, imagesBF, imagesGFP), dataFilename));
    else
        waitfor(one_position_gui_obj({filenameBF}, cat(3, imagesBF, imagesGFP)));
    end
    cont = questdlg('Open Next Position?', 'Continue', 'Yes', 'No', 'Yes');
    if ~strcmp(cont, 'Yes')
        break;
    end
end

%% 30/12/2018
% DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_30 mix5 0.05uM acta-bodipy\';
% filenameTemplateBF = 'Capture 1 - Position %d';
% DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_30 mix4 0.025uM acta-bodipy\';
% filenameTemplateBF = 'Capture 3 - Position %d';
% DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_31 mix1 0.017uM acta-bodipy\';
% filenameTemplateBF = 'Capture 2 - Position %d';
% DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_30 mix3 0.1uM acta-bodipy\';
% filenameTemplateBF = 'Capture 1 - Position %d';
% DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\nocadazole\2019_10_27 33uM nocadazole mix1 sample1';
% filenameTemplateBF = 'Capture 1 - Position %d';
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\100nM ActA\2019_10_28\mix1';
filenameTemplateBF = 'Capture 1 - Position %d';

for num = 1:31 %1:47 %1:25 %1:42 %1:41
    filenameBaseBF = sprintf(filenameTemplateBF,num);
    filenameBF = fullfile(DIR,[filenameBaseBF, '.tiff']);
    imagesBF = load_tiff_file(filenameBF,1);
    imagesBF = reshape(imagesBF,[],4); %why?
%     imagesBF = imagesBF';
    dataFilename = fullfile(DIR,[filenameBaseBF, '.mat']);
    if exist(dataFilename, 'file')
        waitfor(one_position_gui_obj({filenameBF}, imagesBF, dataFilename,timeZero));
    else
        waitfor(one_position_gui_obj({filenameBF}, imagesBF,-1,timeZero));
    end
    cont = questdlg('Open Next Position?', 'Continue', 'Yes', 'No', 'Yes');
    if ~strcmp(cont, 'Yes')
        break;
    end
end