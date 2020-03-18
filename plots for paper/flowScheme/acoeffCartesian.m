function a = acoeffCartesian(r0, d, k, beta, p,t,u,time)
% Triangle point indices
it1 = t(1,:);
it2 = t(2,:);
it3 = t(3,:);

% Find centroids of triangles
x = (p(1,it1)+p(1,it2)+p(1,it3))/3;
y = (p(2,it1)+p(2,it2)+p(2,it3))/3;

uintrp = pdeintrp(p,t,u); % Interpolated values at centroids

M = sqrt(x.^2 + y.^2 + d^2 - 2*x*d);
a = -k*(3 - 2*r0./M) + beta;