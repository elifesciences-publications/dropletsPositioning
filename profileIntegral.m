calibration = 0.833333;
timeSep = 2;
startFromTimePoint = 92;

magDir = 'Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_01_03';
dataFilename = fullfile(magDir,'Capture 9_XY1514999422_Z0_interp3.mat');
data = load(dataFilename);
droplets = data.droplets;
positions = reshape([droplets.dropletPosition],4,[]);
dropRadius = positions(3,:) * droplets(1).micronsPerPixel / 2;
AggPositions = reshape([droplets.aggregatePosition],4,[]);
dropInd = (dropRadius == dropRadius(1));

dropletPosition = positions(:,dropInd);
aggregatePosition = AggPositions(:,dropInd);

Xdroplet = ceil(dropletPosition(1,:)+(dropletPosition(3,:)/2));
Ydroplet = ceil(dropletPosition(2,:)+(dropletPosition(4,:)/2));
Xaggregate = ceil(aggregatePosition(1,:)+(aggregatePosition(3,:)/2));
Yaggregate = ceil(aggregatePosition(2,:)+(aggregatePosition(4,:)/2));
Rdroplet = dropletPosition(3,:)/2;
Ragg = mean(aggregatePosition(3:4,:))/2;
D = sqrt((Xaggregate-Xdroplet).^2 + (Yaggregate-Ydroplet).^2) * calibration;
Dcut = D(startFromTimePoint:end);
span1 = 55;
span2 = 55;
Scut = 10;
smoothD = smooth(Dcut,span1);
smoothDcut = smoothD(Scut:end);
V = diff(smoothDcut)*60/timeSep;
Vsmooth = smooth(V,span2);
time = ((1:length(Vsmooth)) + startFromTimePoint + Scut) * timeSep / 60;


profile = dlmread('Z:\analysis\Niv\magnetic beads\magnetic beads in capillary\spinning disk\2018_01_03\actin profile3.txt');
profileCut = profile((startFromTimePoint+Scut):end,:);
profileFlat = ones(size(profileCut));

intLeft = zeros(1,size(profileCut,1));
intRight = zeros(size(intLeft));
for t=1:size(profileCut,1)
    line = profileCut(t,:);
    [pks,locs,w,p] = findpeaks(line);
    [pSort, Ind] =  sort(p,'descend');
    realLocs = locs(Ind(1:2));
    realW = w(Ind(1:2));
    realPks = pks(Ind(1:2));
    [RLS, Ind2] = sort(realLocs);
    RWS = realW(Ind2);
    cutLeft = round(RLS(1)-1);
    cutRight = round(RLS(2)+1);
    rLeft = ((cutLeft:-1:1));
    rRight = ((1:(length(line)-cutRight+1)));
    dLeft = (rLeft+(cutRight-cutLeft)/2);
    dRight = (rRight+(cutRight-cutLeft)/2);
    fRight = sqrt(Rdroplet(t)^2 - (dRight - D(t)).^2);
    fLeft = sqrt(Rdroplet(t)^2 - (dLeft + D(t)).^2);
    fRight(find(angle(fRight))) = 0;
    fLeft(find(angle(fLeft))) = 0;
    cRight = cos(atan(fRight./dRight));
    cLeft = cos(atan(fLeft./dLeft));
%     intLeft(t) = sum(profileFlat(t,1:cutLeft).*fLeft.^2);%.*cLeft);%.*rLeft);
%     intRight(t) = sum(profileFlat(t,cutRight:end).*fRight.^2);%.*cRight);%.*rRight);
    intLeft(t) = sum(line(1:cutLeft).*fLeft.^2.*cLeft.*rLeft);
    intRight(t) = sum(line(cutRight:end).*fRight.^2.*cRight.*rRight);

end
asym = intRight - intLeft;
smoothAsym = smooth(asym, 31);
diffAsym = abs(asym - smoothAsym');
indOut = find(diffAsym > (max(asym)-min(asym))/3);
asymClean = asym;
asymClean(indOut) = [];
indices = 1:length(asym);
indices(indOut) = [];
interpAsym = interp1(indices, asymClean, indOut);
asym(indOut) = interpAsym;

asymNormalized = asym/max(asym) * max(-V);
% time = ((1:length(Dcut)) + startFromTimePoint +) * timeSep;
% timeP = ((1:length(diffNormalized))+ startFromTimePoint) * timeSep;
% time = ((1:length(V)) + startFromTimePoint + span1) * timeSep / 60;
figure; plot(smoothDcut(2:end),smooth(-V,span2))
Fig = figure('Position',[100 100 500 300]);
% plot(time, Dcut, 'LineWidth',1);
span2 = 55;
plot(time, smooth(-V,span2), 'LineWidth',2)
hold on
plot(time, smooth(asymNormalized,11), 'LineWidth',2);
% ylim([min(asymNormalized),max(asymNormalized)]);
xlim(time([1,end]));

legend('velocity', 'Network Asymmetry [a.u.]' );
xlabel('Time [min]');
ylabel('Velocity [$\frac{{\mu}m}{min}$]','Interpreter','Latex');
Fig.PaperPositionMode = 'auto';
% print(Fig,fullfile(magDir,'net assymetry.eps'),'-depsc');
% intDiff = cumsum(diff);
% figure; plot(diff)
% figure; plot(-intDiff)
 

% threshold = 1e5;
% for t=1:size(profile,1)
%     line = profile(t,:);
%     cutLeft = find(line > threshold, 1,'first');
%     cutRight = find(line > threshold, 1,'last');
%     dLeft = (cutLeft:-1:1).^3;
%     dRight = (1:(length(line)-cutRight+1)).^3;
%     intLeft(t) = sum(line(1:cutLeft).*dLeft);
%     intRight(t) = sum(line(cutRight:end).*dRight);
% end
% diff1 = intRight - intLeft;
% figure; plot(diff1)


% for t=1:size(profile,1)
%     line = profile(t,:);
%     [pks,locs,w,p] = findpeaks(line);
%     [pSort, Ind] =  sort(p,'descend');
%     if Ind(1) > Ind(2)
%         cutLeft = locs(Ind(2));
%         cutRight = find(line > pks(Ind(2)), 1,'last');
%     else
%         cutLeft = find(line > pks(Ind(2)), 1,'first');
%         cutRight = locs(Ind(2));
%     end
%     intLeft(t) = sum(line(1:cutLeft));
%     intRight(t) = sum(line(cutRight:end));
% end
% diff3 = intRight - intLeft;
% figure; plot(diff3-mean(diff3(500:end)))
