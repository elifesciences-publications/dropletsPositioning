function exportDropsData(params,DIR)
    ind = find(~cellfun('isempty',{params.BV.dropR}));
    blobXYZ = [params.BV.blobVec];
    dropRadius = [params.BV.dropR];
    effectiveRadius = dropRadius*(1 - (0.7^2/15/2)^(1/3));
    blobRThetaPhi = [params.BV.blobRThetaPhi];
    blobDistance = blobRThetaPhi(1,:);
    blobRThetaPhiErr = [params.BV.blobRThetaPhiErr];
    blobRError = sort(reshape(blobRThetaPhiErr(1,:),2,[]) - repmat(blobRThetaPhi(1,:),2,1));

    dlmwrite(fullfile(DIR,'dropRadius'),dropRadius);
    dlmwrite(fullfile(DIR,'dropEffectiveRadius'),effectiveRadius);
    dlmwrite(fullfile(DIR,'blobXYZ'),blobXYZ);
    dlmwrite(fullfile(DIR,'blobDistanceMinusPlus'),[blobDistance;blobRError]);
    if isfield(params,'times')
        dlmwrite(fullfile(DIR,'times'),params.times(ind));
    end
    
    if isfield(params,'description')
        FID = fopen(fullfile(DIR,'description'),'w');
        fprintf(FID,'%s\n\r',params.description);
        fclose(FID);
    end

%     FID = fopen(fullfile(DIR,'origin'),'w');
%     for row = 1:numel(params.filename)
%         fprintf(FID,'%s\n\r',params.filename{row});
%     end
%     fclose(FID);
end

    

