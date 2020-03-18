classdef gui_droplet < matlab.mixin.Copyable
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dropletPosition
        aggregatePosition
        dropletPlane
        aggregatePlane
        aggregatePlaneExact
        micronsPerPixel
        micronsPerPlane
        filename;
        time;
        timepoint;
    end
    properties (Access=protected)
        hObject
        isSelected = false;
    end
    properties (Access=protected, NonCopyable)
        textHandle;
        dropletCircle
        aggregateCircle
    end
    properties (Constant, Access=protected)
        dropletColor = struct('selectedInPlane',[0,1,0],...
            'deselectedInPlane', [1,1,1],...
            'selectedOutOfPlane',[0.8,0.8,0.2],...
            'deselectedOutOfPlane',[0.3,0.3,0.3]);
        aggregateColor = struct('selectedInPlane',[0,0.8,0],...
            'deselectedInPlane', [0.8,0.8,0.8],...
            'selectedOutOfPlane',[0.6,0.6,0.2],...
            'deselectedOutOfPlane',[0.2,0.2,0.2]);
    end
    methods (Static)
        function obj = loadobj(s)
            obj = s;
        end
    end
    methods
        function droplet = gui_droplet(hObject, filename, calibration, timepoint, time, position)
            droplet.hObject = hObject;
