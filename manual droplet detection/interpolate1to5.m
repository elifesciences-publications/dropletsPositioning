data = load(fLoad1in5);
droplets = data.droplets;
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
fLoad1in5fix2 = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_01_03\Capture 6_XY1514997239_Z0_1in5fix2.mat'
save(fLoad1in5fix2,'droplets','-v7.3');