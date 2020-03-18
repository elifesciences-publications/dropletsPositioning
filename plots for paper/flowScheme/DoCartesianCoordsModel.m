R = 60;
r0 = R/5;
d = R/2;
k = 0.5;
alpha = 1;
beta = 1;

dropCirc = [1; 0; 0; R];
aggCirc = [1; d; 0; r0];
gd = [dropCirc, aggCirc];
ns = char('dropCirc','aggCirc');
ns = ns';
sf = 'dropCirc - aggCirc';
[dl,bt] = decsg(gd,sf,ns);
% figure;
% pdegplot(dl,'EdgeLabels','on','SubdomainLabels','on');
% axis equal

f = @(varargin)fcoeffCartesian(r0, d, k, alpha,  varargin{:});
a = @(varargin)acoeffCartesian(r0, d, k, beta, varargin{:});
c = 0;
model = createpde(1);
geometryFromEdges(model,dl);
% figure;
% pdegplot(model,'EdgeLabels','on','SubdomainLabels','on');
applyBoundaryCondition(model,'Edge',1:4,'u',0);

generateMesh(model,'Hmax',2);
u = pdenonlin(model,c,a,f, 'Jacobian' ,'full');
%%
Fig = figure('Position',[0,0,900,900]);
pdeplot(model, 'xydata',u);%,'zdata', u);

% generateMesh(model,'Hmax',20);
% xy = model.Mesh.Nodes;
[p,e,t] = initmesh(dl,'Hmax',20);

xy = (p(:,t(1,:))+p(:,t(2,:))+p(:,t(3,:)))/3;

xdy = xy;
xdy(1,:) = xdy(1,:) - d;
v = -k*(xdy - r0*xdy./repmat(sum(xdy.*xdy),2,1));

colormap('jet')
% cmapG = (0:0.01:1)';
% cmapR = zeros(size(cmapG));
% cmapB = zeros(size(cmapG));
% cmap = [cmapR,cmapG,cmapB];
% colormap(cmap);
axis equal
ylim([0, R]);
xlim([-R,R]);
hold on
quiver(xy(1,:), xy(2,:), v(1,:), v(2,:),'g', 'LineWidth',1);
colorbar('off')
axis off
%%
Fig.PaperPositionMode = 'auto';
Fig.InvertHardcopy = 'off';
print(Fig, 'dropletModel','-dpng')
