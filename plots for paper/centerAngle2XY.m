function [x,y] = centerAngle2XY(center,angle,length)
    lx = length.*cos(angle);
    ly = length.*sin(angle);
    x = [center(:,1)' - lx'/2; center(:,1)' + lx'/2];
    y = [center(:,2)' - ly'/2; center(:,2)' + ly'/2];
end