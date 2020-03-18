warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning');
SBCriterion = 0.3;
DIRS{3} = {'W:\phkinnerets\storage\analysis\Niv\tracking\2018_05_16'};
limits{3} = {1:69, 1:80, 1:110, [], 1:115};
PI{3} = [1:3,5];
Reg{3} = '*Position %d*';
planePositionsFun{3} = @(dropletPlane) (-10:5:10) + (dropletPlane - 3) * 5;
DIRS{1} = {'W:\phkinnerets\storage\analysis\Niv\tracking\2018_06_19';...
    'W:\phkinnerets\storage\analysis\Niv\tracking\2018_06_18';...
    'W:\phkinnerets\storage\analysis\Niv\tracking\2018_08_05\mix1 sample1';...
    'W:\phkinnerets\storage\analysis\Niv\tracking\2018_08_05\mix2 sample1';...
    'W:\phkinnerets\storage\analysis\Niv\tracking\2018_08_02\mix1 sample1'};
PI{1} = 1:5;
Reg{1} = '*Position %d*';
planePositionsFun{1} = @(dropletPlane) (-20:5:20) + (dropletPlane - 5) * 5;
DIRS{2} = {'W:\phkinnerets\storage\analysis\Niv\tracking\2018_07_30'};
PI{2} = [77,78,80,81]; % 79 is weird - huge aggregate
Reg{2} = 'P*%d*';
planePositionsFun{2} = @(dropletPlane) (-20:5:20) + (dropletPlane - 5) * 5;

clear CCDATA
count = 0;
for di = 1:numel(DIRS)
    for dj = 1:numel(DIRS{di})
        DIR = DIRS{di}{dj};
        for posIndex = PI{di};
            filename_regexp = sprintf([Reg{di}, '_C0.tiff'], posIndex);
            fs = ls(fullfile(DIR,filename_regexp));
            if length(fs) == 0
                filenames = {};
            else
                for i=1:size(fs,1)
                    filenames{i} = fullfile(DIR,fs(i,:));
                end
            end
            if ~isempty(filenames)
                [D,F,E] = fileparts(filenames{1});
                dfs = ls(fullfile(D,sprintf([Reg{di}, '.mat'], posIndex)));
                for i=1:size(dfs,1)
                    count = count + 1;
                    trackingImageFilenames{count} = filenames;
                    trackingDataFilename{count} = fullfile(D,dfs(i,:));
                    if size(dfs,1) == 1
                        MovieFilename{count} = fullfile(DIR,sprintf('tracking movie%d.mp4', posIndex));
                    elseif size(dfs,1) >1
                        MovieFilename{count} = fullfile(DIR,sprintf('tracking movie%d_%d.mp4', posIndex,i));
                    else
                        error('size(dfs,1) = 0');
                    end
                    data = load(trackingDataFilename{count});
                    if isempty(limits{di})
                        limitsP = 1:length(data.droplets);
                    else
                        limitsP = limits{di}{posIndex};
                    end
                    timeSep = 30;
                    %                     CCDATA(count) = smooth_data(data.droplets(limitsP), timeSep, 1, 5, 1, 3, -1);
%                     %no smoothing:
%                     CCDATA(count) = smooth_data(data.droplets(limitsP), timeSep, 2, 3, 2, 3, -1);
                    %some smoothing
                    CCDATA(count) = smooth_data(data.droplets(limitsP), timeSep, 1, 3, 2, 3, -1);

                    planesPositions{count} = planePositionsFun{di}(data.droplets(1).dropletPlane);
                end
            end
        end
    end
end
% %% export data for alex
% for i=1:numel(CCDATA)
%     track(i).t = CCDATA(i).times;
%     track(i).x = CCDATA(i).Orig.x;
%     track(i).y = CCDATA(i).Orig.y;
%     track(i).z = CCDATA(i).Orig.z;
%     track(i).dropRadius = mean(CCDATA(i).dropRadius);
% end
%
% save('tracks.mat','track');
%%
indsC=[];
indsB=[];
for c=1:numel(CCDATA)
    if max(CCDATA(c).Orig.r./CCDATA(c).dropRadius) < SBCriterion
        indsC = [indsC, c];
    else
        indsB = [indsB, c];
    end
