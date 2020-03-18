function Fig = scatter_displacement_paper(DIRS,scattercolor,sectionLines,format, outputDir,append)
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

% limits on drop diameter
Lmin = 30;
Lmax = 121;

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
Fig = figure('Position',[100 100 350 250]);
Fig.PaperPositionMode = 'auto';
hold on

% figure name prefix
Fig.Name = 'scatter displacement - ';
for i = 1:S(1)
    % plot
    blobDistanceMinusPlus =[dropVectors(i,:).blobDistanceMinusPlus];
    rN = blobDistanceMinusPlus(1,:)./[dropVectors(i,:).dropEffectiveRadius];
    rN(rN>1) = 1;
    displacement_plot(i) = errorbar([dropVectors(i,:).dropRadius] * 2, blobDistanceMinusPlus(1,:),...
        abs(blobDistanceMinusPlus(2,:)), blobDistanceMinusPlus(3,:),'k.');
    % string to dispaly in legend
    displacement_plot(i).DisplayName = sprintf('%s, N=%d',dropVectors(i,1).description, length([dropVectors(i,:).dropRadius]));
    if exist('scattercolor','var') && scattercolor
        scatter([dropVectors(i,:).dropRadius] * 2, blobDistanceMinusPlus(1,:), 10, [rN;1 - rN;zeros(1,length(rN))]','filled');
        colormap([0:0.01:1; 1 - (0:0.01:1); zeros(size(0:0.01:1))]');
        c = colorbar;
%         c.Label.String = 'Displacement';
        c.FontSize = 8;
        c.Ticks = [0,1];
        c.TickLabels = {'Centered', 'Polar'};
    else
        scatter([dropVectors(i,:).dropRadius] * 2, blobDistanceMinusPlus(1,:), 10,'filled');
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
yl = [0,Lmax/2];
ylim(yl);
ax.YTick = 0:30:yl(2);
ax.XTick = 0:30:Lmax;

% plot drop radius and effective radius
plot(Lmin:Lmax , (Lmin:Lmax) / 2,'k--');
plot(Lmin:Lmax , (Lmin:Lmax)*(1-(0.7^2/15/2)^(1/3)) / 2,'r--');
% plot vertical setion lines
if exist('sectionLines','var') && sectionLines(1) > 0
    hold on
    for sl=1:size(sectionLines,1)
        y = 1:sectionLines(sl,2);
        x = sectionLines(sl,1) * ones(size(y));
        plot(x,y,'b:', 'LineWidth',1);
    end
end
hold off
ax.FontSize = 8;
ax.LabelFontSizeMultiplier = 1;
ax.TitleFontSizeMultiplier = 1.25;

xlabel('Drop Diameter [{\mu}m]','FontSize',8);
ylabel('Displacement [{\mu}m]','FontSize',8);

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
end
end