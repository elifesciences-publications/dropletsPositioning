function [Fig ,sections] = scatter_displacement_paper2(DIRS,scattercolor,sectionLines,format, outputDir,append)
% SCATTER_DISPLACEMENT
% function Fig = scatter_displacement(DIRS,append)
% scatter plot of blob displacement and drop diameter for each drop in data
% figure saved to first directory in DIRS.
%
% input
% DIRS      cell array of data directories, columns will be loaded together and
% plotted in a different color.
%
% append    optional. string to append to figure name and filename.
% format    figure file format: '-dpdf', '-deps', '-dpng' etc
% output
% Fig       figure handle.

% limits on drop radius
Lmin = 30/2;
Lmax = 121/2;

if ~exist('format', 'var')
    format = '-dpdf';
end
% DIRS = varargin;
S = size(DIRS);

fields={'blobDistanceMinusPlus','dropRadius','dropEffectiveRadius'};
if iscellstr(DIRS)
    dropVectors = loadDropsVectors(DIRS,fields);
elseif isstruct(DIRS)
    dropVectors = DIRS;
end

% figure size 500x350
% Fig = figure('Position',[100 100 300 200]);
% Fig = figure('Position',[100 100 350 250]);
Fig = figure('Position',[100 100 278 172]);

Fig.PaperPositionMode = 'auto';
hold on

