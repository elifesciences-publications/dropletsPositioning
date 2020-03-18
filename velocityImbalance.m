function CCData = velocityImbalance(CCData, images, ringRadiusWidth, ringStart);
%     ringRadiusWidth = 4;
%     ringStart = 2:ringRadiusWidth:20;
    Rs = [ringStart, ringStart(end) + ringRadiusWidth];
    for i=1:length(ringStart)
        [CCData.Kymograph(:,:,i), theta] = ringKymograph(CCData, images, ringStart(i) ,ringRadiusWidth, 'additive', 0);
        CCData.KymographTheta = theta;
%         Kymograph = CCData.Kymograph((CCData.lastMagnetFrame + 1):end,:,i);
        Kymograph = CCData.Kymograph(:,:,i);
        CCData.Orig.intensityImbalance(i,:) = -sin(theta) * Kymograph' * 1e-5;
       
        CCData.Rot.intensityImbalance(i,:) = -sin(theta + CCData.Theta) * Kymograph' * 1e-5;
    end
    CCData.KymographTheta = theta;
    CCData.KymographRs = Rs;
end