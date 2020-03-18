function drops = emulsions_gui_oop(drops,filename_in,varargin)
blobRfactor = (0.7^2/15/2)^(1/3);
drops_orig = copy(drops);
changed = false;
%%
f = figure('Position',[10,150,800,800]);
set(f,'CloseRequestFcn',@closeConfirmFnc)
ha = axes('Units','Pixels','Position',[10,10,330,330]);
hdropslider = uicontrol('Style','slider',...
    'Callback',{@dropslider_Callback},...
    'Max',length(drops),'Min',1,'Value',1,'sliderStep',[1/max(length(drops)-1,1),1/max(length(drops)-1,1)],...
    'Position',[100,150,150,15]);
hdroptext = uicontrol('Style','text','String','Drop 1',...
    'Position',[20,150,70,15]);
hPlaneslider = uicontrol('Style','slider',...
    'Callback',{@Planeslider_Callback},...
    'Max',size(drops(1).images,2),'Min',1,'Value',1,'sliderStep',[1/max((size(drops(1).images,2)-1),1),1/max((size(drops(1).images,2)-1),1)],...
    'Position',[100,100,150,15]);
hPlanetext = uicontrol('Style','text','String','Plane 1',...
    'Position',[20,100,70,15]);
hcenterPlanebutton = uicontrol('Style','pushbutton','Position',[100,50,300,20],'String','Mark Drop Center Plane',...
    'Callback',{@centerPlanebutton_Callback});
hblobPlanebutton = uicontrol('Style','pushbutton','Position',[100,20,300,20],'String','Mark Blob Plane',...
    'Callback',{@blobPlanebutton_Callback});
hsetBlobCenterbutton = uicontrol('Style','pushbutton','Position',[400,20,200,20],'String','Set Blob Center',...
    'Callback',{@setBlobCenterbutton_Callback});
hresetBlobCenterbutton = uicontrol('Style','pushbutton','Position',[600,20,100,20],'String','Reset',...
    'Callback',{@resetBlobCenterbutton_Callback});
hsetDropradius = uicontrol('Style','pushbutton','Position',[400,50,200,20],'String','Set Drop radius',...
    'Callback',{@setDropradiusbutton_Callback});
hresetDropradius = uicontrol('Style','pushbutton','Position',[600,50,100,20],'String','Reset',...
    'Callback',{@resetDropradiusbutton_Callback});
hDropradius = uicontrol('Style','text','String','',...
    'Position',[600,150,100,50]);
hsaveData = uicontrol('Style','pushbutton','Position',[400,100,100,20],'String','Save',...
    'Callback',{@saveDatabutton_Callback});

align([hdropslider,hPlaneslider],'Center','None');
pan off

if length(drops) == 1
    set(hdropslider, 'Enable', 'off');
end
if size(drops(1).images,2) == 1
    set(hPlaneslider, 'Enable', 'off');
end
c = uicontextmenu;
m1 = uimenu(c,'Label','Set Blob Center','Callback',@setBlobCenter);
m2 = uimenu(c,'Label','Set Drop Radius','Callback',@setDropradius);
m3 = uimenu(c,'Label','Set Blob Plane','Callback',@blobPlanebutton_Callback);
m4 = uimenu(c,'Label','Set Drop Center Plane','Callback',@centerPlanebutton_Callback);


%%
% set(f,'Units','normalized');
% set(hdropslider,'Units','normalized');
% set(hPlaneslider,'Units','normalized');
% set(ha,'Units','normalized');
setBlobCenterOn = false;
setDropradiusOn = false;
dropNum = 1;
plane = 1;
drop_orig = drops_orig(dropNum);
drop_curr = drops(dropNum);

update_ui_Callback();

