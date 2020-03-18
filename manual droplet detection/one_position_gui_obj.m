function varargout = one_position_gui_obj(varargin)
% ONE_POSITION_GUI_OBJ MATLAB code for one_position_gui_obj.fig
%      ONE_POSITION_GUI_OBJ, by itself, creates a new ONE_POSITION_GUI_OBJ or raises the existing
%      singleton*.
%
%      H = ONE_POSITION_GUI_OBJ returns the handle to a new ONE_POSITION_GUI_OBJ or the handle to
%      the existing singleton*.
%
%      ONE_POSITION_GUI_OBJ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ONE_POSITION_GUI_OBJ.M with the given input arguments.
%
%      ONE_POSITION_GUI_OBJ('Property','Value',...) creates a new ONE_POSITION_GUI_OBJ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before one_position_gui_obj_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to one_position_gui_obj_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help one_position_gui_obj

% Last Modified by GUIDE v2.5 09-Jan-2020 11:49:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @one_position_gui_obj_OpeningFcn, ...
    'gui_OutputFcn',  @one_position_gui_obj_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before one_position_gui_obj is made visible.
function one_position_gui_obj_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to one_position_gui_obj (see VARARGIN)

% Choose default command line output for one_position_gui_obj
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if nargin > 3
    %set filenames
    % Load image files
    handles.filenames = varargin{1};
    handles.numOfTimepoints = length(handles.filenames);
    handles.timepoints = struct('images',{[]},'droplets',emptyDroplet,'filename','');
    if nargin > 4
        images = varargin{2};
        handles.numOfTimepoints = size(images,2);
        handles.timepoints = initializeTimepoints(handles.numOfTimepoints, handles.filenames, images);
    else
        handles.timepoints = initializeTimepoints(handles.numOfTimepoints, handles.filenames);
    end
    if nargin > 5
        loadFile = varargin{3};
        if ~isnumeric(loadFile)
            handles = loadDroplets(hObject, handles, loadFile);
        end
    end
    if nargin > 6
        handles.initTime = varargin{4};
    else
        handles.initTime = 0;
    end
    [handles.micronsPerPixel, handles.micronsPerPlane, handles.timePerFrame] = readCalibration(handles.filenames{1});
    handles.curTimepoint = 1;
    handles.curPlane = 1;
    handles.selectedDroplet = emptyDroplet;
    handles.numOfPlanes = size(handles.timepoints(1).images,1);
    handles.numOfChannels = size(handles.timepoints(1).images,2);
    handles.curChannel = 1;
    handles.callbackrunning = false;
    handles.showDroplets = true;
    handles.auxCircles = gobjects(0);
    handles.min = 0;
    handles.max = 1;
    handles.gamma = 1;
    handles.jump = 1;
    %         handles.timePerFrame = 0.5;
    handles.manualAdjust = false;
    set(handles.auto_adjust_button,'Enable','off');
    set(handles.gamma_slider,'Enable','off');
    set(handles.min_slider,'Enable','off');
    set(handles.max_slider,'Enable','off');
else
    handles.filnames = {};
end

set(handles.channel_slider,'Max',handles.numOfChannels);
set(handles.channel_slider,'Min',1);
set(handles.channel_slider,'Value',1);
if handles.numOfChannels > 1
    set(handles.channel_slider,'sliderStep',[1/(handles.numOfChannels-1),1/(handles.numOfChannels-1)]);
else
    set(handles.channel_slider,'Enable','off');
end

set(handles.time_slider,'Max',handles.numOfTimepoints);
set(handles.time_slider,'Min',1);
set(handles.time_slider,'Value',1);
if handles.numOfTimepoints > 1
    set(handles.time_slider,'sliderStep',[1/(handles.numOfTimepoints-1),1/(handles.numOfTimepoints-1)]*handles.jump);
else
    set(handles.time_slider,'Enable','off');
end

set(handles.plane_slider,'Max',handles.numOfPlanes);
set(handles.plane_slider,'Min',1);
set(handles.plane_slider,'Value',1);
if handles.numOfPlanes > 1
    set(handles.plane_slider,'sliderStep',[1/(handles.numOfPlanes-1),1/(handles.numOfPlanes-1)]);
else
    set(handles.plane_slider,'Enable','off');
end

set(handles.min_slider,'Max',1);
set(handles.min_slider,'Min',0);
set(handles.min_slider,'Value',0);

set(handles.max_slider,'Max',1);
set(handles.max_slider,'Min',0);
set(handles.max_slider,'Value',1);

