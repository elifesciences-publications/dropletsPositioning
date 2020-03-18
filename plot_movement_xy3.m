function Fig = plot_movement_xy3(CCData,zoom,offset,scalebarLength, sameScale)
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
S = numel(CCData);
fields={'blobXYZ','times','dropRadius','blobDistanceMinusPlus','dropEffectiveRadius'};
% figure size 500x300
Fig = figure('Position',[100 100 500*S(1) 300]);
Fig.PaperPositionMode = 'auto';
MTimes = 0;
for i=1:S
    x = CCData(i).Orig.x;
    y = CCData(i).Orig.y;
    z = CCData(i).Orig.z;
    times = CCData(i).times;
    if MTimes < max(times)
        MTimes = max(times);
    end
    dropRadius = CCData(i).dropRadius;
    dropEffectiveRadius = CCData(i).dropRadius - CCData(i).aggRadius;
    symBreaking = CCData(i).Orig.r ./ dropEffectiveRadius;
        
    % use subtightplot function instead of subplot
    %subplot = @(M,N,P) subtightplot(M,N,P,[0.1,0.1],[0.1,0.08],[0.14,0.06]);
    
    subplot(1,S(1)+1,i);
    hold on
    
    col = times;
    lim(i) = dropRadius(1)/zoom;
    surface([x;x],[y;y],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
    
    xlim([-lim(i),lim(i)] + offset(1));
    ylim([-lim(i),lim(i)] + offset(2));
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
% print(Fig,fullfile(DIR,'xy_track.eps'),'-depsc');