%             handles = guidata(hObject);
%             ax = handles.axes1;

            if exist('filename','var') && ischar(filename)
                droplet.filename = filename;
            elseif isstruct(filename)
                inStruct = filename;
                droplet.importStruct(inStruct);
                return
            end
            if exist('timepoint','var') && isnumeric(timepoint) && timepoint > 0
                droplet.timepoint = timepoint;
            end
            if exist('time','var') && isnumeric(time)
                droplet.time = time;
            end
            if exist('position', 'var') && length(position) == 4
                initializeDropletCircle(droplet, position);
            else
                initializeDropletCircle(droplet)
            end
            if ~validDroplet(droplet)
                return
            end
            if exist('calibration', 'var') && length(calibration) == 2
                droplet.micronsPerPixel = calibration(1);
                droplet.micronsPerPlane = calibration(2);
            elseif exist('filename','var') && ischar(filename)
                [droplet.micronsPerPixel, droplet.micronsPerPlane] = readCalibration(filename);
            end
            setDropletPlane(droplet);
            updatePosition(droplet);
            %                 if validDroplet(droplet) && isempty(droplet.dropletPlane)
            %                     droplet.dropletPlane = handles.curPlane;
            %                 end
        end
        
        function BV = blob_vectors(obj)
            emptyCells = cell(numel(obj),1);
            BV = struct('blobVec',emptyCells, 'blobRThetaPhi',emptyCells,...
                'blobVecNormalized',emptyCells, 'blobRThetaPhiNormalized',emptyCells,...
                'dropR',emptyCells, 'blobVecError',emptyCells, 'blobVecErrNormalized',emptyCells,...
                'blobRThetaPhiErr',emptyCells, 'blobRThetaPhiErrNormalized',emptyCells);
            if numel(obj) > 1
                BV = arrayfun(@(x) x.blob_vectors,obj);
                return;
            elseif isempty(obj.aggregatePlane) || isempty(obj.dropletPlane)
                return;
            else
                BV.dropR = obj.getDropletDiameter/2;
                blobCenter = obj.getAggregateCenter;
                dropCenter = obj.getDropletCenter;
                BV.blobVec = (blobCenter(:)' - dropCenter(:)');
                BV.blobVec = BV.blobVec(:);
                BV.blobVec(3) = (obj.aggregatePlane - obj.dropletPlane) * obj.micronsPerPlane;
                BV.blobVecNormalized = BV.blobVec / (BV.dropR * (1-obj.getAggregateDiameter/2));
                if norm(BV.blobVecNormalized) > 1
                    norm(BV.blobVecNormalized)
                    BV.blobVecNormalized(3) = sqrt(max(1 - norm(BV.blobVecNormalized(1:2))^2,0)) * sign(BV.blobVecNormalized(3));
                end
                BV.blobRThetaPhi = myCart2sph(BV.blobVec);
                BV.blobRThetaPhiNormalized = BV.blobRThetaPhi;
                BV.blobRThetaPhiNormalized(1) = norm(BV.blobVecNormalized);
                
                BV.blobVecError = repmat(BV.blobVec,1,2);
                BV.blobVecError(3,1) = BV.blobVecError(3,1) - obj.micronsPerPlane;
                BV.blobVecError(3,2) = BV.blobVecError(3,2) + obj.micronsPerPlane;
                BV.blobVecErrNormalized = BV.blobVecError / (BV.dropR * (1-obj.getAggregateDiameter/2));
                for i=1:2
                    if norm(BV.blobVecErrNormalized(:,i)) > 1
                        BV.blobVecErrNormalized(3,i) = sqrt(max(1 - norm(BV.blobVecErrNormalized(1:2,i))^2,0)) * sign(BV.blobVecErrNormalized(3,i));
                    end
                end
            end
        end

        function exportStruct = dropletStruct(droplet, exportFields)
            if ~exist('exportFields','var')
                exportFields = properties(droplet);
            end
            if length(droplet) > 1
                for i=1:length(droplet)
                    exportStruct(i) = dropletStruct(droplet(i), exportFields);
                end
            else
                for i = 1:length(exportFields)
                    exportStruct.(exportFields{i}) = droplet.(exportFields{i});
                end
            end
        end
        function importStruct(droplet, inStruct)
            importFields = properties(droplet);
            for i = 1:length(importFields)
                droplet.(importFields{i}) = inStruct.(importFields{i});
            end
        end
        
        function diameter = getDropletDiameter(droplet)
            p = droplet.getPosition;
            if length(p) == 4
                diameter = (p(3) + p(4))*0.5 * droplet.micronsPerPixel;
            else
                diameter = 0;
            end
        end
        
        function diameter = getAggregateDiameter(droplet)
            p = droplet.getAggPosition;
            if length(p) == 4
                diameter = (p(3) + p(4))*0.5 * droplet.micronsPerPixel;
            else
                diameter = 0;
            end
        end

        
        function center = getDropletCenter(droplet)
            p = droplet.getPosition;
            if length(p) == 4
                center = [p(1) + p(3)/2, p(2) + p(4)/2] * droplet.micronsPerPixel;
            else
                center = -1;
            end
        end
        
        function center = getAggregateCenter(droplet)
            p = droplet.getAggPosition;
            if length(p) == 4
                center = [p(1) + p(3)/2, p(2) + p(4)/2] * droplet.micronsPerPixel;
            else
                center = -1;
            end
        end

        function initializeDropletCircle(droplet, position)
            handles = guidata(droplet.hObject);
            ax = handles.axes1;
            if exist('position', 'var') && length(position) == 4
                droplet.dropletCircle = imellipse(ax, position);
            elseif exist('position', 'var') && length(position) ~= 4
                return;
            else
                % droplet.dropletCircle = imellipse('PositionConstraintFcn',@(pos) [pos(1) pos(2) max(pos(3:4)) max(pos(3:4))]);
                droplet.dropletCircle = imellipse;
            end
            if validDropletCircle(droplet)
                % droplet.dropletCircle.setFixedAspectRatioMode( '1' );
                droplet.dropletCircle.setPositionConstraintFcn(@(pos) posSelectDroplet(droplet, pos, droplet.hObject));
                droplet.dropletCircle.addNewPositionCallback(@(pos) updatePosition(droplet, pos));
                set(droplet.dropletCircle,'DeleteFcn',@(aO,ed) deleteDropletCircle(droplet, droplet.hObject));
            else
                delete(droplet);
            end
        end
        
        function updatePosition(droplet, pos)
            if validDroplet(droplet)
                handles = guidata(droplet.hObject);
                ax = handles.axes1;
                set(handles.figure1,'CurrentAxes',ax);
                if exist('pos','var')
                    droplet.dropletPosition = pos;
                else
                    droplet.dropletPosition = droplet.getPosition;
                end
                droplet.aggregatePosition = droplet.getAggPosition;
                pos = droplet.dropletPosition;
                delete(droplet.textHandle);
                if validAggregate(droplet)
                    dropletText = sprintf('D=%d\nPd=%d\nPa=%.1f', round(droplet.getDropletDiameter), droplet.dropletPlane, droplet.aggregatePlaneExact);
                else
                    dropletText = sprintf('D=%d\np=%d', round(droplet.getDropletDiameter), droplet.dropletPlane);
                end
                droplet.textHandle = text(pos(1) - 10,pos(2) - 10,dropletText, 'Color', determineColor(droplet));
            end
        end
        
        function setPosition(droplet, position)
            if validDroplet(droplet)
                if validDropletCircle(droplet)
                    droplet.dropletCircle.setConstrainedPosition(position);
                elseif ~isempty(droplet.aggregatePosition)
                    droplet.setAggPosition(position - droplet.dropletPosition + droplet.getAggPosition);
                end
                droplet.dropletPosition = position;
            end
        end
        
        function setAggPosition(droplet, position)
            if validDroplet(droplet)
                if validAggregate(droplet)
                    droplet.aggregateCircle.setConstrainedPosition(position);
                end
                droplet.aggregatePosition = position;
            end
        end
        
        function deleteDropletCircle(droplet, hObject)
            if isvalid(hObject)
                if isvalid(droplet)
                    delete(droplet);
                end
            end
        end
        
        function hideDroplet(droplet)
            if length(droplet) > 1
                for i = 1:length(droplet)
                    hideDroplet(droplet(i));
                end
            else
                if validDroplet(droplet)
                    if validDropletCircle(droplet)
                        set(droplet.dropletCircle,'DeleteFcn',@(aO,ed) '');
                        droplet.updatePosition;
                        delete(droplet.dropletCircle);
                        delete(droplet.textHandle);
                    end
                    if validAggregate(droplet)
                        delete(droplet.aggregateCircle);
                    end
                end
            end
        end
        
        function setDropletPlane(droplet, plane)
            if validDroplet(droplet)
                handles = guidata(droplet.hObject);
                if exist('plane','var')
                    droplet.dropletPlane = plane;
                else
                    droplet.dropletPlane = handles.curPlane;
                end
            end
        end
        
        function setAggregatePlane(droplet, plane)
            handles = guidata(droplet.hObject);
            if exist('plane','var')
                droplet.aggregatePlane = round(plane);
                droplet.aggregatePlaneExact = plane;
            else
                droplet.aggregatePlane = handles.curPlane;
                droplet.aggregatePlaneExact = handles.curPlane;
            end
        end

        function removeAggregate(droplet)
            if validDroplet(droplet) && validAggregate(droplet)
                delete(droplet.aggregateCircle);
                droplet.aggregateCircle = [];
            end
        end
        
        function showDroplet(droplet)
            if length(droplet) > 1
                for i = 1:length(droplet)
                    showDroplet(droplet(i));
                end
            else
                if validDroplet(droplet)
                    if ~validDropletCircle(droplet)
                        initializeDropletCircle(droplet, droplet.getPosition);
                    end
                    if ~validAggregate(droplet)
                        initializeAggregate(droplet, droplet.getAggPosition)
                    end
                    updatePosition(droplet);
                    deselect(droplet);
                end
            end
        end
        
        function initializeAggregate(droplet, position)
            handles = guidata(droplet.hObject);
            ax = handles.axes1;
            if validAggregate(droplet)
                return
            end
            if exist('position', 'var') && length(position) == 4
                aggregate = imellipse(ax, position);
            elseif exist('position', 'var') && length(position) ~= 4
                return
            else
                aggregate = imellipse();
            end
            if ~isempty(aggregate) && isvalid(aggregate)
                droplet.aggregateCircle = aggregate;
                droplet.aggregateCircle.setPositionConstraintFcn(@(pos) posSelectAggregate(droplet, pos, droplet.hObject));
                droplet.aggregateCircle.addNewPositionCallback(@(pos) updatePosition(droplet));
                droplet.aggregateCircle.setConstrainedPosition(droplet.aggregateCircle.getPosition);
                setColors(droplet)
            end
        end
        
        function vd = validDropletCircle(droplet)
            vd = ~isempty(droplet.dropletCircle) && isvalid(droplet.dropletCircle);
        end
        
        function vd = validDroplet(droplet)
            vd = ~isempty(droplet) && isvalid(droplet);
        end
        
        function va = validAggregate(droplet)
            va = ~isempty(droplet.aggregateCircle) && isvalid(droplet.aggregateCircle);
        end
        
        function deselect(droplet)
            if validDroplet(droplet)
                droplet.isSelected = false;
                droplet.setColors;
            end
        end
        
        function select(droplet)
            if validDroplet(droplet)
                droplet.isSelected = true;
                droplet.setColors;
            end
        end
        function [dColor, aColor] = determineColor(droplet)
            if validDroplet(droplet)
                handles = guidata(droplet.hObject);
                if validDroplet(droplet)
                    if droplet.isSelected
                        if droplet.dropletPlane == handles.curPlane;
                            dColor = droplet.dropletColor.selectedInPlane;
                        else
                            dColor = droplet.dropletColor.selectedOutOfPlane;
                        end
                        if droplet.aggregatePlane == handles.curPlane;
                            aColor = droplet.aggregateColor.selectedInPlane;
                        else
                            aColor = droplet.aggregateColor.selectedOutOfPlane;
                        end
                    else
                        if droplet.dropletPlane == handles.curPlane;
                            dColor = droplet.dropletColor.deselectedInPlane;
                        else
                            dColor = droplet.dropletColor.deselectedOutOfPlane;
                        end
                        if droplet.aggregatePlane == handles.curPlane;
                            aColor = droplet.aggregateColor.deselectedInPlane;
                        else
                            aColor = droplet.aggregateColor.deselectedOutOfPlane;
                        end
                    end
                end
            end
        end
        function setColors(droplet)
            if length(droplet) > 1
                for i=1:length(droplet)
                    setColors(droplet(i));
                end
            else
                if validDroplet(droplet)
                    [dColor, aColor] = determineColor(droplet);
                    if validDropletCircle(droplet)
                        droplet.dropletCircle.setColor(dColor);
                    end
                    if validAggregate(droplet)
                        droplet.aggregateCircle.setColor(aColor);
                    end
                    if ~isempty(droplet.textHandle) && isvalid(droplet.textHandle)
                        droplet.textHandle.Color = dColor;
                    end
                end
            end
        end
        
        function pos = posSelectDroplet(droplet, pos, hObject)
            handles = guidata(hObject);
            if validDroplet(droplet) && validDropletCircle(droplet)
                deselect(handles.selectedDroplet);
            end
            droplet.select;
            handles.selectedDroplet = droplet;
            if ~isempty(droplet.aggregatePosition)
                droplet.setAggPosition(pos - droplet.dropletPosition + droplet.getAggPosition);