set(handles.gamma_slider,'Max',2);
set(handles.gamma_slider,'Min',0);
set(handles.gamma_slider,'Value',1);
%set(hObject,'WindowButtonDownFcn',@(hObject,eventdata) winPressed(hObject,eventdata,'down'));
%set(hObject,'WindowButtonUpFcn',@(hObject,eventdata) winPressed(hObject,eventdata,'up')) ;

guidata(hObject, handles);
handles = autoAdjust(hObject, handles);
% handles = updateImage(hObject, handles);
showDroplet(handles.timepoints(1).droplets);
handles = updateShowHideButton(hObject, handles);

% UIWAIT makes one_image_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function handles = autoAdjust(hObject, handles)
limits = stretchlim(handles.timepoints(handles.curTimepoint).images{handles.curPlane});
set(handles.min_slider,'Value',limits(1));
set(handles.max_slider,'Value',limits(2));
set(handles.gamma_slider,'Value',1);
handles.min = limits(1);
handles.max = limits(2);
handles.gamma = 1;
handles = updateImage(hObject, handles);

function handles = updateImage(hObject, handles)
hold on
if isfield(handles,'image') && isvalid(handles.image)
    handles.image.delete;
end
if handles.manualAdjust
    handles.image = imshow(imadjust(handles.timepoints(handles.curTimepoint).images{handles.curPlane, handles.curChannel},...
        [handles.min; handles.max],[],handles.gamma), 'Parent', handles.axes1);
else
    handles.image = imshow(imadjust(handles.timepoints(handles.curTimepoint).images{handles.curPlane, handles.curChannel}), 'Parent', handles.axes1);
end
handles.image.ButtonDownFcn = @axes1_ButtonDownFcn;
handles.axes1.XLimMode='manual';
handles.axes1.YLimMode='manual';
uistack(handles.image,'bottom');
set(handles.timepoint_text,'String',sprintf('Timepoint %d/%d',handles.curTimepoint,handles.numOfTimepoints));
set(handles.plane_text,'String',sprintf('Plane %d/%d',handles.curPlane,handles.numOfPlanes));
if ~isfield(handles,'scalebar') || ~isvalid(handles.scalebar)
    handles.scalebar = scalebar('XLen',50,'YLen',1, 'XUnit', '{\mu}m', 'Border', 'LN',...
        'Position',[50, 990], 'Calibration', handles.micronsPerPixel,...
        'hTextX_Pos',[20/handles.micronsPerPixel ,20], 'Color',[1,1,0] ,'FontSize', 16);
end
guidata(hObject, handles);

function handles = updateAuxCircles(hObject, handles)
if ~isempty(handles.auxCircles) && isvalid(handles.auxCircles(1))
    delete(handles.auxCircles);
end
handles.auxCircles = gobjects(0);
if handles.showDroplets
    for i=1:length(handles.timepoints(handles.curTimepoint).droplets)
        droplet = handles.timepoints(handles.curTimepoint).droplets(i);
        if droplet.dropletPlane ~= handles.curPlane
            radius = sqrt((droplet.getDropletDiameter/2)^2 - ((droplet.dropletPlane - handles.curPlane) * handles.micronsPerPlane)^2) / handles.micronsPerPixel;
            if isreal(radius)
                center = droplet.getDropletCenter/ droplet.micronsPerPixel;
                handles.auxCircles(end+1) = viscircles(handles.axes1, center,radius,'EnhanceVisibility',false, 'Color', [0,0,1], 'LineWidth', 0.5, 'LineStyle', ':');
            end
        end
    end
end
guidata(hObject, handles);

function handles = loadDroplets(hObject, handles, loadFile)
loadStruct = load(loadFile);
for i=1:length(loadStruct.droplets)
    tp = loadStruct.droplets(i).timepoint;
    n = length(handles.timepoints(tp).droplets);
    handles.timepoints(tp).droplets(n+1) = gui_droplet(hObject, loadStruct.droplets(i));
end
guidata(hObject, handles);

function handles = clear_droplets(hObject, handles, timepointsToClear)
if ~exist('timepointsToClear', 'var') || isempty(timepointsToClear) || min(timepointsToClear) <= 0
    timepointsToClear = handles.curTimepoint;
end
for tp=timepointsToClear
    if ~isempty(handles.timepoints(tp).droplets)
        delete([handles.timepoints(tp).droplets]);
    end
    handles.timepoints(tp).droplets = emptyDroplet;
end
handles.selectedDroplet = emptyDroplet;
guidata(hObject, handles);

