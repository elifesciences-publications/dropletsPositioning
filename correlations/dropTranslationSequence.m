function [translation,plane1] = dropTranslationSequence(z_drop,t_drops)
r = z_drop.getRadius('pixels');
dx = round(r*0.8/sqrt(2));
blob0_center = z_drop.getBlobCenter - dx;
blob0_r = z_drop.getRadius('pixels') * z_drop.blobRfactor;
im0 = getRoi2(z_drop.images{1},dx,z_drop.center);
mask = circularCrop(ones(size(im0)),blob0_center,blob0_r*1.1);

% im0 = im0.*mask;
mask = imgaussfilt(mask,10);

center = blob0_center;
% vars = {'displayGraphics',false, 'windowing', true, 'sisLower',0.002,...
%     'sisUpper',0.6, 'rSlice', [15 70]};
vars = {'displayGraphics',false, 'windowing', true, 'sisLower',0,...
    'sisUpper',1, 'rSlice', [10 80]};



for t = 1:length(t_drops)
    display(sprintf ('t = %d',t));
    t_drop = t_drops(t);
    if isempty(t_drop.images)
        display(sprintf('drop %d is empty',t));
        
        continue
    end
    im1 = getRoi2(t_drop.images{1}, dx, t_drop.center);
    
%     if ~exist('prevP','var') || prevP < 0
%         Ps = 1:10:z_drop.numOfPlanes;
%         [rotAngleCoarse, displacementCoarse, corrRotCoarse, corrDisCoarse, ssimvalCoarse] = loop_corr(Ps,z_drop,mask,im1,center,dx,vars{:});
% %         [pksCoarse,~,wCoarse,pCoarse] = cellfun(@findCorrPeak2, corrRotCoarse);
% %         [~,pc] = max(pksCoarse./wCoarse.*pCoarse);
% %         [~,pc] = max(pCoarse);
%     [~,pc] = max(ssimvalCoarse);
%         %              [~,pc] = max(pksCoarse./wCoarse);
%         %        [~,pc] = max(cellfun(@(x) max(x(:)), corrDisCoarse));
%         %         [pksCoarse,wCoarser,wCoarsec] = cellfun(@findCorrPeak3, corrDisCoarse);
%         %         [~,pc] = max(pksCoarse.*sqrt(wCoarser.*wCoarsec));
%         Pc = Ps(pc);
%         Ps_fine = max(1,Pc-30):min(z_drop.numOfPlanes,Pc+30);
%     end
         Ps_fine = 1:z_drop.numOfPlanes;
    [rotAngleFine, displacementFine, corrRotFine, corrDisFine, ssimvalFine] = loop_corr(Ps_fine,z_drop,mask,im1,center,dx,vars{:});
    [pksF,~,wF,pF] = cellfun(@findCorrPeak2, corrRotFine);
    if t>1
        badInds = sum((displacementFine - repmat(translationPrev,size(displacementFine,1),1)).^2,2) > 100;
        pksF(badInds) = 0;
        wF(badInds) = inf;
        pF(badInds) = 0;
        ssimvalFine(badInds) = 0;
    end
    %     pks2F = cellfun(@(x) max(x(:)), corrDisFine);
    %     [pks3F,wr3F,wc3F] = cellfun(@findCorrPeak2, corrRotFine);
%     [~,p1(t)] = max(pksF./wF.*pF);
    %[~,p1(t)] = max(pF);
    [~,p1(t)] = max(ssimvalFine.*pF);
    %     [~,p2(t)] = max(pks2F);
    %     [~,p3(t)] = max(pks3F.*sqrt(wr3F.*wc3F));
    %     [~,p4(t)] = max(pks3F.*sqrt(wr3F.*wc3F).*pksF./wF);
    %     if t == 337
    %         t
    %     end
    plane1(t) = Ps_fine(p1(t));
    %     plane2(t) = Ps_fine(p2(t));
    %     plane3(t) = Ps_fine(p3(t));
    %     plane4(t) = Ps_fine(p4(t));
    translation(t,:) = displacementFine(p1(t),:);
    translationPrev = translation(t,:);
    %     prevP=plane(t);
end
end
function [rotAngle, displacement, corrRot, corrDis, ssimval] = loop_corr(Ps,z_drop,mask,im1,center,dx,varargin)
for z_ind = 1:length(Ps);
    z_plane = Ps(z_ind);
%     display(z_plane);
    %     if z_plane == 91
    %         z_plane
    %     end
    im0 = getRoi2(z_drop.images{z_plane},dx,z_drop.center);
    [rotAngle(z_ind), displacement(z_ind,:), corrRot{z_ind}, corrDis{z_ind}, ssimval(z_ind)] = findRotationTranslation_niv(im0, mask, im1, center, varargin{:});
end
end
