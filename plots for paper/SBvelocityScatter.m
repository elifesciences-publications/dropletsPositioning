figure;
hold on
for Dc = {CCDATA(indsC), SDATA, SBDATA}
D = Dc{:};
% D = SDATA;
% D = CCDATA(indsC);
% D = SBDATA;
radiuses = arrayfun(@(C) C.dropRadius,D,'UniformOutput',false);
r = horzcat(radiuses{:});
displacements = arrayfun(@(C) C.Orig.r,D,'UniformOutput',false);
d = horzcat(displacements{:});
velocities = arrayfun(@(C) C.Orig.Vr,D,'UniformOutput',false);
v = horzcat(velocities{:});

% velocities = ma(ind).getVelocities;
% velocitiesArray = vertcat(velocities{:});
% 
% tracks = ma(ind).tracks;
% tracksTruncated = cellfun(@(track) track(1:end-1,:),tracks,'UniformOutput',false);
% positionsArray = vertcat(tracksTruncated{:});
% 
% r = cellfun(@(r) r(:,1:end-1),{SBDATA.dropRadius},'UniformOutput',false);
% r = horzcat(r{:});
% d = sqrt(sum(positionsArray(:,2:4).^2,2));
% v = sqrt(sum(velocitiesArray(:,2:4).^2,2));
% figure;
scatter(d,v,100,'.');
[dSorted, sortInd] = sort(d);
VrSorted = v(sortInd);
VrSmooth = smooth(VrSorted,30);
hold on;
plot(dSorted, VrSmooth);
ylim([-5,10]);
% figure; scatter(r,v);

% xlim([0,30]);
% ylim([0,10]);
% figure; scatter(r-d,v);
% figure; histogram(v,0:0.5:12);
end
