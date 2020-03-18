function Fig = plot_velocity_paper2(CCData, rotation, smooth, lastMagnetFrame, plotPull)
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
Fig = figure('Position',[100 100 210 190]);
Fig.PaperPositionMode = 'auto';
Fig.Name = 'R_vs_T';

for i = 1:length(CCData);
if ~exist('lastMagnetFrame','var') || lastMagnetFrame(i) < 0
    [~,M] = max(abs(data(i).xSmooth));
else
    M = lastMagnetFrame(i);
end
% frames{i} = (M+1):length(data(i).xSmooth);
frames{i} = 1:length(data(i).xSmooth);

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

timeRcut{i} = times{i}(frames{i});%(M - 1 + (1:length(Rcut{i}))) * CCData(i).timeSep / 60;
timeVrcut{i} = times{i}(frames{i});%(M - 1 + (1:length(Vrcut{i}))) * CCData(i).timeSep / 60;
end

% ------------------------------------ %
figure(Fig); hold on;
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
    time = times{i};% - timeVrcut{i}(lastInd);
    [~, indMax] = max(Vrcut{i});
%     if(plotPull)
%         plot(time(1:lastMagnetFrame(i))/60,R{i}(1:lastMagnetFrame(i)),'-.','LineWidth',0.5);
%         ax = gca;
%         ax.ColorOrderIndex = ax.ColorOrderIndex - 1;
%     end
%     time1 = time(frames{i}(1:lastMagnetFrame))/60;
%     time2 = time(frames{i}((lastMagnetFrame+1):indMax))/60;
%     time3 = time(frames{i}((indMax+1):end))/60;
    r1 = [R{i}(frames{i}(1:lastMagnetFrame(i))), nan(1,length(frames{i}) - lastMagnetFrame(i))];
    r2 = [nan(1, lastMagnetFrame(i)), R{i}(frames{i}((lastMagnetFrame(i)+1):indMax)), nan(1,length(frames{i}) - indMax)];
    r3 = [nan(1, indMax), R{i}(frames{i}((indMax+1):end))];
    v1 = [Vr{i}(frames{i}(1:lastMagnetFrame(i))), nan(1,length(frames{i}) - lastMagnetFrame(i))];
    v2 = [nan(1, lastMagnetFrame(i)), Vr{i}(frames{i}((lastMagnetFrame(i)+1):indMax)), nan(1,length(frames{i}) - indMax)];
    v3 = [nan(1, indMax), Vr{i}(frames{i}((indMax+1):end))];
%     v1 = [Vr{i}(frames{i}(1:indMax)), nan(1,length(frames{i}) - indMax)];
%     v2 = [nan(1,indMax), Vr{i}(frames{i}((indMax+1):end))];
    tPlotyy = time(frames{i})/60;
    rPlotyy = [r1',r2',r3'];
    vPlotyy = [v1',v2',v3'];

    [hAx,hLine1,hLine2] = plotyy(tPlotyy,rPlotyy, tPlotyy,vPlotyy);
    hLine1(1).LineStyle = '-.';
    hLine1(2).LineStyle = ':';
    hLine1(1).LineWidth = 2;
    hLine1(2).LineWidth = 2;
    hLine1(3).LineWidth = 2;
    hLine1(1).Color = [0,0,0];
    hLine1(2).Color = hLine1(1).Color;
    hLine1(3).Color = hLine1(1).Color;
    %     hLine2(1).Color = getcolorfromindex(hAx(1),2);
    hLine2(1).LineStyle = '-.';
    hLine2(2).LineStyle = ':';
    hLine2(1).LineWidth = 2;
    hLine2(2).LineWidth = 2;
    hLine2(3).LineWidth = 2;
    hLine2(1).Color = [0.5,0.5,0.5];
    hLine2(2).Color = hLine2(1).Color;
    hLine2(3).Color = hLine2(1).Color;
    hAx(2).YLim = [0,10];
    hAx(2).YTick = [0,5,10];
    hAx(1).YTick = [0,20,40];
end
xl = xlim;
ax = gca;
ax.ColorOrderIndex = 1;
ax.FontSize = 8;
if(plotPull)
    hAx(1).XLim = [0,8];
    hAx(2).XLim = [0,8];
else
    hAx(1).XLim = [3.5,8];
    hAx(2).XLim = [3.5,8];
end
xlabel('Time [min]', 'FontSize', 8);
ylabel(hAx(1),'Contraction center position [µm]', 'FontSize', 8) % left y-axis 
ylabel(hAx(2),'Recentering velocity [µm/min]', 'FontSize', 8) % right y-axis
hAx(1).OuterPosition = [0, 0, 0.9,0.9];