uiwait();
    function update_ui_Callback()
        %         imshow(DATA_OUT.drops{dropNum}{plane});
        if drop_curr.centerPlane == plane
            planeButtonStr = ['Unmark Drop Center Plane (',num2str(drop_curr.centerPlane),')'];
            planeButtonClr = [0,1,0];
        elseif isempty(drop_curr.centerPlane)
            planeButtonStr = 'Mark Drop Center Plane';
            planeButtonClr = [0.7,0.2,0.2];
        else
            planeButtonStr = ['Change Drop Center Plane (',num2str(drop_curr.centerPlane),')'];
            planeButtonClr = [1,1,0];
        end
        
        if drop_curr.blobPlane == plane
            blobButtonStr = ['Unmark Blob Plane (',num2str(drop_curr.blobPlane),')'];
            blobButtonClr = [0,1,0];
        elseif isempty(drop_curr.blobPlane)
            blobButtonStr = 'Mark Blob Plane';
            blobButtonClr = [0.7,0.2,0.2];
        else
            blobButtonStr = ['Change Blob Plane (',num2str(drop_curr.blobPlane),')'];
            blobButtonClr = [1,1,0];
        end
        set(hcenterPlanebutton,'String',planeButtonStr ,'BackgroundColor',planeButtonClr);
        set(hblobPlanebutton,'String',blobButtonStr ,'BackgroundColor',blobButtonClr);
        blobOutline = bwboundaries(drop_curr.blobs{plane});
        %         I1 = addborder(dropWithBlobOutline,2,planeButtonClr,'outer');
        %         I2 = addborder(I1,2,blobButtonClr,'outer');
        ha.set('Position',[10,150,size(drop_curr.images{plane})]);
        himage = imshow(drop_curr.images{plane},'Parent',ha);
        himage.UIContextMenu = c;

        if ~isempty(blobOutline)
            hold on
            plot(blobOutline{1}(:,2),blobOutline{1}(:,1),'Color',blobButtonClr);
            hold off
        end
        if ~isequal(drop_orig.blobCenters(plane,:), [0,0])
            hold on
            scatter(drop_orig.blobCenters(plane,1),drop_orig.blobCenters(plane,2),[],[0.5,0,0.5],'fill');
            hold off
        end
        
        if ~isequal(drop_curr.blobCenters(plane,:), [0,0]) % why [0,0]?
            hold on
            scatter(drop_curr.blobCenters(plane,1),drop_curr.blobCenters(plane,2),[],blobButtonClr,'fill');
            if ~isempty(drop_curr.centerPlane)
                viscircles([drop_curr.blobCenters(plane,1),drop_curr.blobCenters(plane,2)],drop_curr.getRadius('pixels')*blobRfactor,'LineStyle','--','EdgeColor','b','DrawBackgroundCircle',false);
            end
            hold off
        end
        partcircle(drop_orig.center,drop_orig.radius(plane),'LineStyle','--','Color',[0.5,0,0.5],'LineWidth',2);
        partcircle(drop_curr.center,drop_curr.radius(plane),'LineStyle','--','Color',planeButtonClr,'LineWidth',2);
        if ~isempty(drop_curr.centerPlane)
            radius_in_plane = round(sqrt( drop_curr.getRadius('pixels')^2 - ((drop_curr.centerPlane - plane) / drop_curr.planesPerPixel)^2));
            if isreal(radius_in_plane)
                viscircles(drop_curr.center,radius_in_plane,'EnhanceVisibility',false, 'Color', 'k', 'LineWidth', 0.5, 'LineStyle', ':');
            end
        end
        set(hDropradius,'String',['R = ',num2str(drop_curr.radius(plane) * drop_curr.micronsPerPixel)]);
        
    end

    function dropslider_Callback(hObject, ~, ~)
        dropNum = round(get(hObject,'Value'));
        drop_orig = drops_orig(dropNum);
        drop_curr = drops(dropNum);
        set(hObject,'Value',dropNum);
        set(hdroptext,'String',['Drop ',num2str(dropNum)]);
