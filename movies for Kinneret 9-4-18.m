%% Symmetry breaking
%%
filenames = 'Z:\analysis\Niv\tracking\2018_08_05\mix2 sample1\Capture 1 - Position 5_C0.tiff';
dataFilename = 'Z:\analysis\Niv\tracking\2018_08_05\mix2 sample1\Capture 1 - Position 5_C0.mat';
outFilename = 'Z:\analysis\Niv\plots 3-9-18\tracking - symmetry breaking and centered droplets\movies\SymmetryBreaking1';
%%
filenames = 'Z:\analysis\Niv\tracking\2018_08_05\mix2 sample1\Capture 1 - Position 3_C0.tiff';
dataFilename = 'Z:\analysis\Niv\tracking\2018_08_05\mix2 sample1\Capture 1 - Position 3_C0.mat';
outFilename = 'Z:\analysis\Niv\plots 3-9-18\tracking - symmetry breaking and centered droplets\movies\SymmetryBreaking2';
%%
filenames = 'Z:\analysis\Niv\tracking\2018_08_02\mix1 sample1\Capture 2 - Position 2_C0.tiff';
dataFilename = 'Z:\analysis\Niv\tracking\2018_08_02\mix1 sample1\Capture 2 - Position 2_C0.mat';
outFilename = 'Z:\analysis\Niv\plots 3-9-18\tracking - symmetry breaking and centered droplets\movies\Centered1';
%%
filenames = 'Z:\analysis\Niv\tracking\2018_08_05\mix2 sample1\Capture 1 - Position 2_C0.tiff';
dataFilename = 'Z:\analysis\Niv\tracking\2018_08_05\mix2 sample1\Capture 1 - Position 2_C0.mat';
outFilename = 'Z:\analysis\Niv\plots 3-9-18\tracking - symmetry breaking and centered droplets\movies\Centered2';

%%

data = load(dataFilename);
timeSep = 30;
CCDATA = smooth_data(data.droplets, timeSep, 1, 5, 1, 3, -1);
[centers, radii] = positionsToCR([data.droplets.dropletPosition]);
Rmax = max(radii);
cropRect = [Rmax, Rmax]*2;
planesPositions = 0;

Fig = plot_tracks_xy_color(CCDATA,1,0,20, true);
print(Fig,[outFilename,'_track.eps'],'-depsc');
print(Fig,[outFilename,'_track.pdf'],'-dpdf');

images = load_tiff_file(filenames,1);
images = reshape(images,9,[]);
Movie = MakeMovieWithGraphs(images, CCDATA, false, [], cropRect, planesPositions, true, 1, -1, {'droplet','time','scale'});
MovieFilename = [outFilename,'.avi'];

% v = VideoWriter(MovieFilename,'MPEG-4');
v = VideoWriter(MovieFilename,'Motion JPEG AVI');
v.FrameRate = 10;
open(v)
writeVideo(v,Movie)
close(v)

fmeta = fopen([outFilename,'.txt'],'w');
    fprintf(fmeta, 'data: %s\r\nimage: %s', dataFilename, filenames);
fclose(fmeta);
%%
planesPositions = (-20:5:20) + ( data.droplets(1).dropletPlane - 5) * 5;
Movie = MakeMovieWithGraphs(images, CCDATA, false, [5 1 4], cropRect, planesPositions, true, 1, -1, {'droplet','time','scale','planes','size', 'aggregate'});
MovieFilename = [outFilename,'_with_plots.avi'];

% v = VideoWriter(MovieFilename,'MPEG-4');
v = VideoWriter(MovieFilename,'Motion JPEG AVI');
v.FrameRate = 10;
open(v)
writeVideo(v,Movie)
close(v);

%% magnets