function droplet = newDroplet(hObject, handles, position)
time = (handles.curTimepoint - 1) * handles.timePerFrame + handles.initTime;
fn = handles.timepoints(handles.curTimepoint).filename;
if exist( 'position', 'var') && length(position) == 4
    droplet = gui_droplet(hObject, fn, [handles.micronsPerPixel, handles.micronsPerPlane], handles.curTimepoint, time, position);
else
    droplet = gui_droplet(hObject, fn, [handles.micronsPerPixel, handles.micronsPerPlane], handles.curTimepoint, time);
end

function handles = cancelCircle(hObject, handles)
if handles.callbackrunning
    disp('Fire escape key to cancel previous imellipse');
    % Create robot that fires an escape key
    robot = java.awt.Robot;
    robot.keyPress    (java.awt.event.KeyEvent.VK_ESCAPE);
    robot.keyRelease  (java.awt.event.KeyEvent.VK_ESCAPE);
    handles.callbackrunning = false;
    guidata(hObject, handles);
end

function handles = updateShowHideButton(hObject, handles)
numOfDroplets = length(handles.timepoints(handles.curTimepoint).droplets);
if handles.showDroplets
    handles.show_hide_droplets.String = sprintf('Hide %d Droplets', numOfDroplets);
else
    handles.show_hide_droplets.String = sprintf('Show %d Droplets', numOfDroplets);
end
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = one_position_gui_obj_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in save_button.
function save_button_Callback(hObject, ~, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dropletsArray = [];
for i=1:length(handles.timepoints)
    dropletsArray = [dropletsArray, handles.timepoints(i).droplets];
end
droplets = dropletStruct(dropletsArray);
if ~isfield(handles, 'outFilename') || ~ischar(handles.outFilename)
    [p,n,e] = fileparts(handles.filenames{1});
    k = strfind(n, '_T0');
    if ~isempty(k);
        ind = max(k(end) - 1, 1);
        n = n(1:ind);
    end
    handles.outFilename = fullfile(p,[n,'.mat']);
end
[filename,dirname] = uiputfile(handles.outFilename);
display(filename);
if filename ~= 0;
    handles.outFilename = fullfile(dirname,filename);
    guidata(hObject,handles);
    save(handles.outFilename,'droplets','-v7.3');
end

% --- Executes on button press in add_droplet.
function add_droplet_Callback(hObject, ~, handles)
% hObject    handle to add_droplet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.callbackrunning)
    cancelCircle(hObject, handles);
    return;
end
handles.callbackrunning = true;
guidata(hObject, handles);
droplet = newDroplet(hObject, handles);
if validDroplet(droplet)
    dropletNum = length(handles.timepoints(handles.curTimepoint).droplets) + 1;
    handles.timepoints(handles.curTimepoint).droplets(dropletNum) = droplet;
    handles.callbackrunning = false;
    guidata(hObject, handles);
    posSelectDroplet(droplet,droplet.getPosition, hObject);
    handles = guidata(hObject);
    handles = updateShowHideButton(hObject,handles);
    handles = updateAuxCircles(hObject, handles);
end
% posSelect(handles.timepoints(handles.curTimepoint).droplets(dropletNum).dropletCircle.getPosition, hObject, handles.timepoints(handles.curTimepoint).droplets(dropletNum));

% --- Executes on button press in clear_droplets.
function clear_this_timepoint_Callback(hObject, ~, handles)
% hObject    handle to clear_droplets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = cancelCircle(hObject, handles);
handles = clear_droplets(hObject, handles);
handles = updateShowHideButton(hObject, handles);
handles = updateAuxCircles(hObject, handles);
guidata(hObject, handles);

function handles = changePlane(hObject, handles, newPlane)
handles = cancelCircle(hObject, handles);
handles.curPlane = newPlane;
guidata(hObject, handles);
handles.timepoints(handles.curTimepoint).droplets.setColors;
handles = updateImage(hObject, handles);
handles = updateAuxCircles(hObject, handles);

function handles = changeChannel(hObject, handles, newChannel)
%         handles = cancelCircle(hObject, handles);
handles.curChannel = newChannel;
guidata(hObject, handles);
handles = updateImage(hObject, handles);
handles = updateAuxCircles(hObject, handles);

% --- Executes on slider movement.
function plane_slider_Callback(hObject, eventdata, handles)
% hObject    handle to plane_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%     handles = cancelCircle(hObject, handles);
%     handles.curPlane = round(get(hObject,'Value'));
%     guidata(hObject, handles);
%     handles.timepoints(handles.curTimepoint).droplets.setColors;
%     handles = updateImage(hObject, handles);
%     handles = updateAuxCircles(hObject, handles);
handles = changePlane(hObject, handles, round(get(hObject,'Value')));

