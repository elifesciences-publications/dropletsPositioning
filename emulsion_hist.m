function Fig = emulsion_hist(DATA)

% blobVec = zeros(length(DATA.drops),3);
% blobRThetaPhi = zeros(length(DATA.drops),3);
% dropR = zeros(length(DATA.drops),1);
[blobVec, blobRThetaPhi, blobVecNormalized,  blobRThetaPhiNormalized, dropR] = blob_vectors(DATA);
% for  i=1:length(DATA.drops)
%     DROP = DATA.drops(i);
%     if ~isempty(DROP.blobPlains) && ~isempty(DROP.centerPlain)
%         dropR(i) = DROP.radius(DROP.centerPlain);
% %         props = regionprops(blobs{i}{DATA.blobPlains(i)},'Centroid');
%         BC = DROP.blobCenters(DROP.blobPlains,:);
%         blobVec(i,1:2) = (BC - DROP.center)./dropR(i);
%         blobVec(i,3) = ((DROP.blobPlains - DROP.centerPlain)/DROP.plainsPerPixel)./dropR(i);
%         blobRThetaPhi(i,:) = [sqrt(blobVec(i,:)*blobVec(i,:)'),acos(blobVec(i,3)/sqrt(blobVec(i,:)*blobVec(i,:)')),atan2(blobVec(i,2),blobVec(i,1))];
%     end
% end
% ind = find(blobRThetaPhi(:,1) > 1);
% if ~isempty(ind )
% warning(['drops ',num2str(ind'),' have blob at R > 1']);
% end
% % find(blobRThetaPhi(:,1) < 0.5 & blobRThetaPhi(:,1) > 0)
% 
% ind = [ind;find(~(max(blobVec,[],2)))];
% blobVec(ind,:) = [];
% blobRThetaPhi(ind,:) = [];
% dropR(ind) = [];
Fig = figure;
subplot(2,2,2); bar(0:0.1:1,histc(blobRThetaPhiNormalized(:,1),0:0.1:1),'histc'); xlim([0,1]); title('$\frac{D_{blob}}{R_{drop}}$', 'Interpreter' ,'Latex','FontSize',14);
subplot(2,2,3); bar(linspace(0,pi,7),histc(blobRThetaPhiNormalized(:,2),linspace(0,pi,7)),'histc'); xlim([0,pi]); title('$\Theta$', 'Interpreter' ,'Latex','FontSize',14);
subplot(2,2,4); bar(linspace(-pi,pi,7),histc(blobRThetaPhiNormalized(:,3),linspace(-pi,pi,7)),'histc'); xlim([-pi,pi]); title('$\Phi$', 'Interpreter' ,'Latex','FontSize',14);
plotX = [blobVecNormalized(:,1),zeros(size(blobVecNormalized(:,1)))];
plotY = [blobVecNormalized(:,2),zeros(size(blobVecNormalized(:,2)))];
plotZ = [blobVecNormalized(:,3),zeros(size(blobVecNormalized(:,3)))];
subplot(2,2,1); plot3(plotX', plotY', plotZ','black'); title('$\frac{\vec{r}_{blob}}{R_{drop}}$', 'Interpreter' ,'Latex','FontSize',14);
hold on; scatter3(blobVecNormalized(:,1),blobVecNormalized(:,2),blobVecNormalized(:,3),dropR*15 - 150 ,blobRThetaPhiNormalized(:,1),'.');
cmap = colormap('jet');
cmap = cmap(floor(length(cmap)*min(blobRThetaPhiNormalized(:,1))) + 1 : ceil(length(cmap)*max(blobRThetaPhiNormalized(:,1))),:);
colormap(cmap);
colorbar;
set(Fig,'Units','pixels','Position', [0 0 580 580])
% spaceplots(Fig,[0.05,0.05,0.05,0.05],[0.15,0.05]);
end