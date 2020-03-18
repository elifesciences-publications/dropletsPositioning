function ViewAnimation(anim,dt)
    f = figure('Position',[100,100,400,400]);
    ha = axes('Units','Pixels','Position',[20,20,350,350]);
    i=1;
    hSpeedSlider = uicontrol('Style','slider',...
    'Callback',{@SpeedSlider_Callback},...
    'Max',1,'Min',0.05,'Value',0.1,'sliderStep',[0.05,0.1],...
    'Position',[100,15,150,15]);

    while isvalid(ha)
        imshow(anim{i},'Parent',ha)
        pause(dt);
        i = mod(i + 1,length(anim)) + 1;
    end
    function SpeedSlider_Callback(hObject, ~, ~)
        dt = get(hObject,'Value');
    end

end