%             if validAggregate(droplet)
%                 newAggPosition = pos - droplet.dropletPosition + droplet.getAggPosition;
%                 droplet.aggregateCircle.setConstrainedPosition(newAggPosition);
            end
            handles = one_position_gui_obj('updateAuxCircles',hObject,handles);
            guidata(hObject, handles);
        end
        
        function pos = aggregateConstraint(droplet, pos)
            if validDroplet(droplet) && validDropletCircle(droplet) && validAggregate(droplet)
                p = getPosition(droplet);
                contraintFcn = makeConstrainToRectFcn('imellipse', [p(1), p(1)+p(3)], [p(2), p(2)+p(4)]);
                pos = contraintFcn(pos);
            end
        end
        
        function pos = posSelectAggregate(droplet, pos, hObject)
            handles = guidata(hObject);
            if validDroplet(droplet) && validDropletCircle(droplet)
                deselect(handles.selectedDroplet);
            end
            droplet.select;
            handles.selectedDroplet = droplet;
            pos = aggregateConstraint(droplet, pos);
            guidata(hObject, handles);
        end
        
        function position = getPosition(droplet)
            if validDroplet(droplet)
                if validDropletCircle(droplet)
                    position = droplet.dropletCircle.getPosition;
                else
                    position = droplet.dropletPosition;
                end
            end
        end
        
        function position = getAggPosition(droplet)
            if validDroplet(droplet)
                if validAggregate(droplet)
                    position = droplet.aggregateCircle.getPosition;
                else
                    position = droplet.aggregatePosition;
                end
            end
        end
        
        function delete(droplet)
            delete(droplet.textHandle);
            if validAggregate(droplet)
                delete(droplet.aggregateCircle);
            end
            if validDropletCircle(droplet)
                delete(droplet.dropletCircle)
            end
        end
        
        function cpDroplets = copyToTimepoint(droplets, filename, timepoint, time)
            cpDroplets = copy(droplets);
            if exist('filename','var') && ischar(filename)
                [cpDroplets.filename] = deal(filename);
            else
                warning('no new filename specified for copied droplets');
            end
            if exist('timepoint','var') && isnumeric(timepoint) && timepoint > 0
                [cpDroplets.timepoint] = deal(timepoint);
            else
                warning('no new timepoint specified for copied droplets');
            end
            if exist('time','var') && isnumeric(time)
                [cpDroplets.time] = deal(time);
            else
                warning('no new time specified for copied droplets');
            end
        end
    end
end