% figure name prefix
Fig.Name = 'scatter displacement - ';
SBThreshold = 0.4;
for i = 1:S(1)
    % plot
    blobDistanceMinusPlus =[dropVectors(i,:).blobDistanceMinusPlus];
    rN = blobDistanceMinusPlus(1,:)./[dropVectors(i,:).dropEffectiveRadius];
    rN(rN>1) = 1;
    if max(max(blobDistanceMinusPlus(2:3,:))) > 0
        displacement_plot(i) = errorbar([dropVectors(i,:).dropRadius], blobDistanceMinusPlus(1,:),...
            abs(blobDistanceMinusPlus(2,:)), blobDistanceMinusPlus(3,:),'k.', 'CapSize', 3);
    else
        displacement_plot(i) = scatter([dropVectors(i,:).dropRadius], blobDistanceMinusPlus(1,:),'k.');
    end
    % string to dispaly in legend
    displacement_plot(i).DisplayName = sprintf('%s, N=%d',dropVectors(i,1).description, length([dropVectors(i,:).dropRadius]));
    if exist('scattercolor','var') && scattercolor
        scatter([dropVectors(i,:).dropRadius] , blobDistanceMinusPlus(1,:), 10, [rN;1 - rN;zeros(1,length(rN))]','filled');
        colormap([0:0.01:1; 1 - (0:0.01:1); zeros(size(0:0.01:1))]');
        c = colorbar;
%         c.Label.String = 'Displacement';
        c.FontSize = 8;
        c.Ticks = [0,1];
        c.TickLabels = {'Centered', 'Polar'};
    else
        scatter([dropVectors(i,:).dropRadius] , blobDistanceMinusPlus(1,:), 10,'filled');
    end
     SB = blobDistanceMinusPlus(1,:)./[dropVectors(i,:).dropRadius];
     SB = im2bw(SB,SBThreshold);
     [dropRadiusSorted, sortInd]= sort([dropVectors(i,:).dropRadius]);
     indkeep = dropRadiusSorted <= Lmax & dropRadiusSorted >= Lmin;
     dropRadiusSorted = dropRadiusSorted(indkeep);
     sortInd = sortInd(indkeep);
     SBsort = SB(sortInd);
%      SBAccumulated = cumsum(SBsort)./(1:length(SBsort));
%      SBAccumulated = cumsum(SBsort(2:end).*diff(dropRadiusSorted))./(dropRadiusSorted(2:end)-dropRadiusSorted(1));
%      SBAccumulated = [1, SBAccumulated];
%     plot(dropRadiusSorted*2,SBAccumulated*60,'g');
% %     [dropRadiusSortedFlip, sortIndFlip]= sort([dropVectors(i,:).dropRadius],'descend');
% %     CenteredAccumulated = 1-SBAccumulated;
%     CenteredAccumulated = cumsum((1-SBsort(1:end-1)).*diff(dropRadiusSorted),'reverse')./(dropRadiusSorted(end)-dropRadiusSorted(1:end-1));
%     CenteredAccumulated(end+1) = 1;
%     plot(dropRadiusSorted*2, CenteredAccumulated*60);

    sigma = 5;
%     di = repmat(SBsort,length(SBsort),1);
%     [ri,r0] = meshgrid(dropRadiusSorted,dropRadiusSorted);
    uniformRgrid = linspace(dropRadiusSorted(1),dropRadiusSorted(end));
    [ri,r0] = meshgrid(uniformRgrid,dropRadiusSorted);
    di = repmat(SBsort,length(uniformRgrid),1);
    r = ri - r0;
    expo = exp(-(r.^2)/(2*sigma));
    norm = sum(expo);
    meanSymbreaking = sum(di'.*expo)./norm;
%     plot(dropRadiusSorted*2, meanSymbreaking*60);
%     plot(uniformRgrid*2, meanSymbreaking*60);
    SR = cumsum(meanSymbreaking(2:end).*diff(uniformRgrid))./(uniformRgrid(2:end)-uniformRgrid(1));
    CR = cumsum((1-meanSymbreaking(1:end-1)).*diff(uniformRgrid),'reverse')./(uniformRgrid(end)-uniformRgrid(1:end-1));
%     plot(uniformRgrid(2:end)*2, SR*60);
%     plot(uniformRgrid(1:end-1)*2, CR*60);

%     SR = cumsum(meanSymbreaking(1:end-1).*diff(uniformRgrid))./(uniformRgrid(end)-uniformRgrid(1));
%     CR = cumsum((1-meanSymbreaking(2:end)).*diff(uniformRgrid),'reverse')./(uniformRgrid(end)-uniformRgrid(1));
%     plot(uniformRgrid(2:end)*2, SR*60);
%     plot(uniformRgrid(1:end-1)*2, CR*60);

%     SR = cumsum(meanSymbreaking(2:end).*diff(dropRadiusSorted))./(dropRadiusSorted(2:end)-dropRadiusSorted(1));
%     SR = [1, SR];
%     plot(dropRadiusSorted*2, SR*60);
%     CR = cumsum((1-meanSymbreaking(1:end-1)).*diff(dropRadiusSorted),'reverse')./(dropRadiusSorted(end)-dropRadiusSorted(1:end-1));
%     CR(end+1) = 1;
%     plot(dropRadiusSorted(1:end-1)*2, CR*60);

%     uniformRgrid = linspace(dropRadiusSorted(1),dropRadiusSorted(end));
%     interpolatedSymbreaking = interp1(dropRadiusSorted, meanSymbreaking, uniformRgrid);
%     plot(uniformRgrid*2, interpolatedSymbreaking*60);
%     SRInterp = cumsum(interpolatedSymbreaking(2:end).*diff(uniformRgrid))./(uniformRgrid(2:end)-uniformRgrid(1));
%     SRInterp = [1, SRInterp];
%     plot(uniformRgrid*2, SRInterp*60); 
%     CRInterp = cumsum((1-interpolatedSymbreaking(1:end-1)).*diff(uniformRgrid),'reverse')./(uniformRgrid(end)-uniformRgrid(1:end-1));
%     plot(uniformRgrid(1:end-1)*2, CRInterp*60);

    FractionMarks=0.95;
    Ind = [];
    if ~exist('sectionLines','var') || isnan(sectionLines(1)) || sectionLines(1) < 0
% % %         Ind(1) = find(meanSymbreaking < FractionMarks(1),1)
% % %         Ind(2) = find(meanSymbreaking < FractionMarks(2),1)
% %         Ind = [Ind, find(SBAccumulated < max(SBAccumulated)*FractionMarks,1)];
% %         Ind = [Ind, find(CenteredAccumulated > max(CenteredAccumulated)*FractionMarks,1) - 1];
        Ind = [Ind, find(SR-min(SR) < (max(SR)-min(SR))*FractionMarks,1)];
        Ind = [Ind, find(CR-min(CR) > (max(CR)-min(CR))*FractionMarks,1)];
%         Ind = [Ind, find(SR-min(SR) > (max(SR)-min(SR))*FractionMarks,1)];
%         Ind = [Ind, find(CR-min(CR) < (max(CR)-min(CR))*FractionMarks,1)];

        for sec=1:length(Ind)
            sectionLines(sec,1:2) = [mean(uniformRgrid(Ind(sec))),50];
%             sectionLines(sec,1:2) = [mean(dropRadiusSorted(Ind(sec)-1:Ind(sec)))*2,50];
        end
%         Ind = [Ind, find(SRInterp < max(SRInterp)*FractionMarks,1)];
%         Ind = [Ind, find(CRInterp > max(CRInterp)*FractionMarks,1)];
% 
%         for sec=1:length(Ind)
%             sectionLines(sec,1:2) = [uniformRgrid(Ind(sec))*2,50];
%         end

    end
    legend('off');
    % add description to figure name
    Fig.Name = [Fig.Name, dropVectors(i,1).description];
    if i<S(1)
        Fig.Name = [Fig.Name, ', '];
    elseif exist('append','var')
        Fig.Name = [Fig.Name, append];
    end
end
ax = gca;
xlim([Lmin,Lmax]);
% XD = [displacement_plot.XData];
% YD = [displacement_plot.YData];
% [maxY,Ind] = max(YD);
% yl = [0,max(round(XD(Ind)/2),maxY)];
% yl = [0,53];
yl = [0,50];
ylim(yl);
ax.YTick = 0:30:yl(2);
ax.XTick = 0:15:Lmax;

% plot drop radius and effective radius
plot(Lmin:Lmax , (Lmin:Lmax) ,'k--');
plot(Lmin:Lmax , (Lmin:Lmax)*(1-(0.7^2/15/2)^(1/3)) ,'r--');

% % plot symmetry breaking threshold
% plot(Lmin:Lmax , (Lmin:Lmax)*SBThreshold ,'g--');

% plot vertical setion lines
if exist('sectionLines','var') && sectionLines(1) > 0
    hold on
    for sl=1:size(sectionLines,1)
        y = 1:sectionLines(sl,2);
        x = sectionLines(sl,1) * ones(size(y));
        plot(x,y,'--', 'LineWidth',0.5, 'color', [0.3,0.3,0.3]);
    end
end
hold off
ax.FontSize = 8;
ax.LabelFontSizeMultiplier = 1;
ax.TitleFontSizeMultiplier = 1.25;

xlabel('Drop radius [µm]','FontSize',8);
ylabel('Displacement [µm]','FontSize',8);

h = title(dropVectors(i,1).description, 'FontSize', 10, 'HorizontalAlignment','left');
pos = h.Position;
pos = [10,pos(2:end)];
h.Position = pos;
if exist('scattercolor','var') && scattercolor
    apos= ax.Position;
    cpos = c.Position;
    cpos(3) = cpos(3)/4;
    c.Position = cpos;
    ax.Position = apos;
end
if ischar(format)
    if strcmp(format,'-depsc')
        ext = '.eps';
    elseif strcmp(format,'-dpdf')
        ext = '.pdf';
    else
        ext = '';
    end
% h = legend(displacement_plot,'location','best');
    print(Fig,fullfile(outputDir,[Fig.Name, ext]),format);
%     export_fig(Fig, fullfile(outputDir,[Fig.Name, ext]), '-transparent');
end
%     figure; histogram(dropRadiusSorted,20);
sections = [];
if ~isempty(sectionLines)
    sections = sectionLines(:,1)';
end
end