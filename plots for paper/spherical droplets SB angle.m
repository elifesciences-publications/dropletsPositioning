[DIR_S, FN_S] = getExperiment(1:4);
for i=1:length(DIR_S);
    DATA{i} = load(fullfile(DIR_S{i}, FN_S{i}));
    BV{i} = blob_vectors(DATA{i}.DATA.drops);
end
RTP=[];
XYZ=[];
dropRadius = [];
aggRadius = [];
zError = [];
for i=1:length(BV)
    RTP = [RTP,[BV{i}.blobRThetaPhi]];
	XYZ = [XYZ, [BV{i}.blobVec]];
    dropRadius = [dropRadius, BV{i}.dropR];
    vecError = [BV{i}.blobVecError];
    zError = [zError, (vecError(3,2:2:end) - vecError(3,1:2:end))/2];
end
aggRadius = dropRadius*0.2;
displacement = sqrt(XYZ(1,:).^2 + XYZ(2,:).^2);
z = XYZ(3,:);
figure; scatter(dropRadius(end,:)*2, displacement(end,:));
xlabel('Droplet Diameter');
ylabel('xy Displacment');
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

Dnorm = displacement(end,:)./(dropRadius(end,:) - aggRadius);
Znorm = max(-1,min(1, z(end,:)'./(15 - aggRadius')));
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
% a = 2*R0;
% ax = gca;
% currentunits=ax.Units;
% ax.Units='Points';
% axpos=ax.Position;
% pba=ax.PlotBoxAspectRatio;
% ax.Units=currentunits;
% scale=min([axpos(3),pba(1)/pba(2)*axpos(4)])/diff(xlim);
% markerwidth = a.*scale;
% set(h,'SizeData',markerwidth.^2);
