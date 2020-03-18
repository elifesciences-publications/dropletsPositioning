% ---- tracking ---- %
DIR_CEN1 = getExperiment(15);
% plot_movement_xy2(DIR_CEN1,1,[0.5,-0.5],10);
DIR_BREAK2 = getExperiment(14);
% plot_movement_xy2(DIR_BREAK2,1,[0,0],10)
plot_movement_xy2([DIR_CEN1;DIR_BREAK2],1,[0,0],10);

% ---- displacement ---- %
% standard
[DIR_S, ~] = getExperiment(1:4);
scatter_displacement(DIR_S',1,[60,50;85,50]);
hist_symbreaking(DIR_S',[0,60;60,85;85,130])

%time with averageing
[DIR_T, ~] = getExperiment([19,23,27]);
scatter_displacement2(DIR_T,3);

% ---- magnets ---- %
% centering with graph
magnet_recentering_tiff = 'Z:\analysis\Niv\magnetic beads\magnetic tweezers - erez lab\Niv\2017_06_15\dynabeads\mix1 sample1 11_22 _4\cropped with flatten annotations short.tif';
Movie = MakeMovieWithGraph(magnet_recentering_tiff,[5,5,5,5,10,10],1:6);
% symmetry breaking
magnet_symbreaking_tiff = 'Z:\analysis\Niv\magnetic beads\magnetic tweezers - erez lab\Niv\2017_06_07\dynabeads\mix1 sample2 18_45 _3\magnet recoil and symbreaking_movie_annotated.tif';
MovieArray = images2mp4(magnet_symbreaking_tiff);

%  ---- actin symmetry breaking ----  %
MovieArray = images2mp4('Y:\symmetry breaking movie\green movie annotated.tif');