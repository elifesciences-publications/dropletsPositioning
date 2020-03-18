function dropVectors = makeDropVectors(droplets, description)
    if ~exist('description', 'var') || ~isstr(description)
        description = '';
    end
    positions = reshape([droplets.dropletPosition],4,[]);
    AggPositions = reshape([droplets.aggregatePosition],4,[]);
    centeres = positions(1:2,:) + positions(3:4,:) / 2;
    aggCenters = AggPositions(1:2,:) + AggPositions(3:4,:) / 2;
    zDisplacement = ([droplets.dropletPlane] - [droplets.aggregatePlane]) * droplets(1).micronsPerPlane;
    
    blobXYZ = [(aggCenters - centeres) * droplets(1).micronsPerPixel; zDisplacement];
    dropRadius = positions(3,:) * droplets(1).micronsPerPixel / 2;
    dropEffectiveRadius = dropRadius*(1 - (0.7^2/15/2)^(1/3));
    blobVecErrorUp = blobXYZ;
    blobVecErrorUp(3,:) = blobVecErrorUp(3,:) + droplets(1).micronsPerPlane;
    blobVecErrorDown = blobXYZ;
    blobVecErrorDown(3,:) = blobVecErrorDown(3,:) - droplets(1).micronsPerPlane;
    
    blobRThetaPhi = myCart2sph(blobXYZ);
    blobRThetaPhiErrUp = myCart2sph(blobVecErrorUp);
    blobRThetaPhiErrDown = myCart2sph(blobVecErrorDown);
    blobRError = sort([blobRThetaPhiErrUp(1,:); blobRThetaPhiErrDown(1,:)] - repmat(blobRThetaPhi(1,:),2,1));
    blobDistance = blobRThetaPhi(1,:);
    blobDistanceMinusPlus = [blobDistance;blobRError];
    dropVectors.blobXYZ = blobXYZ;
    dropVectors.dropRadius = dropRadius;
	dropVectors.description = description;
    dropVectors.dropEffectiveRadius = dropEffectiveRadius;
    dropVectors.blobDistanceMinusPlus = blobDistanceMinusPlus;
end
