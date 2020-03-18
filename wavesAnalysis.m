function peakI = wavesAnalysis(CCData,images)
    plane = 1;
    for frame=(CCData.lastMagnetFrame+1):numel(images);
        if iscell(images{1})
            image = images{frame}{plane};
        else
            image = images{plane,frame};
        end
        X = round((CCData.Xaggregate(frame) + 10 + CCData.aggRadius(frame)/CCData.calibration):size(image,2));
        Y = round(CCData.Yaggregate(frame)) + (-10:10);
        rect = image(Y,X);
        R = X - CCData.Xaggregate(frame);
        S = sum(rect) .* R;
        if ~isempty(S)
            [~,I] = max(S);
            peakI(frame) = (I + 10) * CCData.calibration;
            t(frame) = CCData.times(frame);
        end
    end
    V = CCData.Orig.VrSmooth((CCData.lastMagnetFrame + 1):end);
    figure; plot(t,peakI, CCData.times((CCData.lastMagnetFrame + 1):end), V);
end

