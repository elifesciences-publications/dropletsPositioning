function [Fig, CCIndices] = plot_movement_xy4(CCData, RLimits)
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
    subplot = @(M,N,P) subtightplot(M,N,P,[0.06,0.06],[0.13,0.07],[0.02,0.05]);
    CCIndices = [];
    S = numel(CCData);
    Fig = figure('Position',[200,200,1000,400], 'Name', sprintf('Droplets Radius %d - %d um', RLimits), 'NumberTitle','off');
    subplot(1,3,1);
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
        if mean(dropRadius) <= RLimits(1) || mean(dropRadius) > RLimits(2)
            continue
        end
        CCIndices = [CCIndices, i];
        dropEffectiveRadius = CCData(i).dropRadius - CCData(i).aggRadius;
        symBreaking = CCData(i).Orig.r ./ dropEffectiveRadius;
        
        col = times;
        xNorm = x./ dropEffectiveRadius;
        yNorm = y./ dropEffectiveRadius;
        zNorm = z./ dropEffectiveRadius;
        
        plot(xNorm,yNorm);
        axis equal
        axis off
        hold on
        
    end
    viscircles([0,0],1,'Color','k');
    scatter(0,0,'k','x');
    title('Tracks (normalized displacement)');
    % ------------------ %
    RHC = 0;
    times = 0:30:3600;
    sumR = zeros(size(times));
    sumRsqrd = zeros(size(times));
    numR = zeros(size(times));
    for i=1:numel(CCData)
        dropRadius = CCData(i).dropRadius;
        if mean(dropRadius) < RLimits(1) || mean(dropRadius) > RLimits(2)
            continue
        end
        normR = CCData(i).Orig.r./(dropRadius - CCData(i).aggRadius);
        RHC = RHC + histcounts(normR,0:0.05:1);
        StandardTimes = discretize(CCData(i).times, [times, times(end) + 30]);
        for t=1:numel(CCData(i).Orig.r)
            st = StandardTimes(t);
            sumR(st) = sumR(st) + normR(t);
            numR(st) = numR(st) + 1;
            sumRsqrd(st) = sumRsqrd(st) + normR(t)^2;
        end
    end
    meanR = sumR./numR;
    stdR = sqrt(sumRsqrd./numR - meanR.^2);
    steR = stdR./sqrt(numR);
    subplot(1,3,2)
    bar(0:0.05:0.95, RHC, 'histc');
    title('Normalized displacement histogram');
    xlabel('Normalized displacement');
    ylabel('Counts');
    xlim([0,1]);
    subplot(1,3,3)
    shadeVerticesY = [meanR + stdR, flip(meanR - stdR)];
    shadeVerticesX = [times, flip(times)];
    excludeInd = isnan(shadeVerticesY);
    patch(shadeVerticesX(~excludeInd),shadeVerticesY(~excludeInd),[0.8,0.8,0.8],'linestyle','none');
    hold on
    plot(times, meanR);
    xlim([0,max(times)]);
    ylim([0,1]);
    legend({'std', 'mean'});
    title('Mean normalized displacement');
    xlabel('Time');
    ylabel('Mean normalized displacement');

    suptitle(Fig.Name);
end
% print(Fig,fullfile(DIR,'xy_track.eps'),'-depsc');