end
%seperate symmetry breaking droplets to cbefore and after
% SBDATA = [];
% SDATA = [];
% for ind = indsB
%     sb = CCDATA(ind).Orig.r./CCDATA(ind).dropRadius;
%     IFirst = find(sb<0.05,1, 'last');
%     [~,ILast] = max(sb);
%     if isempty(IFirst) || IFirst == 1
%         IFirst=1;
%     else
%         SDATA = [SDATA, truncate(CCDATA(ind),1:IFirst)];
%     end
%     SBDATA = [SBDATA, truncate(CCDATA(ind),IFirst:ILast)];
%     IFirst_all(ind) = IFirst;
%     ILast_all(ind) = ILast;
% end
[SDATA, SBDATA, IFirst_all(indsB), ILast_all(indsB)] = seperateSymbreaking(CCDATA(indsB));
[FigXY(1) ,ma(1)] = plot_movement_paper(CCDATA(indsC), 'a. centered droplets');
[FigXY(2) ,ma(2)] = plot_movement_paper(SDATA, 'b. before symmetry breaking');
[FigXY(3) ,ma(3)] = plot_movement_paper(SBDATA, 'c. during symmetry breaking');
% [FigXY(4) ,ma(4)] = plot_movement_xy_paper(CCDATA(indsB), 'Symmetry breaking droplets');
% [FigXY(5) ,ma(5)] = plot_movement_xy_paper(CCDATA, 'All droplets');
ax = FigXY(2).Children(4);
hold(ax,'on');
h = ma(1).plotMeanMSD(ax);
h.Color = [0,0,0,0.6];
%%
% [FigBursts, fit] = plot_numberOfBursts(CCDATA,0.5);
FigR = figure('Position',[0,0,220,200]);
FigR.PaperPositionMode = 'auto';
hold on
for i = indsB
    x = (CCDATA(i).times - CCDATA(i).times(IFirst_all(i)))/60;
    y = CCDATA(i).Orig.r;
%     x = (CCDATA(i).times(IFirst_all(i):ILast_all(i)) - CCDATA(i).times(IFirst_all(i)))/60;
%     y = CCDATA(i).Orig.r(IFirst_all(i):ILast_all(i));

%     y = CCDATA(i).Orig.Vr - CCDATA(i).Orig.VrSmooth;

%     y = CCDATA(i).Orig.r.*CCDATA(i).Orig.VrSmooth;
%     y = [0,CCDATA(i).Orig.Vr(1:end-1).*CCDATA(i).Orig.Vr(2:end)];
    plot(x, y);
end
ax = gca;
ax.FontSize = 8;
xlim([-40,40]);
xlabel('Time [min]');
ylabel('Displacement [um]');
%%
if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
    for f=1:numel(FigXY)
        C = strsplit(FigXY(f).Name,'\.\s*','DelimiterType','RegularExpression');
        name = C{end};
        %     print(FigXY(f),fullfile(outputDir,['tracks ',FigXY(f).Name,'.png']),'-dpng');
        %     print(FigXY(f),fullfile(outputDir,['tracks ',FigXY(f).Name,'.eps']),'-depsc');
        print(FigXY(f),fullfile(outputDir,['tracks ',name]),format);
    end
    print(FigR,fullfile(outputDir,'R_vs_T_symmetry_braking_tracks'),format);
