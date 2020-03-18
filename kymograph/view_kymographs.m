function markList = view_kymographs(dirList)

f = figure('Position',[100,100,800,800]);
ha = axes('Units','Pixels','Position',[30,200,330,330]);
hdirSlider = uicontrol('Style','slider',...
    'Callback',{@dirSlider_Callback},...
    'Max',length(dirList),'Min',1,'Value',1,'sliderStep',[1/max(length(dirList)-1,1),1/max(length(dirList)-1,1)],...
    'Position',[200,150,150,15]);
hdirName = uicontrol('Style','text','String','',...
    'Position',[100,100,600,15]);
hmarkkymButton = uicontrol('Style','pushbutton','Position',[200,50,300,20],'String','Mark Kymograph',...
    'Callback',{@markkym_Callback});
hViewDropButton = uicontrol('Style','pushbutton','Position',[200,20,300,20],'String','View Drop',...
    'Callback',{@view_Callback});

pan off

if length(dirList) == 1
    set(hdirSlider, 'Enable', 'off');
end
markList = 0;
dirNum = 1;
dirName = dirList{1};
update_ui_Callback();
    
uiwait();
    function update_ui_Callback()
        set(hdirName,'String',dirName);
        kymfilename = fullfile('\\phkinnerets\maya\',dirName,'Rho\figures\Density Kymograph.tiff');
        Kym = load_tiff_file(kymfilename,1);
        imshow(Kym{1});
%         setpixelposition(gca,[50 50 floor(size(Kym{1},2)/2) floor(size(Kym{1},1)/2)]);
        setpixelposition(gca,[50 50 800 500]);
        ind = markList == dirNum;
        if max(ind) == 1
            set(hmarkkymButton,'String','unmark' ,'BackgroundColor',[0,1,0]);
        else
            set(hmarkkymButton,'String','mark' ,'BackgroundColor',[0,1,1]);
        end
    end

    function dirSlider_Callback(hObject, ~, ~)
        dirNum = round(get(hObject,'Value'));
        dirName = dirList{dirNum};
        set(hObject,'Value',dirNum);
        update_ui_Callback();
    end
    function markkym_Callback(~,~,~)        
        ind = markList == dirNum;
        if max(ind) == 1
            markList = markList(~ind);
        else
            markList = [markList,dirNum];
        end
        update_ui_Callback();
    end
    function view_Callback(~,~,~)
        fileName = fullfile('\\phkinnerets\maya\',dirName,'8bitC0.tif');
        anim = load_tiff_file(fileName,1);
        ViewAnimation(anim,0.1);
    end
end
