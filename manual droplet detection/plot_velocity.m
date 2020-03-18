function Fig = plot_velocity(CCData, rotation, smooth, lastMagnetFrame)
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
for i=1:3
    Fig(i) = figure('Position',[100 100 800 600]);
end
Fig(1).Name = 'R_vs_T';
Fig(2).Name = 'Vr_vs_T';
Fig(3).Name = 'Vr_vs_R';
% Fig(4).Name = 'X_vs_T';
% Fig(5).Name = 'Vx_vs_T';
% Fig(6).Name = 'Vx_vs_X';

for i = 1:length(CCData);
if ~exist('lastMagnetFrame','var') || lastMagnetFrame(i) < 0
    [~,M] = max(abs(data(i).xSmooth));
else
    M = lastMagnetFrame(i);
end
% M=1
frames{i} = (M+1):length(data(i).xSmooth);
times{i} = CCData(i).times;

% Vxcut{i} = data(i).VxSmooth(frames{i});
% Xcut{i} = data(i).Xsmooth(frames{i});
% Vycut{i} = data(i).VySmooth(frames{i});
% Ycut{i} = data(i).Ysmooth(frames{i});
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
figure(Fig(1)); hold on;
plotInds = [];
for i = 1:length(CCData);
    Vrhalf = Vrcut{i}(round(end/2):end);
    lastInd = find(sign(Vrhalf) < 1, 1);
    if isempty(lastInd)
%         lastInd = length(Vrhalf);
        continue
    end
    plotInds = [plotInds, i];
    lastInd = lastInd + round(length(Vrcut{i})/2) - 1;
    time = times{i} - timeVrcut{i}(lastInd);
    [~, indMax] = max(Vrcut{i});
    plot(time(1:lastMagnetFrame(i))/60,R{i}(1:lastMagnetFrame(i)),':','LineWidth',0.5);
    ax = gca;
    ax.ColorOrderIndex = ax.ColorOrderIndex - 1;
    plot(time(frames{i}(1:indMax))/60,R{i}(frames{i}(1:indMax)),'--','LineWidth',0.5);
    ax.ColorOrderIndex = ax.ColorOrderIndex - 1;
    plot(time(frames{i}((indMax+1):end))/60,R{i}(frames{i}((indMax+1):end)),'LineWidth',0.5);
%     plot(time/60,R{i},'LineWidth', 0.5);
end
xl = xlim;
ax = gca;
ax.ColorOrderIndex = 1;
for i = plotInds
    plot([xl(1),xl(2)], (dropRadius{i}(1) - aggRadius{i}(1)) * [1,1], '--');
%     plot([xl(1),xl(2)], dropRadius{i}*0.75 * [1,1], '--');
end
    ax.FontSize = 20;

xlabel('Time [min]');
ylabel('Contraction Center Position [{\mu}m]');

% ------------------------------------ %
figure(Fig(2)); hold on;
AllVr = nan;
timesAllVr = nan;
for i = 1:length(CCData);
    Vrhalf = Vrcut{i}(round(end/2):end);
    lastInd = find(sign(Vrhalf) < 1, 1);
    if isempty(lastInd)
%         lastInd = length(Vrhalf);
        continue
    end
    lastInd = lastInd + round(length(Vrcut{i})/2) - 1;
    time = timeVrcut{i} - timeVrcut{i}(lastInd);
    [~, indMax] = max(Vrcut{i});
    plot(time(1:indMax)/60,Vrcut{i}(1:indMax),'--','LineWidth',0.5);
    ax = gca;
    ax.ColorOrderIndex = ax.ColorOrderIndex - 1;
    plot(time((indMax+1):end)/60,Vrcut{i}((indMax+1):end),'LineWidth',0.5);
    if (length(Vrcut{i}) - indMax) > size(AllVr,2)
        AllVr = padarray(AllVr, [0, length(Vrcut{i}) - indMax - size(AllVr,2)], nan, 'post');
        timesAllVr = padarray(timesAllVr, [0, length(Vrcut{i}) - indMax - size(timesAllVr,2)], nan, 'post');
    end
    AllVr(i,1:(length(Vrcut{i}) - indMax)) = Vrcut{i}((indMax+1):end);
    timesAllVr(i,1:(length(Vrcut{i}) - indMax)) = time((indMax+1):end);

    if (1 + length(Vrcut{i}) - indMax) < size(AllVr,2)
        AllVr(i,(1 + length(Vrcut{i}) - indMax):end) = nan;
        timesAllVr(i,(1 + length(Vrcut{i}) - indMax):end) = nan;
    end