end
% print(FigBursts(2),fullfile(DIR,['bursts', FigBursts(2).Name,'.png']),'-dpng');
% print(FigBursts(2),fullfile(DIR,['bursts', FigBursts(2).Name,'.eps']),'-depsc');
% print(FigBursts(2),fullfile(DIR,['bursts', FigBursts(2).Name,'.pdf']),'-dpdf');
%%
%     OrigCentered = [CCDATA(indsC).Orig];
%     rCenSqrd = [OrigCentered.r].^2;%./[CCDATA(indsC).dropRadius];
    dCen=[];
    meanDsqrdCenPerDrop=[];
    rDrop = [];
    Ds = [];
    stdDsqrdCenPerDrop = [];
    DsStd = [];
    xCen = [];
    yCen = [];
    for i = 1:numel(indsC)
        ind = indsC(i);
        dCen = [dCen, CCDATA(ind).Orig.r(1:100)];%./[CCDATA(indsC).dropRadius];
        xCen = [xCen, CCDATA(ind).Orig.x(1:100)];%./[CCDATA(indsC).dropRadius];
        yCen = [yCen, CCDATA(ind).Orig.y(1:100)];
        meanDsqrdCenPerDrop(i) = mean(CCDATA(ind).Orig.r(1:100).^2);
        stdDsqrdCenPerDrop(i) = std(CCDATA(ind).Orig.r(1:100).^2);
        steDsqrdCenPerDrop(i) = stdDsqrdCenPerDrop(i)./10;
        rDrop(i) = mean(CCDATA(ind).dropRadius);
        Ds(i) = ma(1).msd{i}(3,2)/6;
        DsStd(i) = ma(1).msd{i}(3,3)/6;
        DsSte(i) = DsStd(i)./sqrt(ma(1).msd{i}(3,4));
        d10(i) = ma(1).msd{i}(20,2)/6;
    end;
    rCenSqrd = dCen.^2;
%     display(sprintf('(<|r|>) = %f +- %f', mean(rCen), std(rCen)));
    display(sprintf('sqrt(<r^2>) = %g +- %g', round(sqrt(mean(rCenSqrd)),2,'significant'), round(0.5/sqrt(mean(rCenSqrd))*std(rCenSqrd),2,'significant')));

    histFig = figure('Position',[200,200,300,200]);
%     histogram(rCenSqrd,'Normalization','pdf');
%     xlabel('r^2 [um^2]');
%     ylabel('PDF');
    dHist = histogram(dCen,'Normalization','pdf');
    xlabel('|d| [um]', 'FontSize', 8);
    ylabel('PDF', 'FontSize', 8);
    val = dHist.Values;
    M = max(val);
    IndF = find(val > M/2, 1);
    IndL = find(val > M/2, 1,'last');
    xArrow = dHist.BinEdges([IndF, IndL + 1]);
    yArrow = [M/2, M/2];
    ax = gca;
    ax.FontSize = 8;
    ax.YTick = [0,0.1,0.2];
    [X,Y] = DataToNormalized(xArrow, yArrow, gca);
    annotation('doublearrow', X, Y);
if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
    histFig.PaperPositionMode = 'auto';
    print(histFig,fullfile(outputDir,'centered_displacement_histogram'),format);
end


    %%
    y = Ds./meanDsqrdCenPerDrop;
    fit1 = fit(rDrop', y', 'poly1');
    FigCenteringMagnitude = figure('Position',[0,0,800,250]);
    
    subplot(1,3,1);
    plot(rDrop,Ds,'.', 'MarkerSize',20);
    xlabel('Drop radius [um]');
    ylabel('D(1 min) [um^2/min]');
    yl = ylim;
    ylim([0,yl(2)]);
    subplot(1,3,2);
    plot(rDrop,meanDsqrdCenPerDrop,'.', 'MarkerSize',20);
    xlabel('Drop radius [um]');
    ylabel('<d^2> [um^2]');
    yl = ylim;
    ylim([0,yl(2)]);
    
    subplot(1,3,3);
%      yErr = sqrt((DsStd./meanDsqrdCenPerDrop).^2 + (Ds.*stdDsqrdCenPerDrop./meanDsqrdCenPerDrop.^2).^2);
% %      yErr = sqrt((DsSte./meanDsqrdCenPerDrop).^2 + (Ds.*steDsqrdCenPerDrop./meanDsqrdCenPerDrop.^2).^2);
%      errorbar(rDrop, y,yErr, '.','markerSize',20);
    plot(rDrop, y,'.', 'MarkerSize',20);
    hold on
    plot(fit1)
    legend off;
    yl = ylim;
    ylim([0,yl(2)]);
    xlabel('Drop radius [um]');
    ylabel('D(1 min)/<d^2> [1/min]');
    %%
