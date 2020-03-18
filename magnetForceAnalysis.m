filename = 'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\beads in water\2019_03_03\Capture 3';
frames = 31:51;

% filename = 'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\beads in water\2019_03_03\Capture 4';
% frames = 140:206;
% 
[tr, magnetPos, calibration, images, roiPos] = beadsTracking(filename, frames);
tracksForMsdAnalyzer = cellfun(@(x) x(:,1:3),tr,'UniformOutput',false);
ma = msdanalyzer(2, 'µm', 'sec');
ma = ma.addAll(tracksForMsdAnalyzer);
S = size(images(:,:,1));
FigTracks = figure('Position',[100 100 250 250]);
iMin = max(1, round(roiPos(2)));
iMax = min(S(1), round(roiPos(2) + roiPos(4)));
jMin = max(1, round(roiPos(1)));
jMax = min(S(2), round(roiPos(1) + roiPos(3)));
im = imshow(min(images(iMin:iMax,:,frames),[],3), 'XData', [0,511*calibration], 'YData', [0,(iMax-iMin)*calibration]);
hold on; ma.plotTracks
scatter(magnetPos(1), magnetPos(2), 100,'.')
velocities = ma.getVelocities;
Xall = []; Yall = []; Uall = []; Vall = []; Sall = []; Lall = [];
for i=1:numel(ma.tracks)
    for t = 1:size(tr{i},1)
        X = tr{i}(:,2);
        Y = tr{i}(:,3);
        U = velocities{i}(:,2);
        V = velocities{i}(:,3);
        S = tr{i}(:,4);
        L = tr{i}(:,5);
        Sall = [Sall; S(1:end-1)];
        Lall = [Lall; L(1:end-1)];
        Xall = [Xall; X(1:end-1)];
        Yall = [Yall; Y(1:end-1)];
        Uall = [Uall; U];
        Vall = [Vall; V];
    end
end

absV = sqrt(Uall.^2 + Vall.^2);
distance = sqrt((Xall - magnetPos(1)).^2 + (Yall - magnetPos(2)).^2);

FigV = figure('Position',[100 100 400 300]);
scatter(distance,absV,40,Lall,'.');
colormap jet;
cBar = colorbar;
cBar.Label.String = 'Length [um]';
xlabel('distance from magnet [um]');
ylabel('velocity [um/sec]');

rho = 997 *(1e-6)^3; % kg/um^3
mu = 8.9e-4 *1e-6; % kg/s/um
beadR = 0.5; %um
beadV = 4*pi/3 * beadR^3; % um^3

% Dall = Sall./Lall; %um % to get size from picture uncomment this line and comment the next two
Dall = beadR * 2; %um % or get size from known bead diameter
Sall = Lall * Dall; %um^2

% chainVol = Dall.^2.*Lall*pi/4; % um^3 % to get volume from picture uncoment this line and comment the next one
chainVol = beadV*Lall/(2 * beadR); % um^3 % or get volume from known bead size

FigFall = figure('Position',[100 100 400 300]);

Fdrag = 1e6*pi*mu*absV.*(Dall + sqrt(2*Dall.^2 + 4*Sall)); % pN
FBead = Fdrag*beadV./chainVol;
scatter(distance,FBead,40,Lall,'.');
colormap jet;
cBar = colorbar;
cBar.Label.String = 'Length [um]';
% fit1 = fit(distance,FBead,'poly1');
% hold on
% plot(fit1)
xlabel('distance from magnet [um]');
ylabel('F(single bead) [pN]');
legend off;

title('Select region to fit');
hPoly = impoly;
polyPos = wait(hPoly);
in = inpolygon(distance,FBead,polyPos(:,1),polyPos(:,2));

[fit1, gof1] = fit(distance(in),FBead(in),'poly1');
[fit2, gof2] = fit(distance(in),FBead(in),fittype(@(a,b,x) a.*(x+b).^(-3)));
FigF = figure('Position',[100 100 400 300]);
scatter(distance(in),FBead(in),40,Lall(in),'.');
colormap jet;
cBar = colorbar;
cBar.Label.String = 'Length [um]';
hold on
plot(fit2);
xlabel('distance from magnet [um]');
ylabel('F(single bead) [pN]');
legend off;
% display(sprintf('force on bead F(x)=%.2gx + %.2g pN',fit2.p1, fit2.p2));
% C = confint(fit2);
% display(sprintf('force on bead at 200um %.2g +- %.1g pN',fit2(200), sqrt((C(2,2) - fit2.p2)^2 + (200*(C(2,1) - fit2.p1))^2)));
display(sprintf('force on bead at 250um %.2g pN',fit2(250)));

% theta = atan2((Yall - magnetPos(2)),(Xall - magnetPos(1)));
% figure;
% scatter(distance,FBead,40,theta,'.');
% colormap jet;
% cBar = colorbar;
% cBar.Label.String = 'theta';
% xlabel('distance from magnet [um]');
% ylabel('F(single bead) [pN]');
% [fit2, gof2] = fit(distance(in),FBead(in),'poly1');
% hold on



% figure; quiver(Xall, Yall, Uall, Vall)
% David Leith (1987) Drag on Nonspherical Objects,
% Aerosol Science andTechnology, 6:2, 153-161, DOI: 10.1080/02786828708959128
