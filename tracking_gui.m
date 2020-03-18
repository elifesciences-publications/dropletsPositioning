function tracking_gui(t_drops, z_drop, translation, planes)
blobRfactor = (0.7^2/15/2)^(1/3);
centers = repmat(z_drop.getBlobCenter',length(translation),1) + translation;
displacement = centers - repmat(z_drop.center,length(translation),1);
%%
f = figure('Position',[10,150,800,800]);
ha1 = axes('Units','Pixels','Position',[20,140,330,330]);
ha2 = axes('Units','Pixels','Position',[350,140,330,330]);
ha3 = axes('Units','Pixels','Position',[50,500,280,200]);
ha4 = axes('Units','Pixels','Position',[380,500,280,200]);

hdropslider = uicontrol('Style','slider',...
    'Callback',{@dropslider_Callback},...
    'Max',length(t_drops),'Min',1,'Value',1,'sliderStep',[1/max(length(t_drops)-1,1),1/max(length(t_drops)-1,1)],...
    'Position',[100,100,150,15]);
hdroptext = uicontrol('Style','text','String','Drop 1',...
    'Position',[20,100,70,15]);
hPlaneslider = uicontrol('Style','slider',...
    'Callback',{@Planeslider_Callback},...
    'Max',size(z_drop.images,2),'Min',1,'Value',1,'sliderStep',[1/max((size(z_drop.images,2)-1),1),1/max((size(z_drop.images,2)-1),1)],...
    'Position',[100,60,150,15]);
hPlanetext = uicontrol('Style','text','String','Plane 1',...
    'Position',[20,60,70,15]);
hPlanebutton = uicontrol('Style','pushbutton','Position',[100,20,300,20],'String','Go to blob plane',...
    'Callback',{@Planebutton_Callback});
align([hdropslider,hPlaneslider],'Center','None');
pan off

if length(t_drops) == 1
    set(hdropslider, 'Enable', 'off');
end
if size(z_drop.images,2) == 1
    set(hPlaneslider, 'Enable', 'off');
end

%%
dropNum = 1;
plane = 1;
Planebutton_Callback
update_ui_Callback();

% uiwait();
    function PlotCallback(hObject,hit)
        pt = hit.IntersectionPoint(1)
        x = max(min(round(pt(1)),1),length(t_drops));
        set(hdropslider,'Value',pt(1));
        dropslider_Callback(hdropslider);
    end

    function update_ui_Callback()
%         ha1.set('Position',[10,150,size(drop_curr.images{plane})]);
        imshow(z_drop.images{plane},'Parent',ha1);
        imshow(t_drops(dropNum).images{1},'Parent',ha2);
        
        plot(planes,'Parent',ha3,'ButtonDownFcn',@PlotCallback);
        hold(ha3,'on');
        scatter(dropNum,plane,'Parent',ha3,'filled');
        hold(ha3,'off');
        ha3.ButtonDownFcn = @PlotCallback;
        
        plot(sqrt(diag(displacement*displacement'))*z_drop.micronsPerPixel,'Parent',ha4);
        hold(ha4,'on');
        scatter(dropNum,norm(displacement(dropNum,:))*z_drop.micronsPerPixel,'Parent',ha4,'filled');
        hold(ha4,'off');
        ha4.ButtonDownFcn = @PlotCallback;

        if ~isequal(z_drop.blobCenters(plane,:), [0,0])
            hold(ha1,'on');
            %scatter(z_drop.blobCenters(plane,1),z_drop.blobCenters(plane,2),[],[0.7,0.2,0.2],'fill','Parent',ha1);
            hold(ha1,'off');
        end
        if length(centers) >= dropNum
            if plane == planes(dropNum)
                color = [0,1,0];
            else
                color = [0.7,0.2,0.2];
            end
            hold(ha2, 'on');
            scatter(centers(dropNum,1),centers(dropNum,2),[],color,'fill','Parent',ha2);
            %viscircles(centers(dropNum,:),t_drops(dropNum).getRadius('pixels')*blobRfactor,'LineStyle','--','EdgeColor',color,'DrawBackgroundCircle',false);
            hold(ha2, 'off');
        end
    end

    function dropslider_Callback(hObject, ~, ~)
        dropNum = round(get(hObject,'Value'));
        set(hObject,'Value',dropNum);
        set(hdroptext,'String',['Drop ',num2str(dropNum)]);
        Planebutton_Callback
        update_ui_Callback();
    end

    function Planeslider_Callback(hObject, ~, ~)
        plane = round(get(hObject,'Value'));
        set(hObject,'Value',plane);
        set(hPlanetext,'String',['Plane ',num2str(plane)]);
        update_ui_Callback();
    end

    function Planebutton_Callback(~, ~, ~)
        if length(planes) >= dropNum
            set(hPlaneslider,'Value',planes(dropNum));
            Planeslider_Callback(hPlaneslider);
        end
    end

        
end
