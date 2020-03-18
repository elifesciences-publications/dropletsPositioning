function f = fcoeffSpherical(r0, d, k, alpha, p,t,u,time)
% Triangle point indices
it1 = t(1,:);
it2 = t(2,:);
it3 = t(3,:);

% Find centroids of triangles
r = (p(1,it1)+p(1,it2)+p(1,it3))/3;
theta = (p(2,it1)+p(2,it2)+p(2,it3))/3;

[ur,ut] = pdegrad(p,t,u); % Approximate derivatives

ct = cos(theta);
st = sin(theta);
M = 1 - 2*d*ct + d^2;

f = ur.*(k*r.*(1 - d*ct)).*(1-r0./r./sqrt(M)) + ut.*(k*d.*st).*(r0./r./sqrt(M)) + alpha;