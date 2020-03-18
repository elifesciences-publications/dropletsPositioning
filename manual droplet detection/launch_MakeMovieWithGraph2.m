function Movie = launch_MakeMovieWithGraph2(dataFilename, imagesFilename, MovieFilename, timeSep, slowframes,Xoffset, Yoffset)
if ~exist('Xoffset','var')
    Xoffset = 0;
end
if ~exist('Yoffset','var')
    Yoffset = 0;
end
if ~exist('slowframes','var')
    slowframes = -1;
end

images = load_tiff_file(imagesFilename,1);
data = load(dataFilename);
droplets = data.droplets;
positions = reshape([droplets.dropletPosition],4,[]);
dropRadius = positions(3,:) * droplets(1).micronsPerPixel / 2;
AggPositions = reshape([droplets.aggregatePosition],4,[]);
dropInd(1,:) = (dropRadius == dropRadius(1));
dropInd(2,:) = (dropRadius == dropRadius(2));

offsetMatrix = zeros(size(positions));
offsetMatrix(1,:) = Xoffset;
offsetMatrix(2,:) = Yoffset;

positions = positions + offsetMatrix;
AggPositions = AggPositions + offsetMatrix;

for i=1:size(dropInd,1)
    ind = dropInd(i,:);
    dropletPosition{i} = positions(:,ind);
    aggregatePosition{i} = AggPositions(:,ind);
end

Movie = MakeMovieWithGraph2(images, dropletPosition, aggregatePosition, timeSep, false, 3,slowframes);
v = VideoWriter(MovieFilename,'MPEG-4');
v.FrameRate = 60;
open(v)
writeVideo(v,Movie)
close(v)