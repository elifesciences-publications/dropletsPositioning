function CCData = smooth_data_P(dropX, dropY, dropZ, dropRadius, aggX, aggY, aggZ, aggRadius, calibration, Zcal, timeSep, times, order, framelen, vorder, vframelen, magnetOff)
    if numel(framelen) < 2
        framelen(2) = framelen(1);
    end
    CCData.timeSep = timeSep;
    CCData.times = times;
    CCData.calibration = calibration;
    CCData.Zcalibration = Zcal;

    CCData.Xdroplet = dropX;
    CCData.Ydroplet = dropY;
    CCData.Zdroplet = dropZ;
    CCData.dropRadius = dropRadius * calibration;
    CCData.Xaggregate = aggX;
    CCData.Yaggregate = aggY;
    CCData.Zaggregate = aggZ;
    CCData.aggRadius = aggRadius * calibration;
    divideByTimeSep = diff(times);
    divideByTimeSep(end+1) = timeSep; % SavitkyGolay returns N elements, need to add one here;
    Fnames = {'Xdroplet', 'Ydroplet', 'Zdroplet', 'Xaggregate', 'Yaggregate', 'Zaggregate'};
    for i = 1:length(Fnames)
        f = Fnames{i};
        fSmooth = [f,'Smooth'];
        data = CCData.(f);
        CCData.(fSmooth) = doSmooth(data, order, 0, framelen, magnetOff);
    end
    
    CCData.Orig.x = -(CCData.Xaggregate - CCData.Xdroplet) * calibration;
    CCData.Orig.y = -(CCData.Yaggregate - CCData.Ydroplet) * calibration;
    CCData.Orig.z = (CCData.Zaggregate - CCData.Zdroplet) * Zcal;
    CCData.Orig.r2d = sqrt(CCData.Orig.x.^2 + CCData.Orig.y.^2);
    CCData.Orig.r = sqrt(CCData.Orig.x.^2 + CCData.Orig.y.^2 +  CCData.Orig.z.^2);
    
    Fnames = fieldnames(CCData.Orig);
    for i = 1:length(Fnames)
        f = Fnames{i};
        Vf = ['V',f];
        data = CCData.Orig.(f);
        CCData.Orig.(Vf) = -doV(data, vorder, vframelen, magnetOff) * 60./divideByTimeSep; %/timeSep;
    end
    
    fieldNames = fieldnames(CCData.Orig);
    for i = 1:length(fieldNames)
        f = fieldNames{i};
        fSmooth = [f,'Smooth'];
        data = CCData.Orig.(f);
        CCData.Orig.(fSmooth) = doSmooth(data, order, 0, framelen, magnetOff);
    end
    if magnetOff > 1
        CCData.Theta = atan2(CCData.Orig.ySmooth(magnetOff) - CCData.Orig.ySmooth(end), CCData.Orig.xSmooth(magnetOff) - CCData.Orig.xSmooth(end));
        
        CCData.Rot.x = CCData.Orig.x*cos(CCData.Theta) + CCData.Orig.y*sin(CCData.Theta);
        CCData.Rot.y = CCData.Orig.y*cos(CCData.Theta) - CCData.Orig.x*sin(CCData.Theta);
        CCData.Rot.z = (CCData.Zaggregate - CCData.Zdroplet) * Zcal;
        CCData.Rot.r2d = sqrt(CCData.Rot.x.^2 + CCData.Rot.y.^2);
        CCData.Rot.r = sqrt(CCData.Rot.x.^2 + CCData.Rot.y.^2 + CCData.Rot.z.^2);
        
        Fnames = fieldnames(CCData.Rot);
        for i = 1:length(Fnames)
            f = Fnames{i};
            Vf = ['V',f];
            data = CCData.Rot.(f);
            CCData.Rot.(Vf) = -doV(data, vorder, vframelen, magnetOff) * 60./divideByTimeSep; %/timeSep;
        end
        
        fieldNames = fieldnames(CCData.Rot);
        for i = 1:length(fieldNames)
            f = fieldNames{i};
            fSmooth = [f,'Smooth'];
            data = CCData.Rot.(f);
            CCData.Rot.(fSmooth) = doSmooth(data, order, 0, framelen, magnetOff);
        end
    end
end
function smoothedData = doSmooth(data, order, dn, framelen, magnetOff)
    if magnetOff <= framelen(1)
        smoothedData = savitzkyGolayFilt(data, order, dn, framelen(1));
    else
        smoothedData = [savitzkyGolayFilt(data(1:(magnetOff -1)),order,dn,framelen(1)), ...
            savitzkyGolayFilt(data(magnetOff:end),order,dn,framelen(2))];
    end
end

function V = doV(data, vorder, vframelen, magnetOff)
    if magnetOff <= 5
        V = savitzkyGolayFilt(data, vorder, 1, vframelen);
%         VClean = removeOutliers(V);
    else
        V = [savitzkyGolayFilt(data(1:(magnetOff -1)), 1,1,vframelen), ...
            savitzkyGolayFilt(data(magnetOff:end), 1,1,vframelen)];
%         VClean = [removeOutliers(V(1:(magnetOff -1))),removeOutliers(V(magnetOff:end))];
    end
%     if ~isequal(V, VClean)
%         figure; hold on;
%         plot(V);
%         plot(VClean);
%     end
end

function dataClean = removeOutliers(data)
    dataClean = data;
    meanD = movmean(data,10);
    stdD = std(data);
    outliers = (abs(data - meanD) > 3*stdD);
    if ~isempty(find(outliers,1))
        data_noOutliers = data;
        data_noOutliers(outliers) = [];
        points = 1:length(data);
        interpPoints = points(outliers);
        points(outliers)=[];
        dataClean(outliers) = interp1(points, data_noOutliers, interpPoints,'linear', 'extrap');
    end
end

