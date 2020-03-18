warning('off','imageio:tiffmexutils:libtiffWarning');

%% New way
% DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\I-phase\capillary\2019_12_10';
% DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\I-phase\2019_12_11\capillary\mix2 sample1';
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\ActA\capillary';
launchDropletDetectDir(DIR,-1,false);

%% Old way
%% 80% control
% DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_01_03';
% filename = 'Capture 6_XY1514997239_Z0_T000_C1.tiff';
% filename ='Capture 9_XY1514999422_Z0_T000_C1.tiff';
DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_04_16';
% filename ='Capture 1_XY1523876898_C0.tiff';
filename ='Capture 2_XY1523877944_C0.tiff';

DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_08\mix1 sample1';
filename ='Capture 2_C0.tiff';
filename ='Capture 4_C0.tiff';
filename ='Capture 5_C0.tiff';
filename ='Capture 6_C0.tiff';

DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_08\mix2 sample1';
filename ='Capture 3_C0.tiff';
filename ='Capture 4_C0.tiff';
filename ='Capture 5_C0.tiff';
filename ='Capture 6_C0.tiff';

DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_09\mix1 sample1';
filename ='Capture 2_C0.tiff';
filename ='Capture 3_C0.tiff';
filename ='Capture 4_C0.tiff';
filename ='Capture 5_C0.tiff';
filename ='Capture 6_C0.tiff';

DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_09\mix2 sample1';
filename ='Capture 3_C0.tiff';
filename ='Capture 4_C0.tiff';
filename ='Capture 5_C0.tiff';
filename ='Capture 6_C0.tiff';

DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_09\mix2 sample2';
filename ='Capture 2_C0.tiff';
filename ='Capture 3_C0.tiff';
filename ='Capture 4_C0.tiff';
filename ='Capture 5_C0.tiff';

DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_13\mix2 sample1 16_42';
filename ='Capture 1_C0.tiff';
filename ='Capture 2_C0.tiff';

DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_13\mix2 sample2 17_05';
filename ='Capture 1_C0.tiff';
filename ='Capture 2_C0.tiff';

DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_13\mix2 sample3 17_35';
filename ='Capture 1_C0.tiff';

DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_13\mix2 sample4 18_00';
filename ='Capture 1_C0.tiff';

DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_08_13\mix2 sample5 18_32';
filename ='Capture 1_C0.tiff';

%% 60% control
DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_05_14\60% control\mix2 sample1';
filename ='NCapture 1_T000_C0.tiff';
filename ='NCapture 2_T000_C1.tiff';
filename ='NCapture 5_T000_C0.tiff';
filename ='NCapture 6_T000_C0.tiff';

DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_05_14\60% control\mix2 sample2';
filename ='Capture 1_C0.tiff';
filename ='Capture 2_C0.tiff';
filename ='Capture 4_C0.tiff';
%% 60% + dextran
DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_05_15\60% + 10mg_per_ml dextran';
filename ='Capture 1_C0.tiff';
filename ='Capture 2_C0.tiff';
filename ='Capture 3_C0.tiff';

DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_05_16\60% + 10mg_per_ml dextran';
filename ='Capture 1_C0.tiff';
filename ='Capture 2_C0.tiff';
filename ='Capture 3_C0.tiff';
%% ActA
DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_05_28\0.5uM ActA';
filename ='Capture 1_C0.tiff';
filename ='Capture 2_C0.tiff';
filename ='Capture 3_C0.tiff';
filename ='Capture 4_C0.tiff';
filename ='Capture 5_C0.tiff';

%% cp
DIR = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_05_29\0.5uM cp';
filename ='Capture 1_C0.tiff';
filename ='Capture 2_C0.tiff';
filename ='Capture 3_C0.tiff';
filename ='Capture 4_C0.tiff';

 %% with free fluorofore
% DIR = 'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2019_01_31\with free fluorofore\mix1 sample1\';
% filename = 'Capture 1_C0.tiff';
% filename = 'Capture 2_C0.tiff';

DIR = 'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2019_01_31\with free fluorofore\mix2 sample1\';
filename = 'Capture 1_C0.tiff';
filename = 'Capture 2_C0.tiff';

%% 40%
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\40%\2019_11_20\capillary';
filename ='Capture 1_C0.tiff';
filename ='Capture 2_C0.tiff';
filename ='Capture 3_C0.tiff';
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\40%\2019_12_03\capillary\sample1';
filename ='Capture 1_C0.tiff';
filename ='Capture 2_C0.tiff';
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\40%\2019_12_03\capillary\sample2';
filename ='Capture 1_C0.tiff';

%% I-phase%
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\I-phase\2019_11_20\capillary\mix2 sample1';
filename ='Capture 2_C0.tiff';
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\I-phase\2019_11_20\capillary\mix2 sample2';
filename ='Capture 1_C0.tiff';
filename ='Capture 2_C0.tiff';
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\I-phase\2019_11_28\capillary\mix1 sample1';
filename ='Capture 1_C0.tiff';
filename ='Capture 2_C0.tiff';
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\I-phase\2019_11_28\capillary\mix2 sample2';
filename ='Capture 1_C0.tiff';
%% Rambam 10 80%%
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\2019_11_24\capillary\sample 1';
filename ='Capture 1_C0.tiff';
filename ='Capture 2_C0.tiff';
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\2019_11_24\capillary\sample 2';
filename ='Capture 2_C0.tiff';
filename ='Capture 3_C0.tiff';
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\2019_12_03\capillary';
filename ='Capture 2_C0.tiff';

%% Rambam 10 60%%
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\60%\2019_11_20\capillary\mix1 sample1';
filename ='Capture 2_C0.tiff';
filename ='Capture 3_C0.tiff';
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam10\60%\2019_11_20\capillary\mix1 sample3';
filename ='Capture 3_C0.tiff';


%%
fullname = fullfile(DIR,filename);
images = load_tiff_file(fullname,1);

%  [gx, gy] = cellfun(@(im) gradient(double(im)/double(max(im(:)))),images, 'UniformOutput', false);
%  Imgrads = cellfun(@(gx, gy) sqrt(gx.^2 + gy.^2), gx, gy, 'UniformOutput', false);
%  [gx2, gy2] = cellfun(@(im) gradient(double(im)/double(max(im(:)))),Imgrads, 'UniformOutput', false);
%  Imgrads2 = cellfun(@(gx2, gy2) sqrt(gx2.^2 + gy2.^2), gx2, gy2, 'UniformOutput', false);
% 
% clear filenames
% [filenames{1:length(images)}] = deal(fullname);
[~,f,~] = fileparts(filename);
% 
fLoad = ls(fullfile(DIR,[f,'*.mat']));
fLoadFull = fullfile(DIR,fLoad(1,:));
if exist('fLoad', 'var') && ~isempty(fLoad) && exist(fLoadFull, 'file')
    one_position_gui_obj({fullname}, images, fLoadFull);
else
%     
    one_position_gui_obj({fullname}, images);
%     one_position_gui_obj(filenames, images, fLoad);
end

