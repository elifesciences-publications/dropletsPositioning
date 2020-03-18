function [Fig ,sections] = scatter_displacement_paper3(DIRS,scattercolor,sectionLines,format, outputDir, ax)
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

if exist('ax', 'var')
    axes(ax);
    Fig = ax.Parent;
else
    Fig = figure('Position',[200 200 350 250]);
    Fig.PaperPositionMode = 'auto';
    % figure name prefix
    Fig.Name = 'scatter displacement - ';
end

SBThreshold = 0.4;
for i = 1:S(1)
    % plot
    blobDistanceMinusPlus =[dropVectors(i,:).blobDistanceMinusPlus];
    rN = blobDistanceMinusPlus(1,:)./[dropVectors(i,:).dropEffectiveRadius];
    rN(rN>1) = 1;
    displacement_plot(i) = errorbar([dropVectors(i,:).dropRadius], blobDistanceMinusPlus(1,:),...
        abs(blobDistanceMinusPlus(2,:)), blobDistanceMinusPlus(3,:),'k.');
    % string to dispaly in legend
    displacement_plot(i).DisplayName = sprintf('%s, N=%d',dropVectors(i,1).description, length([dropVectors(i,:).dropRadius]));
    if exist('scattercolor','var') && scattercolor
        scatter([dropVectors(i,:).dropRadius] , blobDistanceMinusPlus(1,:), 10, [rN;1 - rN;zeros(1,length(rN))]','filled');
        colormap([0:0.01:1; 1 - (0:0.01:1); zeros(size(0:0.01:1))]');
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

    sigma = 5;
    uniformRgrid = linspace(dropRadiusSorted(1),dropRadiusSorted(end));
    [ri,r0] = meshgrid(uniformRgrid,dropRadiusSorted);
    di = repmat(SBsort,length(uniformRgrid),1);
    r = ri - r0;
    expo = exp(-(r.^2)/(2*sigma));
    norm = sum(expo);
    meanSymbreaking = sum(di'.*expo)./norm;
    SR = cumsum(meanSymbreaking(2:end).*diff(uniformRgrid))./(uniformRgrid(2:end)-uniformRgrid(1));
    CR = cumsum((1-meanSymbreaking(1:end-1)).*diff(uniformRgrid),'reverse')./(uniformRgrid(end)-uniformRgrid(1:end-1));
    FractionMarks=0.95;
    Ind = [];
    if ~exist('sectionLines','var') || sectionLines(1) < 0
        Ind = [Ind, find(SR-min(SR) < (max(SR)-min(SR))*FractionMarks,1)];
        Ind = [Ind, find(CR-min(CR) > (max(CR)-min(CR))*FractionMarks,1)];

        for sec=1:length(Ind)
            sectionLines(sec,1:2) = [mean(uniformRgrid(Ind(sec))),50];
        end
        
    end
    legend('off');
    % add description to figure name
%     Fig.Name = [Fig.Name, dropVectors(i,1).description];
%     if i<S(1)
%         Fig.Name = [Fig.Name, ', '];
%     elseif exist('append','var')
%         Fig.Name = [Fig.Name, append];
%     end
    hold on
end
ax = gca;
xlim([Lmin,Lmax]);
% XD = [displacement_plot.XData];
% YD = [displacement_plot.YData];
% [maxY,Ind] = max(YD);
% yl = [0,max(round(XD(Ind)/2),maxY)];
yl = [0,53];
ylim(yl);
ax.YTick = 0:30:yl(2);
ax.XTick = 0:15:Lmax;

% plot drop radius and effective radius
plot(Lmin:Lmax , (Lmin:Lmax) ,'k--');
plot(Lmin:Lmax , (Lmin:Lmax)*(1-(0.7^2/15/2)^(1/3)) ,'r--');

% % plot symmetry breaking threshold
% plot(Lmin:Lmax , (Lmin:Lmax)*SBThreshold ,'g--');

% plot vertical setion lines
% if exist('sectionLines','var') && sectionLines(1) > 0
%     hold on
%     for sl=1:size(sectionLines,1)
%         y = 1:sectionLines(sl,2);
%         x = sectionLines(sl,1) * ones(size(y));
%         plot(x,y,'b:', 'LineWidth',1);
%     end
% end
hold off
ax.FontSize = 8;
ax.LabelFontSizeMultiplier = 1;
ax.TitleFontSizeMultiplier = 1.25;

xlabel('Drop radius [{\mu}m]','FontSize',8);
ylabel('Displacement [{\mu}m]','FontSize',8);

% h = title(dropVectors(i,1).description, 'FontSize', 10, 'HorizontalAlignment','left');
% pos = h.Position;
% pos = [10,pos(2:end)];
% h.Position = pos;
if exist('scattercolor','var') && scattercolor && ~exist('ax','var')
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