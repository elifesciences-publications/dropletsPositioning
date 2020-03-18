function partcircle(center, R, varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
hold on
for i=0:1
    ti = pi*i;
    t = linspace( ti, ti+pi/2, 50);
    x = R*cos(t) + center(1);
    y = R*sin(t) + center(2);
    
    plot(x,y, varargin{:}); axis equal;
end
hold off
end

