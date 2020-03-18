function s = scatter_displacement_oop(BV)
    dropR = cat(1,BV.dropR);
    blobRThetaPhi = [BV.blobRThetaPhi];
    blobRThetaPhiErr = [BV.blobRThetaPhiErr];
    blobRErr = sort(reshape(blobRThetaPhiErr(1,:),2,[]) - repmat(blobRThetaPhi(1,:),2,1));
    s = errorbar(dropR * 2, blobRThetaPhi(1,:),...
        abs(blobRErr(1,:)), blobRErr(2,:),'.');
    legend('off');
    [~,ind] = max(blobRThetaPhi(1,:));
    ylim([0,dropR(ind)]);
end