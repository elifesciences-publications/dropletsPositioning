function droplets = fixDropletsTimes(droplets, timediff, startOffset)
    if ~exist('startOffset', 'var')
        startOffset = 0;
    end
    for i = 1:numel(droplets)
        droplets(i).time = droplets(i).timepoint * timediff + startOffset;
    end
end