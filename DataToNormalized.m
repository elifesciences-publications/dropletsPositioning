function [X,Y] = DataToNormalized(x,y,ax)
if ~exist('ax','var')
    ax = gca();
end
AX = axis(ax);
P = ax.Position;

Xrange=AX(2)-AX(1);
Yrange=AX(4)-AX(3);
X = P(1) + P(3)*(x - AX(1))/Xrange;
Y = P(2) + P(4)*(y - AX(3))/Yrange;
end