% --- Executes during object creation, after setting all properties.
function plane_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plane_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function handles = changeTimePoint(hObject, handles, newTimePoint)
handles = cancelCircle(hObject, handles);
deselect(handles.selectedDroplet);
handles.selectedDroplet = emptyDroplet;
handles.timepoints(handles.curTimepoint).droplets.hideDroplet;
handles.curTimepoint = newTimePoint;
set(handles.time_slider,'Value',newTimePoint);
if handles.showDroplets
    handles.timepoints(handles.curTimepoint).droplets.showDroplet;
end
handles = updateImage(hObject, handles);
handles = updateShowHideButton(hObject, handles);
handles = updateAuxCircles(hObject, handles);
guidata(hObject, handles);


% --- Executes on slider movement.
function time_slider_Callback(hObject, eventdata, handles)
% hObject    handle to time_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% handles = cancelCircle(hObject, handles);
% deselect(handles.selectedDroplet);
% handles.selectedDroplet = emptyDroplet;
% handles.timepoints(handles.curTimepoint).droplets.hideDroplet;
% handles.curTimepoint = round(get(hObject,'Value'));
% if handles.showDroplets
%     handles.timepoints(handles.curTimepoint).droplets.showDroplet;
% end
% handles = updateImage(hObject, handles);
% handles = updateShowHideButton(hObject, handles);
% handles = updateAuxCircles(hObject, handles);
% guidata(hObject, handles);
handles = changeTimePoint(hObject, handles, round(get(hObject,'Value')));

% --- Executes during object creation, after setting all properties.
function time_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in export.
function export_Callback(hObject, eventdata, handles)
% hObject    handle to export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% uiresume;
cancelCircle(hObject, handles)

% --- Executes on button press in remove_droplet.
function remove_droplet_Callback(hObject, eventdata, handles)
% hObject    handle to remove_droplet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = cancelCircle(hObject, handles);
if ~isempty(handles.selectedDroplet) && isvalid(handles.selectedDroplet)
    delete(handles.selectedDroplet);
    i = 1;
    while i <= length(handles.timepoints(handles.curTimepoint).droplets)
        if ~isvalid(handles.timepoints(handles.curTimepoint).droplets(i))
            handles.timepoints(handles.curTimepoint).droplets(i) = [];
            i = i-1;
        end
        i = i+1;
    end
end
handles.selectedDroplet = emptyDroplet;
handles = updateShowHideButton(hObject, handles);
handles = updateAuxCircles(hObject, handles);
guidata(hObject, handles);

% --- Executes on button press in add_aggregate.
function add_aggregate_Callback(hObject, eventdata, handles)
% hObject    handle to add_aggregate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if ~isempty(handles.selectedDroplet) && isvalid(handles.selectedDroplet.dropletCircle)
if(handles.callbackrunning)
    cancelCircle(hObject, handles);
    return;
end
droplet = handles.selectedDroplet;
if ~isempty(droplet) && isvalid(droplet) && ~validAggregate(droplet)
    handles.callbackrunning = true;
    guidata(hObject, handles);
    droplet.initializeAggregate;
    droplet.setAggregatePlane;
    %     guidata(hObject, handles);
end
if ~(validDroplet(droplet) && validAggregate(droplet))
    return
end
handles = guidata(hObject);
handles.callbackrunning = false;
guidata(hObject, handles);

% --- Executes on button press in remove_aggregate.
function remove_aggregate_Callback(hObject, eventdata, handles)
% hObject    handle to remove_aggregate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = cancelCircle(hObject, handles);
if ~isempty(handles.selectedDroplet) && isvalid(handles.selectedDroplet)
    if handles.selectedDroplet.validAggregate
        handles.selectedDroplet.removeAggregate;
    end
end

% --- Executes on button press in set_aggregate_plane.
function set_aggregate_plane_Callback(hObject, eventdata, handles)
% hObject    handle to set_aggregate_plane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = cancelCircle(hObject, handles);
if validDroplet(handles.selectedDroplet) && validAggregate(handles.selectedDroplet)
    setAggregatePlane(handles.selectedDroplet, handles.curPlane)
    handles.selectedDroplet.setColors;
end

% --- Executes on button press in set_droplet_plane.
function set_droplet_plane_Callback(hObject, eventdata, handles)
% hObject    handle to set_droplet_plane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = cancelCircle(hObject, handles);
if validDroplet(handles.selectedDroplet)
    setDropletPlane(handles.selectedDroplet, handles.curPlane)
    handles.selectedDroplet.setColors;
end
handles = updateAuxCircles(hObject, handles);

