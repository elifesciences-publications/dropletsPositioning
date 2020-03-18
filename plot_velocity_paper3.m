function Fig = plot_velocity_paper3(CCData, rotation, smooth, lastMagnetFrame, plotLinesFlag, plotMean, contFlag, VMaxFactor, vTime, vAggPos, vAggSpeed, vTimeShift)
if ~exist('rotation','var')
    rotation = false;
end
if ~exist('smooth','var')
    smooth = true;
end
if ~exist('plotLinesFlag','var')
    plotLinesFlag = false;
end

if ~exist('contFlag','var')
    contFlag = true;
end
if ~exist('VMaxFactor','var')
    VMaxFactor = 1;
end

if rotation
    data = [CCData.Rot];
else
    data = [CCData.Orig];
end
for i=1:3
    Fig(i) = figure('Position',[100 100 200 170]);
    Fig(i).PaperPositionMode = 'auto';
end
Fig(1).Name = 'R_vs_T';
Fig(2).Name = 'Vr_vs_T';
Fig(3).Name = 'Vr_vs_R';
% Fig(4).Name = 'X_vs_T';
% Fig(5).Name = 'Vx_vs_T';
% Fig(6).Name = 'Vx_vs_X';

for i = 1:length(CCData)
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
% R vs t
Allr = nan;
timesAllr = nan;
figure(Fig(1)); hold on;
% plotInds = [];
for i = 1:length(CCData);
    Vrhalf = Vrcut{i}(round(end/2):end);
    lastInd = find(sign(Vrhalf) < 1, 1);
    if isempty(lastInd)
        if(contFlag)
            continue
        else
            lastInd = length(Vrhalf);
        end
    end
%     plotInds = [plotInds, i];
    lastInd = lastInd + round(length(Vrcut{i})/2) - 1;
    time = times{i} - timeVrcut{i}(lastInd);
    Vmax = max(Vrcut{i});
    indMax = find(Vrcut{i} >= 0.9*Vmax,1);
    if (length(R{i}) - indMax) > size(Allr,2)
        Allr = padarray(Allr, [0, length(R{i}) - indMax - size(Allr,2)], nan, 'post');
        timesAllr = padarray(timesAllr, [0, length(R{i}) - indMax - size(timesAllr,2)], nan, 'post');
    end
    Allr(i,1:(length(R{i}) - indMax)) = R{i}((indMax+1):end);
    timesAllr(i,1:(length(R{i}) - indMax)) = time((indMax+1):end);

    if (1 + length(R{i}) - indMax) < size(Allr,2)
        Allr(i,(1 + length(R{i}) - indMax):end) = nan;
        timesAllr(i,(1 + length(R{i}) - indMax):end) = nan;
    end
   if(plotLinesFlag)
       plot(time(frames{i}(1:indMax))/60,R{i}(frames{i}(1:indMax)),':','LineWidth',0.5);
       ax = gca;
       ax.ColorOrderIndex = mod(ax.ColorOrderIndex - 2,size(ax.ColorOrder,1)) + 1;
       DT(i).t = time(frames{i});
       DT(i).d = R{i}(frames{i});
       plot(DT(i).t((indMax+1):end)/60,DT(i).d((indMax+1):end),'LineWidth',0.5);
   end
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

indsForMean = sum(~isnan(reorderedAllr)) > 2;
if(plotMean == 1)
    stdshade(reorderedAllr(:,indsForMean),0.2,'k',uniqueTime(indsForMean)/60,1,false)
elseif(plotMean == 2)
    stdshade(reorderedAllr(:,indsForMean),0.2,'k',uniqueTime(indsForMean)/60,1,true)
end
    


% meanr = mean(reorderedAllr(:,indsForMean),'omitnan');
% stdr = std(reorderedAllr(:,indsForMean),'omitnan');
% plot(uniqueTime(indsForMean)/60, meanr, 'Color', [0.3, 0.3, 0.3], 'LineWidth',2);
if exist('vTime', 'var')
    plot(vTime + vTimeShift, vAggPos, 'LineWidth',2, 'Color', [217, 83, 25]/255);
end
xl = xlim;
ax = gca;
ax.FontSize = 8;
xlim([-3,0]);

ax.YLim = [0,15];
xlabel('Time [min]', 'FontSize', 8);
ylabel('Displacement [µm]', 'FontSize', 8);

