DIR = 'W:\phkinnerets\storage\analysis\Niv\tracking\2018_05_16';
filename_regexp = '*Position 1*_C0.tiff';
filename_regexp = '*Position 2*_C0.tiff';
clear filenames images;
fs = ls(fullfile(DIR,filename_regexp));
for i=1:size(fs,1)
    filenames{i} = fullfile(DIR,fs(i,:));
    images{i} = load_tiff_file(filenames{i},1);
end
one_position_gui_obj(filenames, images)
%%
mfs = ls(fullfile(DIR, 'Capture 2 - Position 1_Z0_plane*.mat'));
mfs = ls(fullfile(DIR, 'Capture 2 - Position 2_Z0_plane*.mat'));
mfs = ls(fullfile(DIR, 'Capture 2 - Position 2_Z0.mat'));

for i=1:size(mfs,1)
    data{i} = load(fullfile(DIR,mfs(i,:)));
end
%%
Fig(1) = figure;
Fig(2) = figure;
firstPlane = 1; %2;
lastPlane = 4; %5;
allSizes = zeros(lastPlane - firstPlane + 1, length(images));
allX = zeros(lastPlane - firstPlane + 1, length(images));
allY = zeros(lastPlane - firstPlane + 1, length(images));
for i=1:length(data)
    timepoints = [data{i}.droplets.timepoint];
    y = ones(size(timepoints))*(i + firstPlane - 1);
%     positions = reshape([data{i}.droplets.aggregatePosition],4,[]);
%     sizes = (positions(3,:) + positions(4,:))/4;
%     X = positions(1,:) + positions(3,:)/2;
%     Y = positions(2,:) + positions(4,:)/2;
    [X, Y, sizes] = positionsToCR([data{i}.droplets.aggregatePosition]);
    allSizes(i,timepoints) = sizes;
    allX(i,timepoints) = X;
    allY(i,timepoints) = Y;
    figure(Fig(1));
    scatter(timepoints, y, (sizes - 35).^2);
    hold on
    figure(Fig(2));
    scatter(timepoints, sizes);
    hold on
end
%%
minR = min(allSizes(allSizes>0));
normSizes = max(0, allSizes - floor(minR));
% normSizes = allSizes;
weights = normSizes./repmat(sum(normSizes), lastPlane - firstPlane + 1,1);
planesMatrix = (repmat(firstPlane:lastPlane,length(images),1))';
planeInterp = sum(weights.*planesMatrix);
XInterp = sum(weights.*allX);
YInterp = sum(weights.*allY);
figure; plot(planeInterp);
hold on
plot(round(planeInterp));
planeInerpSmooth = savitzkyGolayFilt(planeInterp,1,0,15);
figure; plot(planeInerpSmooth)
[dX, dY, dR] = positionsToCR([data{1}.droplets(1).dropletPosition]);

dropX = ones(size(XInterp)) * dX;
dropY = ones(size(XInterp)) * dY;
dropR =  ones(size(XInterp)) * dR;
% deltaZ = (planeInterp - 3) * data{1}.droplets(1).micronsPerPlane;
drpletPlane = 4; %3;
deltaZ = (planeInerpSmooth - drpletPlane) * data{1}.droplets(1).micronsPerPlane;

calibration = data{1}.droplets(1).micronsPerPixel;
timeSep = 30;
% CCDATA = smooth_data_P(dropX(1:80), dropY(1:80), dropR(1:80), XInterp(1:80), YInterp(1:80), max(allSizes(:,1:80)/2), deltaZ(1:80), calibration, timeSep, 1, [3,35], -1);
CCDATA = smooth_data_P(dropX, dropY, dropR, XInterp, YInterp, max(allSizes), deltaZ, calibration, timeSep, 1, [3,35], -1);

imAll = [images{:}];
img = imAll(3:5:end);
%%
Movie = MakeMovieWithGraph3(img, CCDATA, -1, false, 1, -1);
MovieFilename = fullfile(DIR,'Movie1.mp4');
    v = VideoWriter(MovieFilename,'MPEG-4');

    v.FrameRate = 10;
    open(v)
    writeVideo(v,Movie)
    close(v)

