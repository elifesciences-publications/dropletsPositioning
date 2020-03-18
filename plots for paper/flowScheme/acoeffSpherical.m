function a = acoeffSpherical(r0, d, k, beta, p,t,u,time)
% Triangle point indices
it1 = t(1,:);
it2 = t(2,:);
it3 = t(3,:);

% Find centroids of triangles
r = (p(1,it1)+p(1,it2)+p(1,it3))/3;
theta = (p(2,it1)+p(2,it2)+p(2,it3))/3;

uintrp = pdeintrp(p,t,u); % Interpolated values at centroids

ct = cos(theta);
M = 1 - 2*d*ct + d^2;

a = -k*(3 - d*ct +2*r0./r./sqrt(M) -3 *d *ct *r0./r./sqrt(M) - d*r0*(ct - 1 -d*ct.^2 +d^2 *ct)./r./M.^1.5) + beta;