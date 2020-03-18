% ---- tracking ---- %
DIR_CEN1 = getExperiment(15);
% plot_movement_xy2(DIR_CEN1,1,[0.5,-0.5],10);
DIR_BREAK2 = getExperiment(14);
% plot_movement_xy2(DIR_BREAK2,1,[0,0],10)
plot_movement_xy2([DIR_CEN1;DIR_BREAK2],1,[0,0],10, true);

% ---- displacement ---- %
% standard
[DIR_S, ~] = getExperiment(1:4);
scatter_displacement(DIR_S',1,[60,50;85,50]);
hist_symbreaking(DIR_S',[0,60;60,85;85,130])

%time with averageing
load_and_make_vectors

% ---- magnets ---- %
magDir = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_01_03';
dataFilename{1} = fullfile(magDir,'Capture 6_XY1514997239_Z0_1in5fix.mat');
imagesFilename{1} = fullfile(magDir,'centering with waves - flattened.tif');
MovieFilename{1} = fullfile(magDir,'centering with waves - with graph.mp4');
dataFilename{2} = fullfile(magDir,'Capture 9_XY1514999422_Z0_interp3.mat');
imagesFilename{2} = fullfile(magDir,'recentering after network reorganization - flattened magenta.tif');
MovieFilename{2} = fullfile(magDir,'recentering after network reorganization - with graph magenta.mp4');
Xoffset(1) = 215-512;
Xoffset(2) = 295-512;
timeSep(1) = 1;
timeSep(2) = 2;
slowFrames{1} = 7:52;
slowFrames{2} = 8:91;
for i=1:2
    launch_MakeMovieWithGraph2(dataFilename{i}, imagesFilename{i}, MovieFilename{i}, timeSep(i), slowFrames{i},Xoffset(i));
end

% centering with graph

%  ---- actin symmetry breaking ----  %
MovieArray = images2mp4('Y:\symmetry breaking movie\green movie annotated.tif');