function Fig = plot_movement_xy2(DIRS,zoom,offset,scalebarLength, sameScale)
% PLOT_MOVEMENT_XY
% function Fig = plot_movement_xy(DIRS,zoom)
% plot blob track in x-y directions, and MSD of the movement
%
% Input:
% DIRS       cell array of data directories, columns will be loaded together and
% plotted in a different color.
% zoom      Zoom factor for the track plot.
%           Sets axis limits to dropRadius/zoom.
%           Use higer zoom for smaller movem
%
% Output:
% Fig       Figure handle.
subplot = @(M,N,P) subtightplot(M,N,P,[0,0],[0,0.1],[0,0]);

% default zoom = 1;
if ~exist('zoom','var')
    zoom = 1;
end
if ~exist('offset','var')
    offset = [0,0];
end
if length(offset) < 2
    offset(2) = offset(1);
end
if ~exist('scalebarLength','var')
    scalebarLength = -1;
end
if ~exist('sameScale','var')
    sameScale = false;
end
% read data
S = size(DIRS);
fields={'blobXYZ','times','dropRadius','blobDistanceMinusPlus','dropEffectiveRadius'};
DIR=DIRS{1};
% figure size 500x300
Fig = figure('Position',[100 100 500*S(1) 300]);
Fig.PaperPositionMode = 'auto';
MTimes = 0;
for i=1:S(1)
    dropVectors = loadDropsVectors(DIRS(i),fields,true);
    logfile = ls(fullfile(DIRS{i},'*.log'));
    XYZ = dropVectors.blobXYZ;
    times = dropVectors.times;
    if MTimes < max(times)
        MTimes = max(times);
    end
    dropRadius = dropVectors.dropRadius;
    dropEffectiveRadius = dropVectors.dropEffectiveRadius;
    symBreaking = dropVectors.blobDistanceMinusPlus(1,:)./dropEffectiveRadius;
    
    % XYZ = dlmread(fullfile(DIR,'blobXYZ'));
    % times = dlmread(fullfile(DIR,'times'));
    % dropRadius = dlmread(fullfile(DIR,'dropRadius'));
    
    % use subtightplot function instead of subplot
    %subplot = @(M,N,P) subtightplot(M,N,P,[0.1,0.1],[0.1,0.08],[0.14,0.06]);
    
    subplot(1,S(1)+1,i);
    hold on
    
    x = XYZ(1,:);
    y =  XYZ(2,:);
    % col = symBreaking;
    % ci = 0:0.01:1;
    % colormap([ci;1 - ci;zeros(1,length(ci))]');
    % caxis([0,1]);
    col = times;
    lim(i) = dropRadius(1)/zoom;
    surface([x;x],[y;y],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
    % scatter(x,y,50,col,'.');
    % caxis([0,MTimes]);
    % colormap('copper');
    % c = colorbar('east');
    % c.FontSize = 16;
    
    % c.Ticks = [0,1];
    % c.TickLabels = {'Symmetric', 'Polar'};
    % c.Ticks = [1,max(times)];
    % c.TickLabels = {'0', [num2str(c.Ticks(end)),' seconds']};
    % c.Label.String = 'time';
    % c.Label.FontSize = 16;
    
    xlim([-lim(i),lim(i)] + offset(1));
    ylim([-lim(i),lim(i)] + offset(2));
    % xlabel('x [microns]','FontSize',14);
    % ylabel('y [microns]','FontSize',14);
    viscircles([0,0],dropEffectiveRadius(1),'Color','k');
    scatter(0,0,'k','x');
    axis equal
    axis off
    if scalebarLength > 0
        scalebar('XLen',scalebarLength,'YLen',1, 'XUnit', '{\mu}m','Border', 'LN', 'FontSize', 16);
    end
    title(sprintf('D=%d{\\mu}m',round(mean(dropRadius(1)) * 2)));
end
maxLim = max(lim);
for i=1:S(1)+1
    subplot(1,S(1)+1,i);
    MTimes = round(MTimes,-1);
    caxis([0,MTimes]);
%     colormap('copper');
    colormap('jet');
    if i == S(1)+1
        ax = gca;
        P = ax.Position;
        Pnew = [P(1),0.1,0.15,0.6];
        ax.Position = Pnew;
        axis off
        c = colorbar();
        c.FontSize = 16;
        c.Ticks = [1,MTimes];
        c.TickLabels = {'0', [num2str(MTimes/60),' min']};
%         c.Label.String = 'time';
        c.Label.FontSize = 16;
    else
        if sameScale
            xlim([-maxLim,maxLim] + offset(1));
            ylim([-maxLim,maxLim] + offset(2));
        end
    end
end
print(Fig,fullfile(DIR,'xy_track.eps'),'-depsc');

