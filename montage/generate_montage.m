function [ montage ] = generate_montage( stack ,N, M, lineOffX, colOffX, lineOffY, colOffY)
% GENERATE_MONTAGE build a montage from images in stack
% Input:
%   stack
S = size(stack)
montage = cell(S(1),length(stack(1).planes),1);
for p=1:length(stack(1,1).planes)
p
    s = size(stack(1,1).planes{p})
    
    if lineOffX < 0
        baseOffX = -lineOffX*(N-1);
    else
        baseOffX = 0;
    end;
    
    if colOffY < 0
        baseOffY = -colOffY*(M-1);
    else
        baseOffY = 0;
    end;
    
    sizeOffX = max(baseOffX + colOffX*(M-1),baseOffX + lineOffX*(N-1) + colOffX*(M-1));
    sizeOffY = max(baseOffY + lineOffY*(N-1),baseOffY + colOffY*(M-1) + lineOffY*(N-1));
    for k = 1:S(1)
        montage{k,p} = zeros(s(1)*N + sizeOffY,s(2)*M + sizeOffX);
    end
    
    for i=1:N
i
        for j=1:M
j
            if mod(i,2) == 1
                x = [(j-1)*s(2)+1,j*s(2)] + baseOffX + lineOffX*(i-1) + colOffX*(j-1);
                y = [(i-1)*s(1)+1,i*s(1)] + baseOffY + lineOffY*(i-1) + colOffY*(j-1);
            else
                x = [(M-j)*s(2)+1,(M-j+1)*s(2)] + baseOffX + lineOffX*(i-1) + colOffX*(M-j);
                y = [(i-1)*s(1)+1,i*s(1)] + baseOffY + lineOffY*(i-1) + colOffY*(M-j);
            end
            for k = 1:S(1)
k
                montage{k,p}(y(1):y(2),x(1):x(2)) = stack(k,M*(i-1)+j).planes{p};
            end
        end
    end
    for k = 1:S(1)
        montage{k,p} = imadjust(montage{k,p}/max(max(montage{k,p})));
    end
%     figure;
%     imagesc(Montage{p});
%     colormap('gray');
end


end

