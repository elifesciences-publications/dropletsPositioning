function [r,theta] = dropletfunctionSpherical(R, r0, d, bs, s)
    %define circle with hole in polar coords
    segNum = 8;
    A1 = [0, 0.1, 1, 4, 5, 7, 8, 11];
    A2 = [0.1, 1, 4, 5, 7, 8, 11, 11.9];
              
%     R = 100;
%     r0 = R/5;
%     d = R/2;
    narg = nargin - 3;
    switch narg
        case 0
            r = segNum;
            return;
        case 1
%             A = [0, 2*pi, 2*pi+R-d-r0, 2*pi+R-d+r0, 2*pi+R, 4*pi+R, 4*pi+R+d-r0, 4*pi+R+d+r0
%                 2*pi, 2*pi+R-d-r0, 2*pi+R-d+r0, 2*pi+R, 4*pi+R, 4*pi+R+d-r0, 4*pi+R+d+r0, 4*pi+2*R
%                 0, 0, 0, 0, 0, 0, 0, 0
%                 1, 1, 1, 1, 1, 1, 1, 1];
%             A = [0, 1, 2, 3, 4, 5, 6, 7
%                 1, 2, 3, 4, 5, 6, 7, 8
%                 0, 0, 0, 0, 0, 0, 0, 0
%                 1, 1, 1, 1, 1, 1, 1, 1];
            A = [A1
                A2
                0, 0, 0, 0, 0, 0, 0, 0
                1, 1, 1, 1, 1, 1, 1, 1];

            r = A(:,bs);
            return;
        case 2
            L = A2 - A1;
            r = zeros(size(s)); 
            theta = zeros(size(s)); 
            if numel(bs) == 1 % Does bs need scalar expansion?
                bs = bs*ones(size(s)); % Expand bs
            end
            cbs = find(bs == 1);
            if ~isempty(cbs)
                r(cbs) = 0;
                theta(cbs) = s(cbs)*2*pi/L(1);
            end
            cbs = find(bs == 5);
            if ~isempty(cbs)
                r(cbs) = R;
                theta(cbs) = (A2(5) - s(cbs))*2*pi/L(5);
            end
            cbs = find(bs == 2);
            if ~isempty(cbs)
                r(cbs) = (s(cbs) - A1(2))*(d - r0)/L(2);
                theta(cbs) = 2*pi;
            end
            cbs = find(bs == 4);
            if ~isempty(cbs)
                r(cbs) = (d+r0) + (s(cbs) - A1(4))*(R - (d+r0))/L(4);
                theta(cbs) = 2*pi;
            end
            cbs = find(bs == 6);
            if ~isempty(cbs)
                r(cbs) = R + (A1(6) - s(cbs))*(-d-r0 + R)/L(6);
                theta(cbs) = 0;
            end
            cbs = find(bs == 8);
            if ~isempty(cbs)
                r(cbs) = (d-r0)*(A2(8) - s(cbs))/L(8);
                theta(cbs) = 0;
            end
            cbs = find(bs == 3);
            if ~isempty(cbs)
                r(cbs) = d-r0 + (s(cbs) - A1(3))*(2*r0)/L(3);
                theta(cbs) = 2*pi - real(acos((r(cbs).^2 - r0^2 + d^2)./(2*r(cbs)*d)));
%                 theta(s(cbs) == A(3)) =  2*pi;
            end
            cbs = find(bs == 7);
            if ~isempty(cbs)
                r(cbs) = d+r0 + (A1(7) - s(cbs))*2*r0/L(7);
                theta(cbs) = real(acos((r(cbs).^2- r0^2 + d^2)./(2*r(cbs)*d)));
            end
    end
end