%     plot(time,Vrcut{i},'LineWidth',2)
end
timesAllVr = round(timesAllVr,0);
[uniqueTime,ia,ic] = unique(timesAllVr);
reorderedAllVr = nan(length(CCData),length(uniqueTime));
for c = 1:size(AllVr,1)
    for t = 1:size(AllVr,2)
        ind = sub2ind(size(AllVr),c,t);
        reorderedAllVr(c,ic(ind)) = AllVr(c,t);
    end
end

indsForMean = sum(~isnan(reorderedAllVr)) > 2;
meanVr = mean(reorderedAllVr(:,indsForMean),'omitnan');
plot(uniqueTime(indsForMean)/60, meanVr, 'Color', [0.3, 0.3, 0.3], 'LineWidth',2);
ax.FontSize = 20;
xlabel('Time [min]');
ylabel('Recentering Velocity [$\frac{{\mu}m}{min}$]','Interpreter','Latex');
xl = xlim;
plot(xl(1):xl(2), zeros(size(xl(1):xl(2))),'k--');
xlim([-4.5,0]);
% ------------------------------------ %
figure(Fig(3)); hold on;
AllVr = nan;
RAllVr = nan;

for i = 1:length(CCData);
%     plot(Rcut{i},Vrcut{i},'LineWidth',2)
    Vrhalf = Vrcut{i}(round(end/2):end);
    lastInd = find(sign(Vrhalf) < 1, 1);
    if isempty(lastInd)
%         lastInd = length(Vrhalf);
        continue
    end
    lastInd = lastInd + round(length(Vrcut{i})/2) - 1;
    R = Rcut{i} - Rcut{i}(lastInd);
    R = R(1:lastInd);
    VrPositive = Vrcut{i}(1:lastInd);

    [~, indMax] = max(VrPositive);
    plot(R(1:indMax),VrPositive(1:indMax),'--','LineWidth',0.5);
    ax = gca;
    ax.ColorOrderIndex = ax.ColorOrderIndex - 1;
    plot(R((indMax+1):end),VrPositive((indMax+1):end),'LineWidth',0.5);
    if (length(VrPositive) - indMax) > size(AllVr,2)
        AllVr = padarray(AllVr, [0, length(VrPositive) - indMax - size(AllVr,2)], nan, 'post');
        RAllVr = padarray(RAllVr, [0, length(VrPositive) - indMax - size(RAllVr,2)], nan, 'post');
    end
    AllVr(i,1:(length(VrPositive) - indMax)) = VrPositive((indMax+1):end);
    RAllVr(i,1:(length(VrPositive) - indMax)) = R((indMax+1):end);

    if (1 + length(VrPositive) - indMax) < size(AllVr,2)
        AllVr(i,(1 + length(VrPositive) - indMax):end) = nan;
        RAllVr(i,(1 + length(VrPositive) - indMax):end) = nan;
    end
%     plot(time,Vrcut{i},'LineWidth',2)
end
RAllVr = round(RAllVr*4)/4;
[uniqueR,ia,ic] = unique(RAllVr);
reorderedAllVr = nan(length(CCData),length(uniqueR));
for c = 1:size(AllVr,1)
    for t = 1:size(AllVr,2)
        ind = sub2ind(size(AllVr),c,t);
        reorderedAllVr(c,ic(ind)) = AllVr(c,t);
    end
end
indsForMean = sum(~isnan(reorderedAllVr)) > 2;
meanVr = mean(reorderedAllVr(:,indsForMean),'omitnan');
plot(uniqueR(indsForMean), meanVr, 'Color', [0.3, 0.3, 0.3], 'LineWidth',2);
ax.FontSize = 20;
set(gca, 'XDir','reverse')
xlabel('Contraction Center Position [{\mu}m]');
ylabel('Recentering Velocity [$\frac{{\mu}m}{min}$]','Interpreter','Latex');
xl = xlim;
plot(xl(1):xl(2), zeros(size(xl(1):xl(2))),'k--');
xlim([0, 25]);
% figure(Fig(4)); hold on;
% for i = 1:length(CCData);
%     plot(timeR{i},data(i).Xsmooth,'LineWidth',0.5);
% end
% xlabel('Time [min]');
% ylabel('Contraction Center X Position [{\mu}m]');
% 
% figure(Fig(5)); hold on;
% for i = 1:length(CCData);
%     plot(timeVrcut{i},Vxcut{i},'LineWidth',0.5)
% end
% xlabel('Time [min]');
% ylabel('Vx [$\frac{{\mu}m}{min}$]','Interpreter','Latex');
% 
% figure(Fig(6)); hold on;
% for i = 1:length(CCData);
%     plot(Xcut{i},Vxcut{i},'LineWidth',0.5)
% end
% xlabel('Contraction Center X Position [{\mu}m]');
% ylabel('Vx [$\frac{{\mu}m}{min}$]','Interpreter','Latex');
% xl = xlim;
% plot(xl(1):xl(2), zeros(size(xl(1):xl(2))),'k--');

