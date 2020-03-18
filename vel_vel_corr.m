function [VVcorr, stdVV] = vel_vel_corr(x,y,t,delta,factor)
dt = t((1+delta):end) - t(1:(end-delta));
velx = (x((1+delta):end) - x(1:(end-delta)))./dt;
vely = (y((1+delta):end) - y(1:(end-delta)))./dt;
N = length(velx);
Nh = floor(length(velx)/factor);
VVmatrix = nan(N,Nh);
if length(velx) ~= length(vely)
    error('vector lengths differ');
end
for i=1:Nh
    Ni = N+1-i;
    for j=1:1:Ni
        VVmatrix(j,i) = (velx(j+i-1)*velx(j) + vely(j+i-1)*vely(j));
    end
end
VVcorr = mean(VVmatrix,'omitnan')./mean(VVmatrix(:,1),'omitnan');
stdVV = std(VVmatrix,'omitnan')./mean(VVmatrix(:,1),'omitnan');
end
