function s = scatter_symbreaking_oop(BV)
    dropR = cat(1,BV.dropR);
    blobRThetaPhiNormalized = [BV.blobRThetaPhiNormalized];
    blobRThetaPhiErrNormalized = [BV.blobRThetaPhiErrNormalized];
    blobRErrNormalized = sort(reshape(blobRThetaPhiErrNormalized(1,:),2,[]) - repmat(blobRThetaPhiNormalized(1,:),2,1));
    s = errorbar(dropR * 2, blobRThetaPhiNormalized(1,:),...
        abs(blobRErrNormalized(1,:)), blobRErrNormalized(2,:),'.');
    legend('off');
    ylim([0,1]);
end