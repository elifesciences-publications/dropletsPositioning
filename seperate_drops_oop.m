function drops = seperate_drops_oop (montage, centers, radii, metrics, PADDING)
s = size(montage{1,1});
dropNum = 1;
for plain1 = 1:size(montage,2)
    for i = 1:length(radii{plain1})
        Ind = zeros(1,length(montage));
        drops(dropNum) = drop(length(montage));
        Ind(plain1) = i;
        drops(dropNum).radius(plain1) = radii{plain1}(i);
        for plain2 = (plain1+1):size(montage,2)
            for j = 1:length(radii{plain2})
                diffC = centers{plain1}(i,:) - centers{plain2}(j,:);
                if diffC*diffC' < ((radii{plain1}(i))^2)/16
                    Ind(plain2) = j;
                    drops(dropNum).radius(plain2) = radii{plain2}(j);
                    break;
                elseif (centers{plain2}(j,1) - centers{plain1}(i,1)) > radii{plain1}(i)/4
                    break;
                end
            end
        end
        [MR, plainMR] = max([drops(dropNum).radius]);
        centerMR = centers{plainMR}(Ind(plainMR),:);
        topEdge = round(centerMR(2) - MR - PADDING);
        bottomEdge =  round(centerMR(2) + MR + PADDING);
        leftEdge = round(centerMR(1) - MR - PADDING);
        rightEdge = round(centerMR(1) + MR + PADDING);
        topPad = max(0, 1 - topEdge);
        bottomPad = max(0, bottomEdge - s(1));
        leftPad = max(0, 1 - leftEdge);
        rightPad = max(0, rightEdge - s(2));
        rows = max(1, topEdge): min(s(1), bottomEdge);
        cols = max(1, leftEdge): min(s(2), rightEdge);
        for plain2 = 1:size(montage,2)
            drops(dropNum).location = flip(centerMR);
            drops(dropNum).images(:,plain2) = {zeros(1 + bottomEdge - topEdge,1 + rightEdge - leftEdge)};
            drops(dropNum).center = [MR + PADDING, MR + PADDING];
            drops(dropNum).images{plain2}(1 + topPad: end - bottomPad, 1 + leftPad: end - rightPad) = imadjust(montage{plain2}(rows,cols));
            if plain2 > plain1 && Ind(plain2) > 0
                centers{plain2}(Ind(plain2),:) = [];
                radii{plain2}(Ind(plain2)) = [];
                metrics{plain2}(Ind(plain2)) = [];
            end
        end
        dropNum = dropNum + 1;
    end
    if ~exist('drops','var')
        drops = drop.empty;
    end
end