% --- Executes on button press in copy_prev.
function copy_prev_Callback(hObject, eventdata, handles)
% hObject    handle to copy_prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
timepoint = handles.curTimepoint;
if timepoint > handles.jump && length(handles.timepoints(timepoint - handles.jump).droplets) > 0
    cpDroplets = copyToTimepoint(handles.timepoints(timepoint - handles.jump).droplets,...
        handles.timepoints(timepoint).filename, timepoint, (timepoint - 1) * handles.timePerFrame + handles.initTime);
    handles.timepoints(timepoint).droplets = [handles.timepoints(timepoint).droplets, cpDroplets];
    guidata(hObject, handles);
    cpDroplets.showDroplet;
end
handles = updateShowHideButton(hObject, handles);
handles = updateAuxCircles(hObject, handles);

% --- Executes on button press in copy_next.
function copy_next_Callback(hObject, eventdata, handles)
% hObject    handle to copy_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
timepoint = handles.curTimepoint;
if timepoint <= (length(handles.timepoints) - handles.jump) && length(handles.timepoints(timepoint + handles.jump).droplets) > 0
    cpDroplets = copyToTimepoint(handles.timepoints(timepoint + handles.jump).droplets,...
        handles.timepoints(timepoint).filename, timepoint, (timepoint - 1) * handles.timePerFrame + handles.initTime);
    handles.timepoints(timepoint).droplets = [handles.timepoints(timepoint).droplets, cpDroplets];
    guidata(hObject, handles);
    cpDroplets.showDroplet;
end
handles = updateShowHideButton(hObject, handles);
handles = updateAuxCircles(hObject, handles);

% --- Executes on button press in auto_detect.
function auto_detect_Callback(hObject, eventdata, handles)
% hObject    handle to auto_detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.callbackrunning)
    cancelCircle(hObject, handles);
    return;
end
if validDroplet(handles.selectedDroplet)
    radius = handles.selectedDroplet.getDropletDiameter / 2 / handles.micronsPerPixel;
    display('Auto detecting...');
    [centers, radii, ~] = imfindcircles(handles.image.CData, round([radius - 5, radius + 5]),'ObjectPolarity','dark','Sensitivity',0.98);
    display('Auto detect complete');
    if ~isempty(radii)
        position = [centers(1,1) - radii(1), centers(1,2) - radii(1), radii(1)*2, radii(1)*2]
        handles.selectedDroplet.setPosition(position);
    end
else
    display('Auto detecting...');
    [centers, radii, ~] = imfindcircles(handles.image.CData, round([40,100] / handles.micronsPerPixel),'ObjectPolarity','dark','Sensitivity',0.98);
    display('Auto detect complete');
    if ~isempty(radii)
        for i =1:length(radii)
            position = [centers(i,1) - radii(i), centers(i,2) - radii(i), radii(i)*2, radii(i)*2]
            droplet = newDroplet(hObject, handles, position);
            handles = guidata(hObject);
            if validDroplet(droplet)
                dropletNum = length(handles.timepoints(handles.curTimepoint).droplets) + 1;
                handles.timepoints(handles.curTimepoint).droplets(dropletNum) = droplet;
                handles.callbackrunning = false;
                guidata(hObject, handles);
                posSelectDroplet(droplet,droplet.getPosition, hObject);
            end
        end
    end
end
handles = guidata(hObject);
handles = updateShowHideButton(hObject, handles);
handles = updateAuxCircles(hObject, handles);

% --- Executes on button press in show_hide_droplets.
function show_hide_droplets_Callback(hObject, eventdata, handles)
% hObject    handle to show_hide_droplets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.showDroplets
    hideDroplet(handles.timepoints(handles.curTimepoint).droplets);
    handles.showDroplets = false;
else
    showDroplet(handles.timepoints(handles.curTimepoint).droplets);
    handles.showDroplets = true;
end
guidata(hObject, handles);
handles = updateShowHideButton(hObject, handles);
handles = updateAuxCircles(hObject, handles);

% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~exist('handles','var')
    handles = guidata(hObject);
end
if ~isempty(handles.selectedDroplet) && isvalid(handles.selectedDroplet)
    deselect(handles.selectedDroplet)
end
handles.selectedDroplet = emptyDroplet;
guidata(hObject, handles);

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% display(['figure1_WindowKeyPressFcn:', eventdata.Key]);
droplet = handles.selectedDroplet;
move = 0.5;
if strcmp(eventdata.Modifier, 'shift')
    switch eventdata.Key
        case 'uparrow'
            if validDroplet(droplet)
                pos = droplet.getPosition;
                pos(2) = pos(2) - move;
                droplet.setPosition(pos);
            end
        case 'downarrow'
            if validDroplet(droplet)
                pos = droplet.getPosition;
                pos(2) = pos(2) + move;
                droplet.setPosition(pos);
            end
        case 'leftarrow'
            if validDroplet(droplet)
                pos = droplet.getPosition;
                pos(1) = pos(1) - move;
                droplet.setPosition(pos);
            end
        case 'rightarrow'
            if validDroplet(droplet)
                pos = droplet.getPosition;
                pos(1) = pos(1) + move;
                droplet.setPosition(pos);
            end
    end
