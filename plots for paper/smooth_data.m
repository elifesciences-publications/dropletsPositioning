function CCData = smooth_data(droplets, timeSep, order, framelen, vorder, vframelen, magnetOff)
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
    CCData = smooth_data_P2(dropX, dropY, dropZ, dropR, aggX, aggY, aggZ, aggR, calibration, Zcal, timepoints, timeSep, times, order, framelen, vorder, vframelen, magnetOff);
end
% calibration = droplets(1).micronsPerPixel;
% CCData.timeSep = timeSep;
% CCData.calibration = calibration;
% % seperate timepoints positions by columns
% % dropletPosition = reshape([droplets.dropletPosition],4,[]);
% % CCData.dropRadius = dropletPosition(3,1) * calibration / 2;
%
% [CCData.Xdroplet, CCData.Ydroplet, dRadius] = positionsToCR([droplets.dropletPosition]);
% CCData.dropRadius = dRadius(1) * calibration;
% [CCData.Xaggregate, CCData.Yaggregate, aRadius] = positionsToCR([droplets.aggregatePosition]);
% CCData.aggRadius = aRadius(1) * calibration;
%
% % aggregatePosition = reshape([droplets.aggregatePosition],4,[]);
% % CCData.aggRadius = (aggregatePosition(3,1) + aggregatePosition(4,1)) * calibration / 4;
%
% % CCData.Xdroplet = dropletPosition(1,:)+(dropletPosition(3,:)/2);
% % CCData.Ydroplet = dropletPosition(2,:)+(dropletPosition(4,:)/2);
% % CCData.Xaggregate = aggregatePosition(1,:)+(aggregatePosition(3,:)/2);
% % CCData.Yaggregate = aggregatePosition(2,:)+(aggregatePosition(4,:)/2);
% CCData.XdropletSmooth = [savitzkyGolayFilt(CCData.Xdroplet(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Xdroplet(magnetOff:end), order, 0, framelen(2))];
% CCData.YdropletSmooth = [savitzkyGolayFilt(CCData.Ydroplet(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Ydroplet(magnetOff:end), order, 0, framelen(2))];
% CCData.XaggregateSmooth = [savitzkyGolayFilt(CCData.Xaggregate(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Xaggregate(magnetOff:end), order, 0, framelen(2))];
% CCData.YaggregateSmooth = [savitzkyGolayFilt(CCData.Yaggregate(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Yaggregate(magnetOff:end), order, 0, framelen(2))];
%
% CCData.Orig.X = -(CCData.Xaggregate - CCData.Xdroplet) * calibration;
% CCData.Orig.Y = -(CCData.Yaggregate - CCData.Ydroplet) * calibration;
%
% CCData.Orig.Xsmooth = [savitzkyGolayFilt(CCData.Orig.X(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Orig.X(magnetOff:end), order, 0, framelen(2))];
% CCData.Orig.Ysmooth = [savitzkyGolayFilt(CCData.Orig.Y(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Orig.Y(magnetOff:end), order, 0, framelen(2))];
%
% CCData.Orig.Vx = [savitzkyGolayFilt(CCData.Orig.X(1:(magnetOff -1)), order, 1, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Orig.X(magnetOff:end), order, 1, framelen(2))] * 60/timeSep;
% CCData.Orig.Vy = [savitzkyGolayFilt(CCData.Orig.Y(1:(magnetOff -1)), order, 1, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Orig.Y(magnetOff:end), order, 1, framelen(2))] * 60/timeSep;
%
% CCData.Orig.VxSmooth = [savitzkyGolayFilt(CCData.Orig.Vx(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Orig.Vx(magnetOff:end), order, 0, framelen(2))];
% CCData.Orig.VySmooth = [savitzkyGolayFilt(CCData.Orig.Vy(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Orig.Vy(magnetOff:end), order, 0, framelen(2))];
%
% CCData.Orig.R = sqrt(CCData.Orig.X.^2 + CCData.Orig.Y.^2);
% CCData.Orig.Rsmooth = [savitzkyGolayFilt(CCData.Orig.R(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Orig.R(magnetOff:end), order, 0, framelen(2))];
% CCData.Orig.Vr = [savitzkyGolayFilt(CCData.Orig.R(1:(magnetOff -1)),order, 1, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Orig.R(magnetOff:end),order, 1, framelen(2))] * 60/timeSep;
% CCData.Orig.VrSmooth = [savitzkyGolayFilt(CCData.Orig.Vr(1:(magnetOff -1)),order,0,framelen(1)), ...
%     savitzkyGolayFilt(CCData.Orig.Vr(magnetOff:end),order,0,framelen(2))];
%
% % [~,M] = max(abs(CCData.Orig.Xsmooth));
% % maxPosFrame = M;
%
% CCData.Theta = atan2(CCData.Orig.Ysmooth(magnetOff) - CCData.Orig.Ysmooth(end), CCData.Orig.Xsmooth(magnetOff) - CCData.Orig.Xsmooth(end));
%
% CCData.Rot.X = CCData.Orig.X*cos(CCData.Theta) + CCData.Orig.Y*sin(CCData.Theta);
% CCData.Rot.Y = CCData.Orig.Y*cos(CCData.Theta) - CCData.Orig.X*sin(CCData.Theta);
%
% CCData.Rot.Xsmooth = [savitzkyGolayFilt(CCData.Rot.X(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Rot.X(magnetOff:end), order, 0, framelen(2))];
% CCData.Rot.Ysmooth = [savitzkyGolayFilt(CCData.Rot.Y(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Rot.Y(magnetOff:end), order, 0, framelen(2))];
%
% CCData.Rot.Vx = [savitzkyGolayFilt(CCData.Rot.X(1:(magnetOff -1)), order, 1, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Rot.X(magnetOff:end), order, 1, framelen(2))] * 60/timeSep;
% CCData.Rot.Vy = [savitzkyGolayFilt(CCData.Rot.Y(1:(magnetOff -1)), order, 1, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Rot.Y(magnetOff:end), order, 1, framelen(2))] * 60/timeSep;
%
% CCData.Rot.VxSmooth = [savitzkyGolayFilt(CCData.Rot.Vx(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Rot.Vx(magnetOff:end), order, 0, framelen(2))];
% CCData.Rot.VySmooth = [savitzkyGolayFilt(CCData.Rot.Vy(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Rot.Vy(magnetOff:end), order, 0, framelen(2))];
%
% CCData.Rot.R = sqrt(CCData.Rot.X.^2 + CCData.Rot.Y.^2);
% CCData.Rot.Rsmooth = [savitzkyGolayFilt(CCData.Rot.R(1:(magnetOff -1)), order, 0, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Rot.R(magnetOff:end), order, 0, framelen(2))];
% CCData.Rot.Vr = [savitzkyGolayFilt(CCData.Rot.R(1:(magnetOff -1)),order, 1, framelen(1)), ...
%     savitzkyGolayFilt(CCData.Rot.R(magnetOff:end),order, 1, framelen(2))] * 60/timeSep;
% CCData.Rot.VrSmooth = [savitzkyGolayFilt(CCData.Rot.Vr(1:(magnetOff -1)),order,0,framelen(1)), ...
%     savitzkyGolayFilt(CCData.Rot.Vr(magnetOff:end),order,0,framelen(2))];