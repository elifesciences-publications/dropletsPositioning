function CCData = smooth_data(droplets, timeSep, order, framelen)
if ~exist('timeSep','var')
    timeSep = 2; %sec
end
calibration = droplets(1).micronsPerPixel;
CCData.timeSep = timeSep;
CCData.calibration = calibration;
droplets = 
% seperate timepoints positions by columns
dropletPosition = reshape([droplets.dropletPosition],4,[]);
dropRadius = dropletPosition(3,1) * calibration / 2;
aggregatePosition = reshape([droplets.aggregatePosition],4,[]);

Xdroplet = dropletPosition(1,:)+(dropletPosition(3,:)/2);
Ydroplet = dropletPosition(2,:)+(dropletPosition(4,:)/2);
Xaggregate = aggregatePosition(1,:)+(aggregatePosition(3,:)/2);
Yaggregate = aggregatePosition(2,:)+(aggregatePosition(4,:)/2);
Rdroplet = dropletPosition(3,:)/2;

CCData.Orig.X = -(Xaggregate - Xdroplet) * calibration;
CCData.Orig.Y = -(Yaggregate - Ydroplet) * calibration;

CCData.Orig.Xsmooth = savitzkyGolayFilt(CCData.Orig.X,order,0,framelen);
CCData.Orig.Ysmooth = savitzkyGolayFilt(CCData.Orig.Y,order,0,framelen);

CCData.Orig.Vx = savitzkyGolayFilt(CCData.Orig.X,order,1,framelen)*60/timeSep;
CCData.Orig.Vy = savitzkyGolayFilt(CCData.Orig.Y,order,1,framelen)*60/timeSep;

CCData.Orig.VxSmooth = savitzkyGolayFilt(CCData.Orig.Vx,order,0,framelen);
CCData.Orig.VySmooth = savitzkyGolayFilt(CCData.Orig.Vy,order,0,framelen);

CCData.Orig.R = sqrt(CCData.Orig.X.^2 + CCData.Orig.Y.^2);
CCData.Orig.Rsmooth = savitzkyGolayFilt(CCData.Orig.R,order,0,framelen);
CCData.Orig.Vr = savitzkyGolayFilt(CCData.Orig.R,order,1,framelen)*60/timeSep;
CCData.Orig.VrSmooth = savitzkyGolayFilt(CCData.Orig.Vr,order,0,framelen);

[~,M] = max(abs(CCData.Orig.Xsmooth));
maxPosFrame = M;

CCData.Theta = atan2(CCData.Orig.Ysmooth(maxPosFrame) - CCData.Orig.Ysmooth(end), CCData.Orig.Xsmooth(maxPosFrame) - CCData.Orig.Xsmooth(end));

CCData.Rot.X = CCData.Orig.X*cos(CCData.Theta) + CCData.Orig.Y*sin(CCData.Theta);
CCData.Rot.Y = CCData.Orig.Y*cos(CCData.Theta) - CCData.Orig.X*sin(CCData.Theta);

CCData.Rot.Xsmooth = savitzkyGolayFilt(CCData.Rot.X,order,0,framelen);
CCData.Rot.Ysmooth = savitzkyGolayFilt(CCData.Rot.Y,order,0,framelen);

CCData.Rot.Vx = savitzkyGolayFilt(CCData.Rot.X,order,1,framelen)*60/timeSep;
CCData.Rot.Vy = savitzkyGolayFilt(CCData.Rot.Y,order,1,framelen)*60/timeSep;

CCData.Rot.VxSmooth = savitzkyGolayFilt(CCData.Rot.Vx,order,0,framelen);
CCData.Rot.VySmooth = savitzkyGolayFilt(CCData.Rot.Vy,order,0,framelen);

CCData.Rot.R = sqrt(CCData.Rot.X.^2 + CCData.Rot.Y.^2);
CCData.Rot.Rsmooth = savitzkyGolayFilt(CCData.Rot.R,order,0,framelen);
CCData.Rot.Vr = savitzkyGolayFilt(CCData.Rot.R,order,1,framelen)*60/timeSep;
CCData.Rot.VrSmooth = savitzkyGolayFilt(CCData.Rot.Vr,order,0,framelen);
