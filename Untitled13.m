r = z_drop.getRadius('pixels');
dx = round(r*0.8/sqrt(2));
blob0_center = z_drop.getBlobCenter - dx;
blob0_r = z_drop.getRadius('pixels') * z_drop.blobRfactor;
im0 = getRoi2(z_drop.images{1},dx,z_drop.center);
mask = circularCrop(ones(size(im0)),blob0_center,blob0_r);
center = blob0_center;
vars = {'displayGraphics',false,'windowing', true};
for t = 1:length(t_drops)
    t_drop = t_drops(t);
    im1 = getRoi2(t_drop.images{1}, dx, t_drop.center);
    if ~exist('prevP','var') || prevP < 0
        Ps = 1:10:z_drop.numOfPlanes;
        for z_ind = 1:length(Ps);
            z_plane = Ps(z_ind);
            im0 = getRoi2(z_drop.images{z_plane},dx,z_drop.center);
            [rotAngle(z_ind), displacement(z_ind,:), corrRot{z_ind}, corrDis{z_ind}] = findRotationTranslation_niv(im0, mask, im1, center, vars{:});
        end
        [pks,~,w,~] = cellfun(@findCorrPeak2, corrRot);
        [~,pi] = max(pks./w);
        prevP = Ps(pi);
    end
    Ps_fine = max(1,prevP-10):min(z_drop.numOfPlanes,prevP+10);
    clear rotAngleFine displacementFine  corrRotFine corrDisFine
    for z_ind = 1:length(Ps_fine);
        z_plane = Ps_fine(z_ind);
        im0 = getRoi2(z_drop.images{z_plane},dx,z_drop.center);
        [rotAngleFine(z_ind), displacementFine(z_ind,:), corrRotFine{z_ind}, corrDisFine{z_ind}] = findRotationTranslation_niv(im0, mask, im1, center, vars{:});
    end
    [pksF,~,wF,~] = cellfun(@findCorrPeak2, corrRotFine);
    pks2F = cellfun(@(x) max(x(:)), corrDisFine);
    [~,p1(t)] = max(pksF./wF);
    [~,p2(t)] = max(pks2F);
    plane2(t) = Ps_fine(p2(t));
    prevP=plane2(t);
end

%%
for i = 1:length(t_drops_sample2)
    i
    if i==1
        around_plane = plane(end);
    else
        around_plane = plane2(i-1);
    end
    delta_planes = 5;
    [translation2(i,:), theta2(i), plane2(i)] = rotation_translation_correlation(z_drop,t_drops_sample2(i),around_plane,delta_planes);
end

for i = 1:length(t_drops_sample)
    clear rgb_img;
    figure;
    c = z_drop.getBlobCenter;
    im0 = rotateAround(z_drop.images{plane(i)},c(2),c(1),theta(i),'bicubic');
    im1 = imshift(t_drops_sample(i).images{1},translation(i,:),0);
    xy = flip(ceil((size(im1) - size(im0)) / 2));
    if max(xy(1)) > 0
        wh = flip(size(im0) - 1);
        im1 = imcrop(im1, [xy + 1, wh]);
    elseif min(xy(1)) < 0
        xy = -xy;
        wh = flip(size(im1) - 1);
        im0 = imcrop(im0, [xy + 1, wh]);
    end
    rgb_img(:,:,1) = im0;
    rgb_img(:,:,2) = im1;
    rgb_img(:,:,3) = 0;
    
    subplot(2,2,1); imshow(im0);
    subplot(2,2,2); imshow(im1);
    subplot(2,2,3); imshow(abs(im0 - im1));
    subplot(2,2,4); imshow(rgb_img);
end
