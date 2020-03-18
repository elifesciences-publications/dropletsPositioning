function varargout = positionsToCR(positions)
    if size(positions,1) == 1
        positions = reshape(positions,4,[]);
    end
    if size(positions,1) ~= 4
        error('positions size must be 4xN or 1x4N');
    end
    radiuses = (positions(3,:) + positions(4,:))/4;
    if nargout <= 1
        varargout{1} = radiuses;
        return
    end
    X = positions(1,:) + positions(3,:)/2;
    Y = positions(2,:) + positions(4,:)/2;
    if nargout == 2
        centers = [X;Y];
        varargout = {centers, radiuses};
    elseif nargout == 3
        varargout = {X, Y, radiuses};
    end
end
