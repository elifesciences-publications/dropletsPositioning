function Fig = emulsion_hist2(DATA)

% blobVec = zeros(length(DATA.drops),3);
% blobRThetaPhi = zeros(length(DATA.drops),3);
% dropR = zeros(length(DATA.drops),1);
% for  i=1:length(DATA.drops)
%     DROP = DATA.drops(i);
%     if ~isempty(DROP.blobPlains) && ~isempty(DROP.centerPlain)
%         dropR(i) = DROP.radius(DROP.centerPlain);
% %         props = regionprops(blobs{i}{DATA.blobPlains(i)},'Centroid');
%         BC = DROP.blobCenters(DROP.blobPlains,:);
%         blobVec(i,1:2) = (BC - DROP.center)*DROP.micronsPerPixel;
%         blobVec(i,3) = (DROP.blobPlains - DROP.centerPlain)*DROP.micronsPerPixel/DROP.plainsPerPixel;
%         blobRThetaPhi(i,:) = [sqrt(blobVec(i,:)*blobVec(i,:)'),acos(blobVec(i,3)/sqrt(blobVec(i,:)*blobVec(i,:)')),atan2(blobVec(i,2),blobVec(i,1))];
%     end
% end
[blobVec, blobRThetaPhi, blobVecNormalized,  blobRThetaPhiNormalized, dropR] = blob_vectors(DATA);

% ind = find(blobRThetaPhi(:,1) > 1);
% if ~isempty(ind )
% warning(['drops ',num2str(ind'),' have blob at R > 1']);
% end
% % find(blobRThetaPhi(:,1) < 0.5 & blobRThetaPhi(:,1) > 0)

ind = find(~(max(blobVec,[],2)));
blobVec(ind,:) = [];
blobRThetaPhi(ind,:) = [];
dropR(ind) = [];
Fig = figure;
subplot(2,2,2); bar(linspace(0,max(blobRThetaPhi(:,1)),10),histc(blobRThetaPhi(:,1),linspace(0,max(blobRThetaPhi(:,1)),10)),'histc'); title('$D_{blob}$', 'Interpreter' ,'Latex','FontSize',14);
subplot(2,2,3); bar(linspace(0,pi,7),histc(blobRThetaPhi(:,2),linspace(0,pi,7)),'histc'); xlim([0,pi]); title('$\Theta$', 'Interpreter' ,'Latex','FontSize',14);
subplot(2,2,4); bar(linspace(-pi,pi,7),histc(blobRThetaPhi(:,3),linspace(-pi,pi,7)),'histc'); xlim([-pi,pi]); title('$\Phi$', 'Interpreter' ,'Latex','FontSize',14);
plotX = [blobVec(:,1),zeros(size(blobVec(:,1)))];
plotY = [blobVec(:,2),zeros(size(blobVec(:,2)))];
plotZ = [blobVec(:,3),zeros(size(blobVec(:,3)))];
subplot(2,2,1); plot3(plotX', plotY', plotZ','black'); title('$\vec{r}_{blob}$', 'Interpreter' ,'Latex','FontSize',14);
hold on; scatter3(blobVec(:,1),blobVec(:,2),blobVec(:,3),dropR*5 - 150 ,blobRThetaPhi(:,1),'.');
% maxR = max(blobRThetaPhi(:,1));
% minR = min(blobRThetaPhi(:,1))
cmap = colormap('jet');
% cmap = cmap(floor(length(cmap)*min(blobRThetaPhi(:,1))) + 1 : ceil(length(cmap)*max(blobRThetaPhi(:,1))),:);
colormap(cmap);
colorbar;
set(Fig,'Units','pixels','Position', [0 0 580 580])
% spaceplots(Fig,[0.05,0.05,0.05,0.05],[0.15,0.05]);
end