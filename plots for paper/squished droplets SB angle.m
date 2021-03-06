DIR = 'Z:\analysis\Niv\symmetry breaking statistics\30um\2018_09_02\';
filenameRegexp = 'Capture 1 - Position *_C0.mat';
dataFiles = ls(fullfile(DIR,filenameRegexp));
for i = 1:size(dataFiles,1)
    data = load(fullfile(DIR,dataFiles(i,:)));
    dropsStruct(i,1:4) = data.droplets;
    CCData(i) = smooth_data(dropsStruct(i,1:4), -1, 1,3, 1, 3, -1);
end

BV = blob_vectors(dropsStruct);
ind60 = round([BV.time]./60,-1) == 60;
BV60 = BV(ind60);
RTP = [BV60.blobRThetaPhi];
XYZ = [BV60.blobVec];
displacement = sqrt(XYZ(1,:).^2 + XYZ(2,:).^2);
z = XYZ(3,:);
dropRadius = [BV60.dropR];
aggRadius = [BV60.aggR];
figure; scatter(dropRadius(end,:)*2, displacement(end,:));
xlabel('Droplet Diameter');
ylabel('xy Displacment');
zError = [CCData.Zcalibration];
hold on
plot(dropRadius(end,:)*2, dropRadius(end,:)*0.75);

% figure; errorbar(dropRadius(end,:)*2, z(end,:), zError ,'o');
% xlabel('Droplet Diameter');
% ylabel('z Displacment');
% hold on;
% % R0 = (3/(4^4)*30*dropRadius(end,:).^2).^(1/3);
% % R0 = 0.17 * dropRadius(end,:);
% R0 = aggRadius(end,:);
% [Rsort,I] = sort(dropRadius);
% plot(Rsort(end,:)*2, 15 - R0(I));
% plot(Rsort(end,:)*2, -15 + R0(I));

angle = atan2(z, displacement);
figure; scatter(dropRadius(end,:)*2, angle(end,:));
ax = gca;
ylim([-pi/2, pi/2]);
ax.YTick = [-pi/2, -pi/4, 0, pi/4, pi/2];
ax.YTickLabel = {'$-\frac{1}{2}\pi$', '$-\frac{1}{4}\pi$', '0', '$\frac{1}{4}\pi$', '$\frac{1}{2}\pi$'};
ax.TickLabelInterpreter = 'latex';
xlabel('Droplet Diameter');
ylabel('Displacement angle');

Dnorm = displacement(end,:)./(dropRadius(end,:) - R0);
Znorm = max(-1,min(1, z(end,:)'./(15 - R0')));
figure; h = scatter(Dnorm, Znorm');
axis equal
axis([0, 1, -1, 1])
xlabel('Normalized xy displacement');
ylabel('Normalized z displacement');


figure; errorbar(displacement(end,:), z(end,:), zError ,'o');
axis equal
axis([0, 25, -18, 18])
xlabel('xy displacement');
ylabel('z displacement');

% figure; h = scatter(displacement(end,:), z(end,:));
% axis equal
% 
% a = 2*;
% ax = gca;
% currentunits=ax.Units;
% ax.Units='Points';
% axpos=ax.Position;
% pba=ax.PlotBoxAspectRatio;
% ax.Units=currentunits;
% scale=min([axpos(3),pba(1)/pba(2)*axpos(4)])/diff(xlim);
% markerwidth = a.*scale;
% set(h,'SizeData',markerwidth.^2);
