classdef gui_droplet_test < handle
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dropletCircle
        aggregateCircle
        dropletPositions
        aggregatePositions
        hObject
    end
    
    methods
        function droplet = gui_droplet_test( position)
            if exist('position', 'var') && length(position) == 4
                droplet.dropletCircle = imellipse(gca, position);
            else
                droplet.dropletCircle = imellipse('PositionConstraintFcn',@(pos) [pos(1) pos(2) max(pos(3:4)) max(pos(3:4))]);
            end
            droplet.dropletCircle.setFixedAspectRatioMode( '1' );
            set(droplet.dropletCircle,'DeleteFcn',@(aO,ed) deleteDropletCircle(droplet));
        end
        
        function deleteDropletCircle(droplet)
            if isvalid(droplet)
                delete(droplet)
            end
        end
        
        function delete(droplet)
            if ~isempty(droplet.dropletCircle) && isvalid(droplet.dropletCircle)
                delete(droplet.dropletCircle)
            end
            
        end
    end
end

