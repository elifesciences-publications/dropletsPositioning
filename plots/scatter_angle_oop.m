function s = scatter_angle_oop(BV)
    dropR = cat(1,BV.dropR);
    blobRThetaPhi = [BV.blobRThetaPhi];
    blobRThetaPhiErr = [BV.blobRThetaPhiErr];
    blobThetaErr = sort(reshape(blobRThetaPhiErr(2,:),2,[]) - repmat(blobRThetaPhi(2,:),2,1));
    s = errorbar(dropR * 2, blobRThetaPhi(2,:),...
        abs(blobThetaErr(1,:)), blobThetaErr(2,:),'.');
    legend('off');
    ylim([0,pi]);
end