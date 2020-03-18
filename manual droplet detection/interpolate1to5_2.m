fLoad1in5 = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_01_03\Capture 9_XY1514999422_Z0_4.mat';
data = load(fLoad1in5);
droplets1in5 = data.droplets;
% droplets(1) = droplets1in5(1);
for i = 24:2:38
    droplets1in5(i).dropletPosition(1:2) = droplets1in5(40).dropletPosition(1:2);
end

for i = 27:2:length(droplets1in5)
    droplets1in5(i).dropletPosition(1:2) = droplets1in5(25).dropletPosition(1:2);
end

for i=1:2:length(droplets1in5)
    for j=1:2:10
        k = floor(i/2)*10 + j;
        frac = (j-1)/10;
        droplets(k) = droplets1in5(i);
        droplets(k+1) = droplets1in5(i+1);
        if (i + 3) >= length(droplets1in5)
            droplets(k).dropletPosition = droplets1in5(i).dropletPosition;
            droplets(k).aggregatePosition = droplets1in5(i).aggregatePosition;
            droplets(k+1).dropletPosition = droplets1in5(i+1).dropletPosition;
            droplets(k+1).aggregatePosition = droplets1in5(i+1).aggregatePosition;
        else
        droplets(k).dropletPosition = droplets1in5(i).dropletPosition * (1-frac)...
            + droplets1in5(i+2).dropletPosition * frac;
        droplets(k).aggregatePosition = droplets1in5(i).aggregatePosition * (1-frac)...
            + droplets1in5(i+2).aggregatePosition * frac;
        droplets(k+1).dropletPosition = droplets1in5(i+1).dropletPosition * (1-frac)...
            + droplets1in5(i+3).dropletPosition * frac;
        droplets(k+1).aggregatePosition = droplets1in5(i+1).aggregatePosition * (1-frac)...
            + droplets1in5(i+3).aggregatePosition * frac;
        end
    end
end

for i=1:2:length(droplets)
    j=floor((i-1)/10)*10 + 1;
    if i>j
        if j+11 <= length(droplets)
            droplets(i).aggregatePosition = droplets(j).aggregatePosition * (1-(i-j)/10) + droplets(j+10).aggregatePosition * ((i-j)/10);
            droplets(i+1).aggregatePosition = droplets(j+1).aggregatePosition * (1-(i-j)/10) + droplets(j+11).aggregatePosition * ((i-j)/10);
        else
            droplets(i).aggregatePosition = droplets(j).aggregatePosition;
            droplets(i+1).aggregatePosition = droplets(j+1).aggregatePosition;
        end
    end
    droplets(i).time = droplets(i).timepoint;
    droplets(i+1).time = droplets(i+1).timepoint;
end
fLoad1in5fix2 = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_01_03\Capture 9_XY1514999422_Z0_interp4.mat';
save(fLoad1in5fix2,'droplets','-v7.3');