else
    switch eventdata.Key
        case 'uparrow'
            if validDroplet(droplet)
                pos = droplet.getAggPosition;
                pos(2) = pos(2) - move;
                droplet.setAggPosition(pos);
            end
        case 'downarrow'
            if validDroplet(droplet)
                pos = droplet.getAggPosition;
                pos(2) = pos(2) + move;
                droplet.setAggPosition(pos);
            end
        case 'leftarrow'
            if validDroplet(droplet)
                pos = droplet.getAggPosition;
                pos(1) = pos(1) - move;
                droplet.setAggPosition(pos);
            end
        case 'rightarrow'
            if validDroplet(droplet)
                pos = droplet.getAggPosition;
                pos(1) = pos(1) + move;
                droplet.setAggPosition(pos);
            end
        case 'n'
            if ~validDroplet(droplet)
                if ~isempty(handles.timepoints(handles.curTimepoint).droplets)
                    handles.selectedDroplet = handles.timepoints(handles.curTimepoint).droplets(1);
                    select(handles.selectedDroplet);
                end
            else
                for num=1:length(handles.timepoints(handles.curTimepoint).droplets)
                    if isequal(handles.timepoints(handles.curTimepoint).droplets(num), droplet)
                        break;
                    end
                end
                deselect(droplet);
                if num == length(handles.timepoints(handles.curTimepoint).droplets)
                    handles.selectedDroplet = emptyDroplet;
                else
                    handles.selectedDroplet = handles.timepoints(handles.curTimepoint).droplets(num+1);
                    select(handles.selectedDroplet);
                end
            end
            guidata(hObject, handles);
    end
end
% --- Executes on slider movement.
function min_slider_Callback(hObject, eventdata, handles)
% hObject    handle to min_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

minVal = get(hObject,'Value');
if minVal >= handles.max
    minVal = max(handles.max - 0.01, 0);
    set(hObject, 'Value', minVal);
end
handles.min = minVal;
updateImage(hObject, handles);


% --- Executes during object creation, after setting all properties.
function min_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function max_slider_Callback(hObject, eventdata, handles)
% hObject    handle to max_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
maxVal = get(hObject,'Value');
if maxVal <= handles.min
    maxVal = min(handles.min + 0.01, 1);
    set(hObject, 'Value', maxVal);
end
handles.max = maxVal;
updateImage(hObject, handles);

% --- Executes during object creation, after setting all properties.
function max_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function gamma_slider_Callback(hObject, eventdata, handles)
% hObject    handle to gamma_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.gamma = get(hObject,'Value');
updateImage(hObject, handles);


% --- Executes during object creation, after setting all properties.
function gamma_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in auto_adjust_button.
function auto_adjust_button_Callback(hObject, eventdata, handles)
% hObject    handle to auto_adjust_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = autoAdjust(hObject, handles);


% --- Executes on button press in manual_adjust.
function manual_adjust_Callback(hObject, eventdata, handles)
% hObject    handle to manual_adjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of manual_adjust
value = get(hObject,'Value');
if value
    enable = 'on';
else
    enable = 'off';
end
handles.manualAdjust = value;
set(handles.auto_adjust_button,'Enable',enable);
set(handles.gamma_slider,'Enable',enable);
set(handles.min_slider,'Enable',enable);
set(handles.max_slider,'Enable',enable);
updateImage(hObject, handles);


% --- Executes on button press in auto_batch_button.
function auto_batch_button_Callback(hObject, eventdata, handles)
% hObject    handle to auto_batch_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stopAutoDetect = false;
guidata(hObject, handles);
curTimepoint = handles.curTimepoint;
from = str2num(handles.auto_from_text.String);
to = str2num(handles.auto_to_text.String);
if isempty(from) || isempty(to)
    warning('DROPLETGUI:W','To and From must be numerical');
    return;
end
if to < from
    warning('DROPLETGUI:W','To < From');
    return;
end
if from < 0 || to > handles.numOfTimepoints
    warning('DROPLETGUI:W','To and From must be between 0 and %d', handles.numOfTimepoints);
    return;
