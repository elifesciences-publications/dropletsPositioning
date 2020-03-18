function [Fig, DT, VD, VT, DTmean, VDmean, VTmean] = plot_velocity_paper_nocontinue(CCData, rotation, smooth_flag, lastMagnetFrame, plotPull)
if ~exist('rotation','var')
    rotation = false;
end
if ~exist('smooth_flag','var')
    smooth_flag = true;
end

if rotation
    data = [CCData.Rot];
else
    data = [CCData.Orig];
end
for i=1:3
    Fig(i) = figure('Position',[100 100 400 200]);
    Fig(i).PaperPositionMode = 'auto';
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
yl =[0,15];
% Vxcut{i} = data(i).VxSmooth(frames{i});
% Xcut{i} = data(i).Xsmooth(frames{i});
% Vycut{i} = data(i).VySmooth(frames{i});
% Ycut{i} = data(i).Ysmooth(frames{i});
dropRadius{i} = CCData(i).dropRadius;
aggRadius{i} = CCData(i).aggRadius;

if smooth_flag
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
figure(Fig(1)); hold on;
% plotInds = [];
for i = 1:length(CCData)
    Vrhalf = Vrcut{i}(round(end/2):end);
    lastInd = find(sign(Vrhalf) < 1, 1);
    if isempty(lastInd)
         lastInd = length(Vrhalf);
    %      continue
    end
    lastInd = lastInd + round(length(Vrcut{i})/2) - 1;
%     lastInd = length(Vrcut{i});
%     plotInds = [plotInds, i];
    time = times{i} - timeVrcut{i}(lastInd);
%     [~, indMax] = max(Vrcut{i});
    Vmax = max(Vrcut{i});
    indMax = find(Vrcut{i} >= 0.9*Vmax,1);
    if(plotPull)
        plot(time(1:lastMagnetFrame(i))/60,R{i}(1:lastMagnetFrame(i)),'-.','LineWidth',0.5);
        ax = gca;
        ax.ColorOrderIndex = mod(ax.ColorOrderIndex - 2,size(ax.ColorOrder,1)) + 1;
    end
    plot(time(frames{i}(1:indMax))/60,R{i}(frames{i}(1:indMax)),':','LineWidth',0.5);
    Allr(i,1:(length(R{i}) - indMax)) = R{i}((indMax+1):end);
    timesAllr(i,1:(length(R{i}) - indMax)) = time((indMax+1):end);
    if (1 + length(R{i}) - indMax) < size(Allr,2)
        Allr(i,(1 + length(R{i}) - indMax):end) = nan;
        timesAllr(i,(1 + length(R{i}) - indMax):end) = nan;
    end

    ax = gca;
    ax.ColorOrderIndex = mod(ax.ColorOrderIndex - 2,size(ax.ColorOrder,1)) + 1;
    DT(i).t = time(frames{i});
    DT(i).d = R{i}(frames{i});
    plot(DT(i).t((indMax+1):end)/60,DT(i).d((indMax+1):end),'LineWidth',0.5);
%     plot(time/60,R{i},'LineWidth', 0.5);
end
timesAllr = round(timesAllr,0);
[uniqueTime,ia,ic] = unique(timesAllr);
reorderedAllr = nan(length(CCData),length(uniqueTime));
for c = 1:size(Allr,1)
    for t = 1:size(Allr,2)
        ind = sub2ind(size(Allr),c,t);
        reorderedAllr(c,ic(ind)) = Allr(c,t);
    end
end

indsForMean = sum(~isnan(reorderedAllr)) >= 3;
% stdshade(reorderedAllr(:,indsForMean),0.2,'k',uniqueTime(indsForMean)/60)
DTmean(1,:) = uniqueTime(indsForMean);
DTmean(2,:) = mean(reorderedAllr(:,indsForMean),'omitnan');
DTmean(3,:) = std(reorderedAllr(:,indsForMean),'omitnan');
xl = xlim;
ax = gca;
ax.ColorOrderIndex = 1;
% for i = plotInds
%     plot([xl(1),xl(2)], (dropRadius{i}(1) - aggRadius{i}(1)) * [1,1], '--');
% %     plot([xl(1),xl(2)], dropRadius{i}*0.75 * [1,1], '--');
% end
    ax.FontSize = 8;
if(plotPull)
    xlim([-15,0]);
else
    xlim([-15,0]);
end
ax.YLim = [0,40];
xlabel('Time [min]', 'FontSize', 8);
ylabel('Contraction center position [{\mu}m]', 'FontSize', 8);

% ------------------------------------ %
% v vs t
figure(Fig(2)); hold on;
AllVr = nan;
timesAllVr = nan;
for i = 1:length(CCData)
    Vrhalf = Vrcut{i}(round(end/2):end);
    lastInd = find(sign(Vrhalf) < 1, 1);
    if isempty(lastInd)
        lastInd = length(Vrhalf);
   %     continue
    end
    lastInd = lastInd + round(length(Vrcut{i})/2) - 1;
%     lastInd = length(Vrcut{i});
    time = timeVrcut{i} - timeVrcut{i}(lastInd);