if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
    FigCenteringMagnitude.PaperPositionMode = 'auto';
    print(FigCenteringMagnitude,fullfile(outputDir,'centering_magnitude'),'-dpdf');
end

%%
    SBduration = (ILast_all(indsB) - IFirst_all(indsB)).*[CCDATA(indsB).timeSep];
    SBO = [SBDATA.Orig];
    SBVelocity = [SBO.Vr];
    display(sprintf('symmetry breaking duration: %f +- %f minutes' ,mean(SBduration)/60, std(SBduration)/60));
    display(sprintf('mean symbreaking velocity: %f +- %f um/sec' ,mean(SBVelocity), std(SBVelocity)));

% %%
movieFig = figure('Position',[0,0,800,300]);
axScatter = subplot(1,3,1);
axBreaking = subplot(1,3,2);
axCentered = subplot(1,3,3);
for t=1:120
    clear Ds Rs
    for i=1:numel(CCDATA)
        Rs(i) = mean(CCDATA(i).dropRadius);
        %     Ds(i) = max(CCDATA(i).Orig.r);
        %     Ds(i) = CCDATA(i).Orig.r(min(length(CCDATA(i).Orig.r),80));
        Ds(i) = CCDATA(i).Orig.r(min(length(CCDATA(i).Orig.r),t));
    end
    cla(axScatter);
    hold(axScatter,'on');
    scatter(axScatter, Rs(indsC),Ds(indsC),60,'.');
    scatter(axScatter, Rs(indsB),Ds(indsB),60,'.');

    plot(axScatter, 15:60,(15:1:60)*0.75, 'r--');
    plot(axScatter, 15:60,(15:1:60)*SBCriterion);
    xlabel(axScatter, 'Droplet radius');
    ylabel(axScatter, 'Displacement');
    xlim(axScatter,[15,60]);
    cla(axBreaking);
    hold(axBreaking,'on');
    for j = indsB
        xB = (CCDATA(j).times - CCDATA(j).times(IFirst_all(j)))/60;
        yB = CCDATA(j).Orig.r;
%         yB = [0, CCDATA(j).Orig.VrSmooth(1:end-1).*CCDATA(j).Orig.VrSmooth(2:end)]./CCDATA(j).Orig.r;

        tp = min(t,length(CCDATA(j).times));
        plot(axBreaking,xB(1:tp), yB(1:tp));
        scatter(axBreaking,xB(tp), yB(tp), 30, [0 0 0], '.');
    end
    xlim(axBreaking,[-40,40]);
    ylim(axBreaking,[0,30]);
    xlabel(axBreaking,'Time [min]');
    ylabel(axBreaking,'Displacement [um]');

    cla(axCentered);
    hold(axCentered,'on');
    for j = indsC
        xS = (CCDATA(j).times)/60;
        yS = CCDATA(j).Orig.r;
%         yS = [0, CCDATA(j).Orig.VrSmooth(1:end-1).*CCDATA(j).Orig.VrSmooth(2:end)]./CCDATA(j).Orig.r;
        tp = min(t,length(CCDATA(j).times));
        plot(axCentered, xS(1:tp), yS(1:tp));
        scatter(axCentered, xS(tp), yS(tp), 30, [0 0 0], '.');
    end
    xlim(axCentered,[0,80]);
    ylim(axCentered,[0,30]);
    xlabel(axCentered,'Time [min]');
    ylabel(axCentered,'Displacement [um]');

    Movie(t) = getframe(movieFig);
    pause(0.01)
end
for extraFrame=1:20
    Movie(end+1) = getframe(movieFig);
end
v = VideoWriter('trackingMovie.avi','Motion JPEG AVI');
v.FrameRate = 10;
open(v)
writeVideo(v,Movie)
close(v)
