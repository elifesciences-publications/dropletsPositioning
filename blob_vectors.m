        function BV = blob_vectors(drop)
            emptyCells = cell(numel(drop),1);
            BV = struct('blobVec',emptyCells, 'blobRThetaPhi',emptyCells,...
                'blobVecNormalized',emptyCells, 'blobRThetaPhiNormalized',emptyCells,...
                'dropR',emptyCells, 'blobVecError',emptyCells, 'blobVecErrNormalized',emptyCells,...
                'blobRThetaPhiErr',emptyCells, 'blobRThetaPhiErrNormalized',emptyCells, 'time', emptyCells);
            if numel(drop) > 1
                BV = arrayfun(@(x) blob_vectors(x),drop);
                return;
            elseif isempty(drop.aggregatePlane) || isempty(drop.dropletPlane)
                return;
            else
                BV.time = drop.time;
                BV.dropR = getDropletDiameter(drop)/2;
                BV.aggR = getAggregateDiameter(drop)/2;
                blobCenter = getAggregateCenter(drop);
                dropCenter = getDropletCenter(drop);
                BV.blobVec = (blobCenter(:)' - dropCenter(:)');
                BV.blobVec = BV.blobVec(:);
                BV.blobVec(3) = (drop.aggregatePlane - drop.dropletPlane) * drop.micronsPerPlane;
                BV.blobVecNormalized = BV.blobVec / (BV.dropR * (1-BV.aggR));
                if norm(BV.blobVecNormalized) > 1
                    norm(BV.blobVecNormalized)
                    BV.blobVecNormalized(3) = sqrt(max(1 - norm(BV.blobVecNormalized(1:2))^2,0)) * sign(BV.blobVecNormalized(3));
                end
                BV.blobRThetaPhi = myCart2sph(BV.blobVec);
                BV.blobRThetaPhiNormalized = BV.blobRThetaPhi;
                BV.blobRThetaPhiNormalized(1) = norm(BV.blobVecNormalized);
                
                BV.blobVecError = repmat(BV.blobVec,1,2);
                BV.blobVecError(3,1) = BV.blobVecError(3,1) - drop.micronsPerPlane;
                BV.blobVecError(3,2) = BV.blobVecError(3,2) + drop.micronsPerPlane;
                BV.blobVecErrNormalized = BV.blobVecError / (BV.dropR * (1-BV.aggR));
                for i=1:2
                    if norm(BV.blobVecErrNormalized(:,i)) > 1
                        BV.blobVecErrNormalized(3,i) = sqrt(max(1 - norm(BV.blobVecErrNormalized(1:2,i))^2,0)) * sign(BV.blobVecErrNormalized(3,i));
                    end
                end
            end
        end
        
        function diameter = getDropletDiameter(droplet)
            p = droplet.dropletPosition;
            if length(p) == 4
                diameter = (p(3) + p(4))*0.5 * droplet.micronsPerPixel;
            else
                diameter = 0;
            end
        end
        
        function center = getAggregateCenter(droplet)
            p = droplet.aggregatePosition;
            if length(p) == 4
                center = [p(1) + p(3)/2, p(2) + p(4)/2] * droplet.micronsPerPixel;
            else
                center = -1;
            end
        end
        
        function center = getDropletCenter(droplet)
            p = droplet.dropletPosition;
            if length(p) == 4
                center = [p(1) + p(3)/2, p(2) + p(4)/2] * droplet.micronsPerPixel;
            else
                center = -1;
            end
        end
        function diameter = getAggregateDiameter(droplet)
            p = droplet.aggregatePosition;
            if length(p) == 4
                diameter = (p(3) + p(4))*0.5 * droplet.micronsPerPixel;
            else
                diameter = 0;
            end
        end

