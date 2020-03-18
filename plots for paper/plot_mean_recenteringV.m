function plot_mean_recenteringV(CCData, rotation, smooth, lastMagnetFrame)
if ~exist('rotation','var')
    rotation = false;
end
if ~exist('smooth','var')
    smooth = true;
end

if rotation
    data = [CCData.Rot];
else
    data = [CCData.Orig];
end

for i = 1:length(CCData);
if ~exist('lastMagnetFrame','var') || lastMagnetFrame(i) < 0
    [~,M] = max(abs(data(i).xSmooth));
else
    M = lastMagnetFrame(i);
end
% M=1
frames{i} = (M+1):length(data(i).xSmooth);
times{i} = CCData(i).times;

dropRadius{i} = CCData(i).dropRadius;
aggRadius{i} = CCData(i).aggRadius;

if smooth
    R{i} = data(i).rSmooth;
    Vr{i} = -data(i).VrSmooth;
else
    R{i} = data(i).r;
    Vr{i} = -data(i).Vr;
end

    Rcut{i} = R{i}(frames{i});
    Vrcut{i} = Vr{i}(frames{i});

% timeR{i} = times{i}(frames{i})%(1:length(R{i})) * CCData(i).timeSep / 60;
timeRcut{i} = times{i}(frames{i});%(M - 1 + (1:length(Rcut{i}))) * CCData(i).timeSep / 60;
timeVrcut{i} = times{i}(frames{i});%(M - 1 + (1:length(Vrcut{i}))) * CCData(i).timeSep / 60;
end

% ------------------------------------ %
% R vs t
for i=1:length(CCData)
    Vrhalf = Vrcut{i}(round(end/2):end);
    lastInd = find(sign(Vrhalf) < 1, 1);
    if isempty(lastInd)
%         lastInd = length(Vrhalf);
        continue
    end
    lastInd = lastInd + round(length(Vrcut{i})/2) - 1;
    time = times{i} - timeVrcut{i}(lastInd);

    dropR(i) = mean(CCData(i).dropRadius);
%     SB(i) = (CCData(i).Rot.r(end) - CCData(i).Rot.r(1))/CCData(i).dropRadius(end);
    maxV(i) = max(-CCData(i).Rot.VrSmooth(lastMagnetFrame(i):lastInd));
    meanV(i) = mean(-CCData(i).Rot.VrSmooth(lastMagnetFrame(i):lastInd));
    pullingDistance(i) = CCData(i).Rot.r(lastMagnetFrame(i));
end

FigVelPullFracAll = figure('Position',[100 100 250 300]);
FigVelPullFracAll.PaperPositionMode = 'auto';
plot(pullingDistance./dropR, meanV,'.','MarkerSize',10);
ax = gca;
ax.FontSize = 8;
xlabel('pulling fraction');
ylabel('mean recentering velocity [um/min]');
% legend({'centering', 'stuck', 'symmetry breaking'});

FigVelPullDistAll = figure('Position',[100 100 250 300]);
FigVelPullDistAll.PaperPositionMode = 'auto';
plot(pullingDistance, meanV,'.','MarkerSize',10);
ax = gca;
ax.FontSize = 8;
xlabel('pulling distance [um]');
ylabel('mean recentering velocity [um/min]');
% legend({'centering', 'stuck', 'symmetry breaking'});