%     [~, indMax] = max(Vrcut{i});
    Vmax = max(Vrcut{i});
    indMax = find(Vrcut{i} >= 0.9*Vmax,1);
    plot(time(1:indMax)/60,Vrcut{i}(1:indMax),':','LineWidth',0.5);
    ax = gca;
    ax.ColorOrderIndex = mod(ax.ColorOrderIndex - 2,size(ax.ColorOrder,1)) + 1;
    VT(i).t = time((indMax+1):end);
    VT(i).v = Vrcut{i}((indMax+1):end);

    plot(VT(i).t/60,VT(i).v,'LineWidth',0.5);
    if (length(Vrcut{i}) - indMax) > size(AllVr,2)
        AllVr = padarray(AllVr, [0, length(Vrcut{i}) - indMax - size(AllVr,2)], nan, 'post');
        timesAllVr = padarray(timesAllVr, [0, length(Vrcut{i}) - indMax - size(timesAllVr,2)], nan, 'post');
    end
    AllVr(i,1:(length(Vrcut{i}) - indMax)) = VT(i).v;
    timesAllVr(i,1:(length(Vrcut{i}) - indMax)) = VT(i).t;

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

indsForMean = sum(~isnan(reorderedAllVr)) >= 3;
VTmean(1,:) = uniqueTime(indsForMean);
VTmean(2,:) = gaussianSmoothing(VTmean(1,:),mean(reorderedAllVr(:,indsForMean),'omitnan'),1);
VTmean(3,:) = std(reorderedAllVr(:,indsForMean),'omitnan');

plot(VTmean(1,:)/60, VTmean(2,:), 'Color', [0.3, 0.3, 0.3], 'LineWidth',2);
ax.FontSize = 8;
xlabel('Time [min]', 'FontSize', 8);
ylabel('Recentering velocity [{\mu}m/min]', 'FontSize', 8);
% ylabel('Recentering Velocity [$\frac{{\mu}m}{min}$]','Interpreter','Latex', 'FontSize', 8);
xl = xlim(ax);
plot(xl(1):xl(2), zeros(size(xl(1):xl(2))),'k--');
xlim([-15,0]);
ax.YTick = [0,5,10];
ylim(ax,yl);
% ------------------------------------ %
% v vs R
figure(Fig(3)); hold on;
AllVr = nan;
RAllVr = nan;

for i = 1:length(CCData)
%     plot(Rcut{i},Vrcut{i},'LineWidth',2)
%     Vrhalf = Vrcut{i}(round(end/2):end);
%     lastInd = find(sign(Vrhalf) < 1, 1);
%     if isempty(lastInd)
%          lastInd = length(Vrhalf);
%   %      continue
%     end
%     lastInd = lastInd + round(length(Vrcut{i})/2) - 1;
%     R = Rcut{i} - Rcut{i}(lastInd);
    lastInd = length(Vrcut{i});
    R = Rcut{i};
    R = R(1:lastInd);
    VrPositive = Vrcut{i}(1:lastInd);

    %[~, indMax] = max(VrPositive);
    Vmax = max(VrPositive);
    indMax = find(VrPositive >= 0.9*Vmax,1);

    plot(R(1:indMax),VrPositive(1:indMax),':','LineWidth',0.5);
    ax = gca;
    ax.ColorOrderIndex = mod(ax.ColorOrderIndex - 2,size(ax.ColorOrder,1)) + 1;
    VD(i).d = R((indMax+1):end);
    VD(i).v = VrPositive((indMax+1):end);
    plot(VD(i).d,VD(i).v,'LineWidth',0.5);
    if (length(VrPositive) - indMax) > size(AllVr,2)
        AllVr = padarray(AllVr, [0, length(VrPositive) - indMax - size(AllVr,2)], nan, 'post');
        RAllVr = padarray(RAllVr, [0, length(VrPositive) - indMax - size(RAllVr,2)], nan, 'post');
    end
    AllVr(i,1:(length(VrPositive) - indMax)) = VD(i).v;
    RAllVr(i,1:(length(VrPositive) - indMax)) = VD(i).d;

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
indsForMean = sum(~isnan(reorderedAllVr)) >= 3;
VDmean(1,:) = uniqueR(indsForMean);
VDmean(2,:) = gaussianSmoothing(VDmean(1,:),mean(reorderedAllVr(:,indsForMean),'omitnan'),1);
VDmean(3,:) = std(reorderedAllVr(:,indsForMean),'omitnan');

plot(VDmean(1,:), VDmean(2,:), 'Color', [0.3, 0.3, 0.3], 'LineWidth',2);
ax.FontSize = 8;
set(gca, 'XDir','reverse')
xlabel('Contraction center position [µm]', 'FontSize', 8);
ylabel('Recentering velocity [µm/min]', 'FontSize', 8);
% ylabel('Recentering Velocity [$\frac{{\mu}m}{min}$]','Interpreter','Latex', 'FontSize', 8);
xl = xlim;
plot(xl(1):xl(2), zeros(size(xl(1):xl(2))),'k--');
xlim([0, 40]);
ylim(ax,yl);
ax.YTick = [0,5,10];

