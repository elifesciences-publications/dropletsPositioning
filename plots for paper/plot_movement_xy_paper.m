function [Fig, ma] = plot_movement_paper(CCData, name)
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
    subplot = @(M,N,P) subtightplot(M,N,P,[0.06,0.08],[0.185,0.03],[0.015,0.015]);
    S = numel(CCData);
    Fig = figure('Position',[0,0,600,200]);% 'Name', sprintf('Droplets Radius %d - %d um', RLimits), 'NumberTitle','off');
    Fig.Name = name;
    subplot(1,3,1);
    Fig.PaperPositionMode = 'auto';
    MTimes = 0;
    colors = jet(S);
    for i=1:S
        x = CCData(i).Orig.x;
        y = CCData(i).Orig.y;
        z = CCData(i).Orig.z;
        times = CCData(i).times;
        if MTimes < max(times)
            MTimes = max(times);
        end
        dropRadius = CCData(i).dropRadius;
        meanDropRadius(i) = mean(dropRadius)
%         if mean(dropRadius) <= RLimits(1) || mean(dropRadius) > RLimits(2)
%             continue
%         end
        dropEffectiveRadius = CCData(i).dropRadius - CCData(i).aggRadius;
        symBreaking = CCData(i).Orig.r ./ dropEffectiveRadius;
        
%         col = times;
%         xNorm = x./ dropEffectiveRadius;
%         yNorm = y./ dropEffectiveRadius;
%         zNorm = z./ dropEffectiveRadius;
        
%         plot(xNorm,yNorm,'Color', colors(i,:));
        plot(x,y,'Color', colors(i,:));
        axis equal
        axis off
        hold on
        
        tracks{i}=[times'/60, x', y', z'];
    end
%     viscircles([0,0],1,'Color','k');
    viscircles([0,0],mean(meanDropRadius*0.75),'Color',[0.4,0.4,0.4],'LineStyle','--','LineWidth',0.5);
    mean(meanDropRadius)
    scalebar('XLen',20,'YLen',1, 'XUnit', '{\mu}m', 'Border', 'LN',...
        'FontSize', 8, 'Color', 'k', 'LineWidth', 1);

    scatter(0,0,'k','x');
%     title('Tracks (normalized displacement)');
%     title('Tracks');
    % ------------------ %
    
    tracks(cellfun('isempty', tracks)) = [];
    ma = msdanalyzer(3, '�m', 'min');
    ma = ma.addAll(tracks);
    ma = ma.computeMSD;
    ax = subplot(1,3,2);
    ax.FontSize = 8;
    ax.LabelFontSizeMultiplier = 1;
    ax.TitleFontSizeMultiplier = 1.25;
    ma.plotMSD(ax,[],false);
    ax.XScale = 'log';
    ax.YScale = 'log';
    hold(ax, 'on');
    plot(1:10,(1:10), '--k', 'LineWidth', 0.5, 'Color', [0.4,0.4,0.4]);
    plot(1:10, 20*(1:10).^2, '--k', 'LineWidth', 0.5, 'Color', [0.4,0.4,0.4]);
%     ma.plotMeanMSD(ax,false);
    ax.XTick=[1,10];
    xlim([0,60]);
    ylim([0,700]);
    % ------------------ %    
    ma = ma.computeVCorr;
    ax = subplot(1,3,3);
    ax.FontSize = 8;
    ax.LabelFontSizeMultiplier = 1;
    ax.TitleFontSizeMultiplier = 1.25;
    ma.plotMeanVCorr_smooth(ax, true);
    ylim([-0.2,0.3]);
    ax.YTick = [-0.2,0,0.2,0.4];
    xlim([1,20]);
%     ylabel('V-V correlation');
    % ------------------ %
%     ma = ma.computeAngleCorr;
%     ax = subplot(2,2,4);
%     ma.plotMeanAngleCorr(ax, true);
%     ylim([-0.5,0.5]);
%     xlim([0.5,20]);
    % ------------------ %
%     suptitle_paper(Fig.Name,9,'FontWeight','bold');

end
% print(Fig,fullfile(DIR,'xy_track.eps'),'-depsc');

