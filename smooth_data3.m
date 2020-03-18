function CCData = smooth_data3(droplets, timeSep, order, framelen, vorder, vframelen, magnetOff)
    if numel(framelen) < 2
        framelen(2) = framelen(1);
    end
    calibration = droplets(1).micronsPerPixel;
    Zcal = droplets(1).micronsPerPlane;

    dropZ = [droplets.dropletPlane];
    if isfield(droplets, 'aggregatePlaneExact')
        aggZ = [droplets.aggregatePlaneExact];
    else
        aggZ = [droplets.aggregatePlane];
    end
    if timeSep <= 0
        timeSep = mean(diff([droplets.time]));
        times = [droplets.time];
    else
        times = 0:timeSep:((numel(droplets) - 1)*timeSep);
    end
    timepoints = [droplets.timepoint];
    [dropX, dropY, dropR] = positionsToCR([droplets.dropletPosition]);
    [aggX, aggY, aggR] = positionsToCR([droplets.aggregatePosition]);
    CCData = smooth_data_P3(dropX, dropY, dropZ, dropR, aggX, aggY, aggZ, aggR, calibration, Zcal, timepoints, timeSep, times, order, framelen, vorder, vframelen, magnetOff);
end