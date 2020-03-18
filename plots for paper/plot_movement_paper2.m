function [Fig, maR] = plot_movement_paper2(CCData, name)
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
    ax1 = subplot(1,3,1);
    Fig.PaperPositionMode = 'auto';
    MTimes = 0;
    colors = jet(S);
    for i=1:S
        x = CCData(i).Orig.x;
        y = CCData(i).Orig.y;
        z = CCData(i).Orig.z;
        r = CCData(i).Orig.r;
        times = CCData(i).times;
        if MTimes < max(times)
            MTimes = max(times);
        end
        dropRadius = CCData(i).dropRadius;
        meanDropRadius(i) = mean(dropRadius);
        dropEffectiveRadius = CCData(i).dropRadius - CCData(i).aggRadius;
        symBreaking = CCData(i).Orig.r ./ dropEffectiveRadius;
        
        plot(x,y,'Color', colors(i,:));
        axis equal
        axis off
        hold on
        
        tracks{i}=[times'/60, x', y', z'];
        tracksR{i}=[times'/60, r'];

    end
    viscircles([0,0],mean(meanDropRadius*0.75),'Color',[0.4,0.4,0.4],'LineStyle','--','LineWidth',0.5);
    mean(meanDropRadius)
    scalebar('XLen',20,'YLen',1, 'XUnit', '{\mu}m', 'Border', 'LN',...
        'FontSize', 8, 'Color', 'k', 'LineWidth', 1);

    scatter(0,0,'k','x');
    % ------------------ %
    
    tracks(cellfun('isempty', tracks)) = [];
%     ma = msdanalyzer(3, 'µm', 'min');
%     ma = ma.addAll(tracks);
%     ma = ma.computeMSD;
%     ma = ma.fitMSD(5);
%     ma = ma.fitLogLogMSD(5);
    
    maR = msdanalyzer(1, 'µm', 'min');
    maR = maR.addAll(tracksR);
    maR = maR.computeMSD;
    maR = maR.fitMSD(5);
    maR = maR.fitLogLogMSD(5);

    ax2 = subplot(1,3,2);
    ax2.OuterPosition(2:4) = ax1.Position(2:4);
    ax2.FontSize = 8;
    ax2.LabelFontSizeMultiplier = 1;
    ax2.TitleFontSizeMultiplier = 1.25;
    maR.plotMSD(ax2,[],false);
    maR.fitMeanMSD(false, [], 10, 'log')
    maR.fitMeanMSD(false, [], 10, 'linear')
    meanMSD = maR.getMeanMSD;
    display(sprintf('D at 1 min: %g +- %g', round(meanMSD(3,2)/2,2,'significant'), round(meanMSD(3,3)/2,1,'significant')));

    ax2.XScale = 'log';
    ax2.YScale = 'log';
    hold(ax2, 'on');
    plot(1:10,(1:10), '--k', 'LineWidth', 0.5, 'Color', [0.4,0.4,0.4]);
    plot(1:10, 20*(1:10).^2, '--k', 'LineWidth', 0.5, 'Color', [0.4,0.4,0.4]);
%     ma.plotMeanMSD(ax,false);
    ax2.XTick=[1,10];
    ax2.YTick=[1,10,100];
    xlim([0,60]);
    ylim([0,700]);
    % ------------------ %    
    maR = maR.computeVCorr;
    ax3 = subplot(1,3,3);
    ax3.OuterPosition(2:4) = ax1.Position(2:4);
    ax3.FontSize = 8;
    ax3.LabelFontSizeMultiplier = 1;
    ax3.TitleFontSizeMultiplier = 1.25;
    maR.plotMeanVCorr_smooth(ax3, true);
    ylim([-0.2,0.4]);
    ax3.YTick = [-0.2,0,0.2,0.4];

    xlim([0,14]);

end