end
prototypeDroplet = handles.selectedDroplet;
if ~validDroplet(prototypeDroplet) || ~validAggregate(prototypeDroplet)
    warning('DROPLETGUI:W','please select a prototype droplet with aggregate');
    return;
end
display(sprintf('Autodetecting aggregate position, timepoints %d-%d...', from, to));

detectDroplet = handles.checkbox_drop_detect.Value;
% useGrad = handles.use_grad_checkbox.Value;
method = handles.grad1_radio.Value + 2*handles.grad2_radio.Value ...
    + 3*handles.max_radio.Value + 4*handles.min_radio.Value + 5*handles.circle_radio.Value;

%     AggPosition = prototypeDroplet.getAggPosition;
AggPosition = prototypeDroplet.getAggPosition;
origSize = AggPosition([3,4]);
for timepoint = from:to
    dropletPos = prototypeDroplet.getPosition;
    display(sprintf('Timepoint %d (%d/%d)', timepoint, timepoint - from + 1, to - from + 1));
    if timepoint == curTimepoint
        cpDroplet = prototypeDroplet;
    else
        cpDroplet = copyToTimepoint(prototypeDroplet,...
            handles.timepoints(timepoint).filename, timepoint, (timepoint - 1) * handles.timePerFrame + handles.initTime);
    end
    if detectDroplet
        cropMargin = 6;
        I = handles.timepoints(timepoint).images{prototypeDroplet.dropletPlane};
        cropped_image = imcrop(I,dropletPos + [-cropMargin, -cropMargin, cropMargin * 2, cropMargin * 2]);
        dropletPosMove = detect_droplet_movement(cropped_image, [cropMargin, cropMargin, dropletPos(3:4)], [16, 16]);
        dropletPos = dropletPosMove + [dropletPos(1:2) - [cropMargin, cropMargin], 0, 0];
        cpDroplet.setPosition(dropletPos);
    end
    aggPlane = cpDroplet.aggregatePlane;
    AggPosition = cpDroplet.getAggPosition;
    %         for repeat = 1:2
    for plane = 1:handles.numOfPlanes
        %         plane = handles.curPlane;
        %                 cropped_image = imcrop(handles.timepoints(timepoint).images{prototypeDroplet.aggregatePlane},dropletPos);
        cropped_image = imcrop(handles.timepoints(timepoint).images{plane},dropletPos);
        %             cropped_image(cropped_image == max(cropped_image(:))) = 0;
        %             cropped_image = imadjust(cropped_image, stretchlim(cropped_image, [0.01,0.96]));
        switch(method)
            case 1
                hy = fspecial('sobel');
                hx = hy';
                Iy = imfilter(double(cropped_image), hy, 'replicate');
                Ix = imfilter(double(cropped_image), hx, 'replicate');
                cropped_image_gr = sqrt(Ix.^2 + Iy.^2);
                I = cropped_image_gr;
                [DetectedAggPosition{plane}, measure(plane)] = detect_aggregate_movement(I, AggPosition - [dropletPos(1:2), 0, 0], [2, 2], origSize);
            case 2
                [Ix, Iy] = gradient(double(cropped_image)/double(max(cropped_image(:))));
                cropped_image_gr = sqrt(Ix.^2 + Iy.^2);
                I = cropped_image_gr;
                [DetectedAggPosition{plane}, measure(plane)] = detect_aggregate_movement(I, AggPosition - [dropletPos(1:2), 0, 0], [2, 2], origSize);
            case 3
                I = cropped_image;
                [DetectedAggPosition{plane}, measure(plane)] = detect_aggregate_movement(I, AggPosition - [dropletPos(1:2), 0, 0], [2, 2], origSize);
            case 4
                I = max(cropped_image(:))-cropped_image;
                [DetectedAggPosition{plane}, measure(plane)] = detect_aggregate_movement(I, AggPosition - [dropletPos(1:2), 0, 0], [2, 2], origSize);
            case 5
                %                     hy = fspecial('sobel');
                %                     hx = hy';
                %                     Iy = imfilter(double(cropped_image), hy, 'replicate');
                %                     Ix = imfilter(double(cropped_image), hx, 'replicate');
                %                     cropped_image_gr = sqrt(Ix.^2 + Iy.^2);
                %                     I = cropped_image_gr;
                I = cropped_image;
                [DetectedAggPosition{plane}, measure(plane)] = detect_aggregate_movement_imfindcircles(I, AggPosition - [dropletPos(1:2), 0, 0], 10);
        end
    end
    [~,bestPlane] = max(measure);
    if (bestPlane > 1) && (bestPlane < handles.numOfPlanes)
        aggPlane = bestPlane + (log(measure(bestPlane - 1)) - log(measure(bestPlane + 1)))/(2*(log(measure(bestPlane + 1)) - 2*log(measure(bestPlane)) + log(measure(bestPlane - 1))));
    else
        aggPlane = bestPlane;
    end
    if ~isreal(aggPlane)
        warning('DROPLETGUI:W',sprintf('timepoint %d: aggPlane complex',timepoint));
        aggPlane = real(aggPlane);
    end
    AggPosition = DetectedAggPosition{bestPlane} + [dropletPos(1:2), 0, 0];
    %         end
    cpDroplet.setAggPosition(AggPosition);
    cpDroplet.setAggregatePlane(aggPlane)
    if timepoint ~= curTimepoint
        dropletNum = length(handles.timepoints(timepoint).droplets) + 1;
        handles.timepoints(timepoint).droplets(dropletNum) = cpDroplet;
    end
    prototypeDroplet = cpDroplet;
    newHandles = guidata(hObject);
    guidata(hObject, handles);
    handles = changeTimePoint(hObject, handles, timepoint);
    guidata(hObject, handles);
    handles = changePlane(hObject, handles, max(1,round(aggPlane)));
    handles = updateAuxCircles(hObject, handles);
    drawnow;
    if newHandles.stopAutoDetect
        display('Auto Detect Stopped');
        break
    end