%         plane = 1;
%         set(hPlaneslider,'Value',plane);
%         set(hPlanetext,'String',['Plane ',num2str(plane)]);
        update_ui_Callback();
        set(f, 'Pointer', 'arrow');
        set(f, 'WindowButtonDownFcn', []);
        setDropradiusOn = false;
        setBlobCenterOn = false;
    end
    function Planeslider_Callback(hObject, ~, ~)
        plane = round(get(hObject,'Value'));
        set(hObject,'Value',plane);
        set(hPlanetext,'String',['Plane ',num2str(plane)]);
        update_ui_Callback();
    end
    function centerPlanebutton_Callback(~, ~, ~)
        if (isempty(drop_curr.centerPlane) || drop_curr.centerPlane ~= plane) && (drop_curr.radius(plane) ~= 0)
            drop_curr.centerPlane = plane;
            dataCahnged();
        elseif ~isempty(drop_curr.centerPlane)
            drop_curr.centerPlane = [];
            dataCahnged();
        end
        update_ui_Callback();
        set(f, 'Pointer', 'arrow');
        setDropradiusOn = false;
        setBlobCenterOn = false;
    end

    function blobPlanebutton_Callback(~, ~, ~)
        if (isempty(drop_curr.blobPlane) || drop_curr.blobPlane ~= plane) && ~isempty(drop_curr.blobs{plane})
            drop_curr.blobPlane = plane;
            dataCahnged();
        elseif ~isempty(drop_curr.blobPlane)
            drop_curr.blobPlane = [];
            dataCahnged();
        end
        update_ui_Callback();
        setDropradiusOn = false;
        setBlobCenterOn = false;
    end
    function setBlobCenterbutton_Callback(~,~,~)
        if setBlobCenterOn == false
            set(f, 'WindowButtonDownFcn', @setBlobCenter);
            set(f, 'Pointer', 'cross'); % Optional
            setBlobCenterOn = true;
            setDropradiusOn = false;
        else
            set(f, 'WindowButtonDownFcn', []);
            set(f, 'Pointer', 'arrow'); % Optional
            setBlobCenterOn = false;
            setDropradiusOn = false;
        end
    end
    function setBlobCenter(~, callbackdata)
        if (strcmp( callbackdata.EventName , 'WindowMousePress') && strcmp( get(f,'selectionType') , 'normal'))...
                || strcmp( callbackdata.EventName , 'Action')
            cursorPoint = get(ha, 'CurrentPoint');
            curX = cursorPoint(1,1);
            curY = cursorPoint(1,2);
            
            xLimits = get(ha, 'xlim');
            yLimits = get(ha, 'ylim');
            
            if (curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
                drop_curr.blobCenters(plane,1) = curX;
                drop_curr.blobCenters(plane,2) = curY;
                drop_curr.blobPlane = plane;
                dataCahnged();
                update_ui_Callback();
            end
        end
    end
    function resetBlobCenterbutton_Callback(~,~,~)
        drop_curr.blobCenters(plane,:) = drop_orig.blobCenters(plane,:);
        drop_curr.blobPlane = drop_orig.blobPlane;
        dataCahnged();
        update_ui_Callback();
        setDropradiusOn = false;
        setBlobCenterOn = false;
    end
    function setDropradiusbutton_Callback(~,~,~)
        if setDropradiusOn == false
            set(f, 'WindowButtonDownFcn', @setDropradius);
            set(f, 'Pointer', 'cross'); % Optional
            setDropradiusOn = true;
            setBlobCenterOn = false;
        else
            set(f, 'WindowButtonDownFcn', []);
            set(f, 'Pointer', 'arrow'); % Optional
            setDropradiusOn = false;
            setBlobCenterOn = false;
        end
    end
    function setDropradius(~, callbackdata)
        if (strcmp( callbackdata.EventName , 'WindowMousePress') && strcmp( get(f,'selectionType') , 'normal'))...
                || strcmp( callbackdata.EventName , 'Action')
            cursorPoint = get(ha, 'CurrentPoint');
            curX = cursorPoint(1,1);
            curY = cursorPoint(1,2);
            
            xLimits = get(ha, 'xlim');
            yLimits = get(ha, 'ylim');
            
            if (curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
                drop_curr.radius(plane) = sqrt((curX - size(drop_curr.images{plane},1)/2)^2 + (curY - size(drop_curr.images{plane},2)/2)^2);
                drop_curr.centerPlane = plane;
                dataCahnged();
                update_ui_Callback();
            end
        end
    end

    function resetDropradiusbutton_Callback(~,~,~)
        drop_curr.radius(plane) = drop_orig.radius(plane);
        drop_curr.centerPlane = drop_orig.centerPlane;
        dataCahnged();
        update_ui_Callback();
        setDropradiusOn = false;
        setBlobCenterOn = false;
    end

    function saveDatabutton_Callback(~,~,~)
        if ~exist('filename_in','var') || ~ischar(filename_in)
            filename_in = fullfile(pwd,'analysis_data.mat')
        end
        [filename,dirname] = uiputfile(filename_in);
        if filename ~= 0;
            fullfilename = fullfile(dirname,filename)
            save(fullfilename,'drops','-v7.3');
            dataSaved();
        end
    end
    function closeConfirmFnc(hObject,~)
        if changed
            selection = questdlg('There are unsaved changes. Quit anayway?',...
                'Close GUI','Quit','Cancel','Cancel');
            switch selection
                case 'Quit',
                    delete(hObject);
                case 'Cancel'
                    return
            end
        else
            delete(hObject)
        end
    end
    function dataCahnged()
        changed = true;
    end
    function dataSaved()
        changed = false;
    end
end
