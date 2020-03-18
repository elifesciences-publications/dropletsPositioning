classdef drop < matlab.mixin.Copyable
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        numOfPlanes = 0;
        images = {};
        radius = 0;
        centerPlane = [];
        blobs = {};
        blobPlane = [];
        blobCenters = [];
        location = [];
        center = [];
        originFile = [];
        planesPerPixel = 0;
        micronsPerPixel = 0;
        micronsPerPlane = 0;
        blobRfactor = (0.7^2/15/2)^(1/3);
    end
    
    methods
        function obj = drop(input)
            if nargin > 0
                if isnumeric(input)
                    obj.numOfPlanes = input;
                    obj.images = cell(1,input);
                    obj.radius = zeros(input,1);
                    obj.blobs = cell(input,1);
                    obj.blobCenters = zeros(input,2);
                elseif isstruct(input)
                    if numel(input) == 1
                        obj.numOfPlanes = length(input.images);
                        obj.images = reshape(input.images,1,[]);
                        obj.radius = reshape(input.radius,[],1);
                        obj.location = input.location;
                        obj.center = input.center;
                        obj.planesPerPixel = input.plainsPerPixel;
                        obj.micronsPerPixel = input.micronsPerPixel;
                        obj.micronsPerPlane = obj.micronsPerPixel / obj.planesPerPixel;
                        obj.centerPlane = input.centerPlain;
                        obj.blobCenters = input.blobCenters;
                        obj.blobs = input.blobs;
                        obj.blobPlane = input.blobPlains;
                    else
                        obj(numel(input)) = drop();
                        for i=1:numel(input)
                            obj(i) = drop(input(i));
                        end
                    end
                end
            end
        end
        
        %         function BV = blob_vectors_vectorized(obj)
        %             BV.blobVec = [];
        %             BV.blobRThetaPhi = [];
        %             BV.blobVecNormalized = [];
        %             BV.blobRThetaPhiNormalized = [];
        %             BV.dropR = [];
        %             BV.blobRErr = [];
        %             BV.blobRErrNormalized = [];
        %             emptyIndex = cellfun('isempty',{obj.blobPlane}) | cellfun('isempty',{obj.centerPlane});
        %             notEmptyIndex = setdiff(1:length(obj), (1:length(obj)) .* emptyIndex);
        %             objArray = obj(notEmptyIndex);
        %             BV.dropR = objArray.getRadius;
        %             BCenters = objArray.getBlobCenter;
        %
        %             BV.blobVec = ((BCenters - reshape([objArray.center],2,[])) .* repmat([objArray.micronsPerPixel],2,1))';
        %             BV.blobVec(:,3) = ([objArray.blobPlane] - [objArray.centerPlane]).*[objArray.micronsPerPlane];
        %             [BV.blobRThetaPhi(:,3),BV.blobRThetaPhi(:,2),BV.blobRThetaPhi(:,1)] = cart2sph(BV.blobVec(:,1),BV.blobVec(:,2),BV.blobVec(:,3));
        %
        %             blobVecError = repmat(BV.blobVec,1,1,2);
        %             blobVecError(:,3,1) = blobVecError(:,3,1) - [objArray.micronsPerPlane]';
        %             blobVecError(:,3,2) = blobVecError(:,3,2) + [objArray.micronsPerPlane]';
        %
        %             [~,~,BV.blobRErr] = cart2sph(blobVecError(:,1,:),blobVecError(:,2,:),blobVecError(:,3,:));
        %             BV.blobRErr = squeeze(BV.blobRErr);
        %             BV.blobRErrNormalized = BV.blobRErr./repmat(BV.dropR' .* (1 - [objArray.blobRfactor])',1,2);
        %             BV.blobRThetaPhi(:,2) = pi/2 - BV.blobRThetaPhi(:,2);
        %             BV.blobVecNormalized = BV.blobVec./repmat(BV.dropR' .* (1 - [objArray.blobRfactor]'),1,3);
        %             BV.blobRThetaPhiNormalized = BV.blobRThetaPhi;
        %             BV.blobRThetaPhiNormalized(:,1) = sqrt(dot(BV.blobVecNormalized,BV.blobVecNormalized,2));
        %
        %             ind = find(BV.blobRThetaPhiNormalized(:,1) >= 1);
        %             if ~isempty(ind )
        %                 warning(['drops ',num2str(ind'),' have blob at R > 1']);
        %                 ind
        %                 BV.blobRThetaPhiNormalized(ind,1)
        %                 %    blobVec(ind,:) = blobVec(ind,:)./repmat(blobRThetaPhiNormalized(ind,1),1,3);
        %                 BV.blobVecNormalized(ind,:) = BV.blobVecNormalized(ind,:)./repmat(BV.blobRThetaPhiNormalized(ind,1),1,3);
        %                 %     blobRThetaPhi(ind,1) = blobRThetaPhi(ind,1)./blobRThetaPhiNormalized(ind,1);
        %                 BV.blobRThetaPhiNormalized(ind,1) = 1;
        %             end
        %             ind = find(BV.blobRErrNormalized >= 1);
        %             if ~isempty(ind )
        %                 BV.blobRErrNormalized(ind) = 1;
        %             end
        %
        %             % find(blobRThetaPhi(:,1) < 0.5 & blobRThetaPhi(:,1) > 0)
        %
        %             ind = find(~(max(abs(BV.blobVec),[],2)));
        %             BV.blobVec(ind,:) = [];
        %             BV.blobVecNormalized(ind,:) = [];
        %             BV.blobRThetaPhi(ind,:) = [];
        %             BV.blobRThetaPhiNormalized(ind,:) = [];
        %             BV.dropR(ind) = [];
        %             blobVecError(ind,:) = [];
        %             BV.blobRErr(ind,:) = [];
        %             BV.blobRErr = sort(BV.blobRErr - repmat(BV.blobRThetaPhi(:,1),1,2),2);
        %             BV.blobRErrNormalized(ind,:) = [];
        %             BV.blobRErrNormalized = sort(BV.blobRErrNormalized - repmat(BV.blobRThetaPhiNormalized(:,1),1,2),2);
        
        function BV = blob_vectors(obj)
            emptyCells = cell(numel(obj),1);
            BV = struct('blobVec',emptyCells, 'blobRThetaPhi',emptyCells,...
                'blobVecNormalized',emptyCells, 'blobRThetaPhiNormalized',emptyCells,...
                'dropR',emptyCells, 'blobVecError',emptyCells, 'blobVecErrNormalized',emptyCells,...
                'blobRThetaPhiErr',emptyCells, 'blobRThetaPhiErrNormalized',emptyCells);
            if numel(obj) > 1
                BV = arrayfun(@(x) x.blob_vectors,obj);
                return;
            elseif isempty(obj.blobPlane) || isempty(obj.centerPlane)
                return;
            else
                BV.dropR = obj.getRadius('microns');
                
%                 BV.blobVec = (obj.getBlobCenter - obj.center') * obj.micronsPerPixel;
                blobCenter = obj.getBlobCenter;
                BV.blobVec = (blobCenter(:)' - obj.center(:)') * obj.micronsPerPixel;
                BV.blobVec = BV.blobVec(:);
                BV.blobVec(3) = (obj.blobPlane - obj.centerPlane) * obj.micronsPerPlane;
                BV.blobVecNormalized = BV.blobVec / (BV.dropR * (1-obj.blobRfactor));
                if norm(BV.blobVecNormalized) > 1
                    norm(BV.blobVecNormalized)
                    BV.blobVecNormalized(3) = sqrt(max(1 - norm(BV.blobVecNormalized(1:2))^2,0)) * sign(BV.blobVecNormalized(3));
                end
                BV.blobRThetaPhi = myCart2sph(BV.blobVec);
                BV.blobRThetaPhiNormalized = BV.blobRThetaPhi;
                BV.blobRThetaPhiNormalized(1) = norm(BV.blobVecNormalized);
                
                BV.blobVecError = repmat(BV.blobVec,1,2);
                BV.blobVecError(3,1) = BV.blobVecError(3,1) - obj.micronsPerPlane;
                BV.blobVecError(3,2) = BV.blobVecError(3,2) + obj.micronsPerPlane;
                BV.blobVecErrNormalized = BV.blobVecError / (BV.dropR * (1-obj.blobRfactor));
                for i=1:2
                    if norm(BV.blobVecErrNormalized(:,i)) > 1
                        BV.blobVecErrNormalized(3,i) = sqrt(max(1 - norm(BV.blobVecErrNormalized(1:2,i))^2,0)) * sign(BV.blobVecErrNormalized(3,i));
                    end
                end
                
                %                 blobVecErrorCell = num2cell(BV.blobVecError,2);
                %                 blobRThetaPhiErrCell = cell(3,1);
                %                 [blobRThetaPhiErrCell{:}] = cart2sph(blobVecErrorCell{:});
                %                 BV.blobRThetaPhiErr = flip(cell2mat(blobRThetaPhiErrCell));
                %                 BV.blobRThetaPhiErr(2,:) = pi/2 - BV.blobRThetaPhiErr(2,:);
                BV.blobRThetaPhiErr = myCart2sph(BV.blobVecError);
                BV.blobRThetaPhiErrNormalized = myCart2sph(BV.blobVecErrNormalized);
                %                 BV.blobRThetaPhiErrNormalized = BV.blobRThetaPhiErr;
                %                 BV.blobRThetaPhiErrNormalized(1,:) = BV.blobRThetaPhiErrNormalized(1,:) ./ (BV.dropR * (1-obj.blobRfactor));
                %                 [~,~,BV.blobRErr] = cart2sph(blobVecErrorCell{:});
                
                %                 if BV.blobRThetaPhiNormalized(1) > 1;
                %                     BV.blobRThetaPhiNormalized(1)
                %                     BV.blobVecNormalized(3) = sqrt(max(1 - norm(BV.blobVecNormalized(1:2))^2,0)) * sign(BV.blobVecNormalized(3));
                % %                     BV.blobVecNormalized = BV.blobVecNormalized / BV.blobRThetaPhiNormalized(1);
                %                     BV.blobRThetaPhiNormalized(1) = 1;
                %                 end
                %                 if BV.blobRThetaPhiErrNormalized(1,1) > BV.blobRThetaPhiErrNormalized(1,2)
                %                     BV.blobRThetaPhiErrNormalized(1,1) = flip(BV.blobRThetaPhiErrNormalized(1,1),2);
                %                 end
                %                 for i = 1:2
                %                     if BV.blobRThetaPhiErrNormalized(1,i) > 1
                %                         BV.blobVecErrNormalized(3,i) = sqrt(max(1 - norm(BV.blobVecErrNormalized(1:2,i))^2,0)) * sign(BV.blobVecErrNormalized(3));
                % %                         BV.blobVecErrNormalized(:,i) = BV.blobVecErrNormalized(:,i) / BV.blobRThetaPhiErrNormalized(1,i);
                %                         BV.blobRThetaPhiErrNormalized(1,i) = 1;
                %                     end
                %                 end
                
                %                 BV.blobRErrNormalized(BV.blobRErrNormalized >= 1) = 1;
                %                 BV.blobRErrNormalized = sort(BV.blobRErrNormalized - repmat(BV.blobRThetaPhiNormalized(1),1,2));
            end
        end
        function R = getRadius(obj,scale)
            if ~exist('scale','var')
                scale = 'microns';
            end
            if ~isequal(scale, 'microns') && ~isequal(scale,'pixels')
                warning('scale not recognized, using microns');
                scale = 'microns';
            end
            emptyIndex = cellfun('isempty',{obj.centerPlane});
            notEmptyIndex = setdiff(1:length(obj),emptyIndex .* (1:length(obj)));
            if isempty(notEmptyIndex)
                R = [];
                return;
            else
                centerPlanes = [obj.centerPlane];
                centerPlanes(centerPlanes < 1) = 1;
                allRadii = [obj(notEmptyIndex).radius];
                radiusIndices = sub2ind(size(allRadii),centerPlanes,1:length(centerPlanes));
                if isequal(scale,'microns')
                    R = allRadii(radiusIndices).*[obj(notEmptyIndex).micronsPerPixel];
                elseif isequal(scale,'pixels')
                    R = allRadii(radiusIndices);
                end
            end
            %             if ~isempty(obj.centerPlane) && obj.centerPlane ~=0
            %                 R = obj.radius(obj.centerPlane);
            %             else
            %                 R=nan;
            %             end
        end
        
        function B = getBlobCenter(obj)
            emptyIndex = cellfun('isempty',{obj.blobPlane});
            notEmptyIndex = setdiff(1:length(obj),emptyIndex .* (1:length(obj)));
            if isempty(notEmptyIndex)
                B = double.empty(2,0);
                return;
            else
                
                blobPlanes = [obj.blobPlane];
                allBlobCenters = reshape([obj(notEmptyIndex).blobCenters],obj(1).numOfPlanes,2,[]);
                 blobIndices = sub2ind(size(allBlobCenters),max(blobPlanes,1),ones(1,length(blobPlanes)),1:length(blobPlanes));
%                blobIndices = sub2ind(size(allBlobCenters),min(max(blobPlanes,1),length(blobPlanes)),ones(1,length(blobPlanes)),1:length(blobPlanes));

%                blobIndices(2,:) = sub2ind(size(allBlobCenters),min(max(blobPlanes,1),length(blobPlanes)),2 * ones(1,length(blobPlanes)),1:length(blobPlanes));
                blobIndices(2,:) = sub2ind(size(allBlobCenters),max(blobPlanes,1),2 * ones(1,length(blobPlanes)),1:length(blobPlanes));
             
                
                B = allBlobCenters(blobIndices);
            end
            %                 if ~isempty(obj.blobPlane) && obj.blobPlane ~=0
            %                     B = obj.blobCenters(obj.blobPlane,:);
            %                 else
            %                     B=nan;
            %                 end
        end
        function detectBlobInPlane2(obj,plane)
            Image = obj.images{plane};
            E = edge(Image,0.05);
            ED = imdilate(E,strel('disk',5));
            EC = imerode(ED,strel('disk',5));
            if obj.radius(plane) ~= 0
                R = round(obj.radius(plane)*0.95); %changed from 0.9 to 0.95
            else
                R = round(obj.radius(obj.centerPlane)*0.95); %changed from 0.9 to 0.95
            end
            C = round(size(Image)/2);
            [centers, radii] = imfindcircles(ED,round([R*0.7 R]),'ObjectPolarity','bright','Sensitivity',0.95);
            relCenters = centers - length(Image)/2;
            ind = sqrt(diag(relCenters*relCenters')) > length(Image)/20;
            centers(ind,:) = [];
            radii(ind) = [];
            if ~isempty(radii)
                [R,IndMinR] = min(radii);
                C = centers(IndMinR,:);
                R = 0.95*R;
            end
            %                 I = circularCrop(Image, C, R);
            ECC = circularCrop(EC, C, R);
            BWL = bwlabel(ECC);
            props = regionprops(BWL,'Area','Eccentricity','Centroid','FilledArea','ConvexArea');
            %                 ind = find([props.Area] >  (0.01 * pi*R^2));
            regions= 1:length(props);
            remove_inds = (([props.FilledArea]./[props.ConvexArea]) <0.3)...
                | ([props.Eccentricity] > 0.90) | ([props.FilledArea] < pi*R^2/200)...
                | ([props.Area]./[props.FilledArea] < 0.7);
            props(remove_inds) = [];
            regions(remove_inds) = [];
            if isempty(regions)
                return;
            end
            if sum([props.Area]) > 0.5 * pi*R^2
                return;
            end
            [m, indMaxArea] = max([props.Area]);
            LabelMaxArea = regions(indMaxArea);
            
            se90 = strel('line', 3, 90);
            se0 = strel('line', 3, 0);
            obj.blobs{plane} = imfill(imdilate(EC.*(BWL==LabelMaxArea), [se90 se0]));
        end
        
        function determineBlobPlane2(obj)
            i = 1;
            con = cell(obj.numOfPlanes,1);
            for plane = 1:length(obj.blobs)
                if isempty(obj.blobs{plane})
                    if ~isempty(con{i})
                        i = i+1;
                    end
                    continue;
                end
                if isempty(con{i})
                    con{i} = plane;
                else
                    con{i}(end+1) = plane;
                end
            end
            l = zeros(size(con));
            for i = 1:length(con)
                l(i) = length(con{i});
            end
            [m,ind] = max(l);
            if m == 0
                obj.blobPlane = [];
                return
            end
            s = zeros(m,1);
            for i = 1:m
                P = obj.blobs{con{ind}(i)};%.*K{con{ind}(i)};
                s(i) = sum(sum(P));
            end
            [~, ind2] = max(s);
            obj.blobPlane = con{ind}(ind2);
            for plane = 1:obj.numOfPlanes
                if ~isempty(obj.blobs{plane})
                    props = regionprops(obj.blobs{plane},'Centroid');
                    obj.blobCenters(plane,:) = props.Centroid;
                end
            end
        end
        function detectBlob2(obj)
            %K = cell(obj.numOfPlanes,1);
            for plane = 1:obj.numOfPlanes
                obj.detectBlobInPlane2(plane);
            end
            obj.determineBlobPlane2;
        end
        
        function detectBlob(obj)
            K = cell(obj.numOfPlanes,1);
            for plane = 1:obj.numOfPlanes
                Image = obj.images{plane};
                E = edge(Image);
                if obj.radius(plane) ~= 0
                    R = round(obj.radius(plane)*0.95); %changed from 0.9 to 0.95
                else
                    R = round(obj.radius(obj.centerPlane)*0.95); %changed from 0.9 to 0.95
                end
                C = round(size(Image)/2);
                [centersB, radiiB] = imfindcircles(E,round([R*0.7 R]),'ObjectPolarity','bright','Sensitivity',0.92);
                [centersD, radiiD] = imfindcircles(E,round([R*0.7 R]),'ObjectPolarity','dark','Sensitivity',0.92);
                centers = [centersD; centersB];
                radii = [radiiD; radiiB];
                relCenters = centers - length(Image)/2;
                ind = sqrt(diag(relCenters*relCenters')) > length(Image)/20;
                centers(ind,:) = [];
                radii(ind) = [];
                if ~isempty(radii)
                    [R,IndMinR] = min(radii);
                    C = centers(IndMinR,:);
                end
                I = circularCrop(Image, C, R);
                E = circularCrop(E, C, R);
                [centersS, radiiS] = imfindcircles(E,round([R/20 R/5]),'ObjectPolarity','bright','Sensitivity',0.85);
                
                for i=1:length(radiiS)
                    I = circularMask(I, centersS(i,:), radiiS(i)+2);
                end
                I = imadjust(I);
                J = imopen(I,strel('disk',3));
                K{plane} = I - J;
                if max(max(K{plane})) < 0.3
                    continue;
                end
                gaussianFilter = fspecial('gaussian',[20 20],3);
                I = imfilter(imadjust(K{plane}),gaussianFilter,'same');
                CO = 0.2:0.1:0.4;
                B = cell(size(CO));
                L = cell(size(CO));
                n = cell(size(CO));
                props = cell(size(CO));
                for i=1:length(CO)
                    cutoff = CO(i);
                    B{i} = im2bw(I,cutoff);
                end
                [L{1},n{1}] = bwlabel(B{1});
                props{1} = regionprops(L{1},'Area');
                if sum([props{1}.Area]) > 0.5 * pi*R^2
                    continue;
                end
                for i=1:n{1}
                    temp = B{1};
                    temp(L{1} ~= i) = 0;
                    if props{1}(i).Area / sum(sum(temp.*B{2})) > 2.5
                        B{1}(L{1} == i) = 0;
                    end
                end
                B{2} = B{2} .* B{1};
                B{3} = B{3} .* B{1};
                for i=1:3
                    [L{i},n{i}] = bwlabel(B{i});
                    props{i} = regionprops(L{i},'Area');
                end
                for i=1:n{2}
                    temp = B{2};
                    temp(L{2} ~= i) = 0;
                    if props{2}(i).Area / sum(sum(temp.*B{3})) > 2.5
                        B{2}(L{2} == i) = 0;
                    end
                end
                B{3} = B{3} .* B{2};
                [L{3},n{3}] = bwlabel(B{3});
                props{3} = regionprops(L{3},'Area','Eccentricity');
                if isempty(props{3})
                    continue;
                end
                [m, ind] = max([props{3}.Area]);
                if m < pi*R^2/100
                    continue;
                end
                B{3}(L{3} ~=ind) = 0;
                if props{3}(ind).Eccentricity > 0.96
                    continue
                end
                if max(max(B{3}.*K{plane})) - min(min(B{3}.*K{plane})) < 0.2
                    continue;
                end
                
                se90 = strel('line', 3, 90);
                se0 = strel('line', 3, 0);
                obj.blobs{plane} = imfill(imdilate(B{3}, [se90 se0]));
            end
            i = 1;
            con = cell(cell(obj.numOfPlanes,1));
            for plane = 1:length(obj.blobs)
                if isempty(obj.blobs{plane})
                    if ~isempty(con{i})
                        i = i+1;
                    end
                    continue;
                end
                if isempty(con{i})
                    con{i} = plane;
                else
                    con{i}(end+1) = plane;
                end
            end
            l = zeros(size(con));
            for i = 1:length(con)
                l(i) = length(con{i});
            end
            [m,ind] = max(l);
            if m == 0
                obj.blobPlane = [];
                return
            end
            s = zeros(m,1);
            for i = 1:m
                P = obj.blobs{con{ind}(i)}.*K{con{ind}(i)};
                s(i) = sum(sum(P));
            end
            [~, ind2] = max(s);
            obj.blobPlane = con{ind}(ind2);
            for plane = 1:obj.numOfPlanes
                if ~isempty(obj.blobs{plane})
                    props = regionprops(obj.blobs{plane},'Centroid');
                    obj.blobCenters(plane,:) = props.Centroid;
                end
            end
        end
        
        %         function findCenterPlane(obj)
        %             plane=1;
        %             prevRad = 0;
        %             while (plane <= obj.numOfPlanes && obj.radius(plane) == 0)
        %                 plane = plane+1;
        %             end
        %             while (plane <= obj.numOfPlanes && obj.radius(plane) ~=0 )
        %                 if prevRad - obj.radius(plane) > obj.radius(plane)/40
        %                     break
        %                 end
        %                 prevRad = obj.radius(plane);
        %                 plane = plane + 1;
        %             end
        %             obj.centerPlane = plane - 1;
        %         end
        
        function centerPlane = findCenterPlane(obj) %new
            if numel(obj) > 1
                for i=1:numel(obj)
                    centerPlane(i) = findCenterPlane(obj(i));
                end
            else
                plane=1;
                prevRadius = 0;
                while (plane <= obj.numOfPlanes && obj.radius(plane) == 0)
                    plane = plane+1;
                end
                prevPlane = plane;
                while (plane <= obj.numOfPlanes)
                    thisRadius = obj.radius(plane);
                    if thisRadius == 0
                        plane = plane + 1;
                    elseif prevRadius^2 - thisRadius^2 < ((prevPlane - plane)/obj.planesPerPixel)^2 * 2/3
                        prevPlane = plane;
                        prevRadius = obj.radius(prevPlane);
                        plane = plane + 1;
                    else
                        break;
                    end
                end
                obj.centerPlane = prevPlane;
                centerPlane = prevPlane;
            end
        end
    end
end