% ------------------------------------ %
% v vs t
figure(Fig(2)); hold on;
AllVr = nan;
timesAllVr = nan;
for i = 1:length(CCData);
    Vrhalf = Vrcut{i}(round(end/2):end);
    lastInd = find(sign(Vrhalf) < 1, 1);
    if isempty(lastInd)
        if(contFlag)
            continue
        else
            lastInd = length(Vrhalf);
        end
    end
    lastInd = lastInd + round(length(Vrcut{i})/2) - 1;
    time = timeVrcut{i} - timeVrcut{i}(lastInd);
    Vmax = max(Vrcut{i});
    indMax = find(Vrcut{i} >= VMaxFactor*Vmax,1);
    if(plotLinesFlag)
        plot(time(1:indMax)/60,Vrcut{i}(1:indMax),':','LineWidth',0.5);
        ax = gca;
        ax.ColorOrderIndex = mod(ax.ColorOrderIndex - 2,size(ax.ColorOrder,1)) + 1;
        VT(i).t = time((indMax+1):end);
        VT(i).v = Vrcut{i}((indMax+1):end);
        plot(VT(i).t/60,VT(i).v,'LineWidth',0.5);
    end
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
if (plotMean == 1)
    stdshade(reorderedAllVr(:,indsForMean),0.2,'k',uniqueTime(indsForMean)/60,1, false);
elseif (plotMean == 2)
    stdshade(reorderedAllVr(:,indsForMean),0.2,'k',uniqueTime(indsForMean)/60,1, true);
end
if exist('vTime', 'var')
    plot(vTime + vTimeShift, -vAggSpeed, 'LineWidth',2, 'Color', [217, 83, 25]/255);
end
ax = gca;
ax.FontSize = 8;
xlabel('Time [min]', 'FontSize', 8);
ylabel('Recentering velocity [µm/min]', 'FontSize', 8);
xlim([-3,0]);
ax.YTick = [0,5];
ylim([0,8]);
yl = ylim(ax);
% ------------------------------------ %
% v vs R
figure(Fig(3)); hold on;
AllVr = nan;
RAllVr = nan;

for i = 1:length(CCData);
% %     plot(Rcut{i},Vrcut{i},'LineWidth',2)
%     Vrhalf = Vrcut{i}(round(end/2):end);
%     lastInd = find(sign(Vrhalf) < 1, 1);
%     if isempty(lastInd)
% %         lastInd = length(Vrhalf);
%         continue
%     end
%     lastInd = lastInd + round(length(Vrcut{i})/2) - 1;
%     R = Rcut{i} - Rcut{i}(lastInd);
    lastInd = length(Vrcut{i});
    R = Rcut{i};
    R = R(1:lastInd);
    VrPositive = Vrcut{i}(1:lastInd);
    Vmax = max(VrPositive);
    indMax = find(VrPositive >= VMaxFactor*Vmax,1);
    if plotLinesFlag
        plot(R(1:indMax),VrPositive(1:indMax),':','LineWidth',0.5);
        ax = gca;
        ax.ColorOrderIndex = mod(ax.ColorOrderIndex - 2,size(ax.ColorOrder,1)) + 1;
        VD(i).d = R((indMax+1):end);
        VD(i).v = VrPositive((indMax+1):end);
        plot(VD(i).d,VD(i).v,'LineWidth',0.5);
    end
    [~, indMax] = max(VrPositive);
    ax = gca;
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
if plotMean == 1
    stdshade(reorderedAllVr(:,indsForMean),0.2,'k',uniqueR(indsForMean),1, false);
elseif plotMean == 2
    stdshade(reorderedAllVr(:,indsForMean),0.2,'k',uniqueR(indsForMean),1, true);
end

% meanVr = mean(reorderedAllVr(:,indsForMean),'omitnan');
% plot(uniqueR(indsForMean), meanVr, 'Color', [0.3, 0.3, 0.3], 'LineWidth',2);
if exist('vTime', 'var')
    plot(vAggPos, -vAggSpeed, 'LineWidth',2, 'Color', [217, 83, 25]/255);
end
ax.FontSize = 8;
set(gca, 'XDir','reverse')
xlabel('Displacement [µm]', 'FontSize', 8);
ylabel('Recentering velocity [µm/min]', 'FontSize', 8);
xlim([0, 15]);
ylim(ax,yl);
ax.YTick = [0,5];