end
guidata(hObject, handles);
display('Done');
% handles.timepoints(curTimepoint).droplets.showDroplet;
handles = updateShowHideButton(hObject, handles);
handles = updateAuxCircles(hObject, handles);


% --- Executes during object creation, after setting all properties.
function auto_from_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auto_from_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function auto_to_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auto_to_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function channel_slider_Callback(hObject, eventdata, handles)
% hObject    handle to channel_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = changeChannel(hObject, handles, round(get(hObject,'Value')));

% --- Executes during object creation, after setting all properties.
function channel_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function timepoints_to_clear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timepoints_to_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clear_timepoints.
function clear_timepoints_Callback(hObject, eventdata, handles)
% hObject    handle to clear_timepoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
timepointsToClear = str2num(handles.timepoints_to_clear.String);
handles = cancelCircle(hObject, handles);
handles = clear_droplets(hObject, handles, timepointsToClear);
handles = updateShowHideButton(hObject, handles);
handles = updateAuxCircles(hObject, handles);
guidata(hObject, handles);

% --- Executes on button press in this_to_end_to_clear.
function this_to_end_to_clear_Callback(hObject, eventdata, handles)
% hObject    handle to this_to_end_to_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
thisTP = handles.curTimepoint;
lastTP = handles.numOfTimepoints;
handles.timepoints_to_clear.String = sprintf('%d:%d',thisTP,lastTP);
guidata(hObject, handles);

% --- Executes on button press in clear_all.
function clear_all_Callback(hObject, eventdata, handles)
% hObject    handle to clear_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
timepointsToClear = 1:handles.numOfTimepoints;
handles = cancelCircle(hObject, handles);
handles = clear_droplets(hObject, handles, timepointsToClear);
handles = updateShowHideButton(hObject, handles);
handles = updateAuxCircles(hObject, handles);
guidata(hObject, handles);


% --- Executes on button press in this_tp_to_detect.
function this_tp_to_detect_Callback(hObject, eventdata, handles)
% hObject    handle to this_tp_to_detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
thisTP = handles.curTimepoint;
handles.auto_from_text.String = num2str(thisTP);
handles.auto_to_text.String = num2str(thisTP);
guidata(hObject, handles);

% --- Executes on button press in this_to_end_tp_to_detect.
function this_to_end_tp_to_detect_Callback(hObject, eventdata, handles)
% hObject    handle to this_to_end_tp_to_detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
thisTP = handles.curTimepoint;
lastTP = handles.numOfTimepoints;
handles.auto_from_text.String = num2str(thisTP);
handles.auto_to_text.String = num2str(lastTP);
guidata(hObject, handles);

function checkbox_drop_detect_Callback(hObject, eventdata, handles)

function auto_to_text_Callback(hObject, eventdata, handles)

function auto_from_text_Callback(hObject, eventdata, handles)

function timepoints_to_clear_Callback(hObject, eventdata, handles)

function figure1_KeyReleaseFcn(hObject, eventdata, handles)

function figure1_KeyPressFcn(hObject, eventdata, handles)


% --- Executes on button press in stop_autodetect.
function stop_autodetect_Callback(hObject, eventdata, handles)
% hObject    handle to stop_autodetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handels.stopAutoDetect = true;
guidata(hObject, handels);

