R = 100;
r0 = R/5;
d = R/2;
k = 0.5;
alpha = 1;
beta = 1;

geometryFunc = @(varargin) dropletfunctionSpherical(R, r0, d,varargin{:});
f = @(varargin)fcoeffSpherical(r0, d, k, alpha,  varargin{:});
a = @(varargin)acoeffSpherical(r0, d, k, beta, varargin{:});
c = 0;
model = createpde(1);
geometryFromEdges(model,geometryFunc);
figure;
pdegplot(model,'EdgeLabels','on','SubdomainLabels','on');
% applyBoundaryCondition(model,'Edge',3,'u',1);
% applyBoundaryCondition(model,'Edge',7,'u',1);
applyBoundaryCondition(model,'Edge',5,'u',0);

generateMesh(model,'Hmax',5);
u = pdenonlin(model,c,a,f, 'Jacobian' ,'full');
figure; pdeplot(model, 'xydata',u ,'zdata', u)