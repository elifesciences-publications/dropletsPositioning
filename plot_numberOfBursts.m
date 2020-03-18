function [Figs, fits] = plot_numberOfBursts(DATA, Threshold)
    if ~exist('Threshold', 'var')
        Threshold = 0.5;
    end
    DATATrimmed = [];
    for i=1:length(DATA)
        sb = DATA(i).Orig.r./DATA(i).dropRadius;
        maxSb(i) = max(sb);
        if maxSb(i) > 0.3
            [~,ILast1] = max(sb);
            ILast2 = find(sb<0.5,1,'last');
            ILast = max(10, min(ILast1, ILast2));
        else
            ILast = length(DATA(i).dropRadius);
        end
        DATATrimmed = [DATATrimmed, truncate(DATA(i),1:ILast)];
        VVcorrelationStep = 3;
        vVec = [DATATrimmed(i).Orig.Vx; DATATrimmed(i).Orig.Vy; DATATrimmed(i).Orig.Vz];
        Vr = DATATrimmed(i).Orig.VrSmooth;
        VVcorr0 = sum(vVec .* vVec);
        VVcorr = sum(vVec(:,1:end-VVcorrelationStep) .* vVec(:,(VVcorrelationStep+1):end));
        meanVVcorr0 = mean(VVcorr0);
        VVcorrNormalized = VVcorr/meanVVcorr0;
        VVcorrS = savitzkyGolayFilt(VVcorrNormalized, 1,0,5);
        Direction = vVec./repmat(sqrt(sum(vVec.^2)),3,1);
        DDcorr = sum(Direction(:,1:end-VVcorrelationStep) .* Direction(:,(VVcorrelationStep+1):end));
        DDcorrSmooth = savitzkyGolayFilt(DDcorr, 1,0,5);
       
        first = ceil((VVcorrelationStep+1)/2);
        last = ceil((VVcorrelationStep)/2);
        aboveThreshold = DDcorrSmooth > Threshold & Vr(first:end-last) > 0;
        labledbelowTrheshold = bwlabel(~aboveThreshold);
%         statsBelowThreshold = regionprops(labledbelowTrheshold, 'Area', 'PixelIdxList');
%         Inds = find([statsBelowThreshold.Area] <= 5);
%         if ~isempty(Inds)
%             if statsBelowThreshold(Inds(1)).PixelIdxList(1) == 1
%                 Inds = Inds(2:end);
%             end
%             if ~isempty(Inds) && statsBelowThreshold(Inds(end)).PixelIdxList(end) == length(DDcorrSmooth)
%                 Inds = Inds(1:end-1);
%             end
%             aboveThreshold(vertcat(statsBelowThreshold(Inds).PixelIdxList)) = 1;
%         end
        [labledAboveThreshold, numberOfBursts(i)] = bwlabel(aboveThreshold);
        
        statsAboveThreshold = regionprops(labledAboveThreshold, 'Area');
        meanBurstLength(i) = mean([statsAboveThreshold.Area] * DATA(i).timeSep)/60;
        dropRadius(i) = mean(DATA(i).dropRadius);
        trackLength(i) = DATA(i).times(ILast)/60;
    end
    meanBurstLength(isnan(meanBurstLength)) = 0;
    fits{1} = fit(dropRadius'*2, numberOfBursts', 'poly1');
    Figs(1) = figure; plot(fits{1}, dropRadius*2, numberOfBursts);
    xlabel('droplet diameter');
    ylabel('number of bursts');
    fitFormulaString = sprintf('fit: %.2gx + %.2g',fits{1}.p1, fits{1}.p2);
    annotation('textbox',[.6 .4 .4 .5],'String',fitFormulaString ,'FitBoxToText','on')
    legend off;
    Figs(1).Name = 'Number of movement bursts vs drop radius';
    
    fits{2} = fit(dropRadius'*2, numberOfBursts'./(trackLength'), 'poly1');
    Figs(2) = figure; plot(fits{2}, dropRadius*2, numberOfBursts./trackLength);
    xlabel('droplet diameter');
    ylabel('burst frequency [min^{-1}]');
    fitFormulaString = sprintf('fit: %.2gx + %.2g',fits{2}.p1, fits{2}.p2);
    annotation('textbox',[.6 .4 .4 .5],'String',fitFormulaString ,'FitBoxToText','on')
    legend off;
    Figs(2).Name = 'Frequency of movement bursts vs drop radius';

    fits{3} = fit(dropRadius'*2, meanBurstLength', 'poly1');
    Figs(3) = figure; plot(fits{3}, dropRadius*2, meanBurstLength);
    xlabel('droplet diameter');
    ylabel('mean burst length [min]');
    fitFormulaString = sprintf('fit: %.2gx + %.2g',fits{3}.p1, fits{3}.p2);
    annotation('textbox',[.6 .4 .4 .5],'String',fitFormulaString ,'FitBoxToText','on')
    legend off;
    Figs(3).Name = 'Mean length of movement bursts vs drop radius';

end