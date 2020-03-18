function varargout = one_position_gui(varargin)
% ONE_POSITION_GUI MATLAB code for one_position_gui.fig
%      ONE_POSITION_GUI, by itself, creates a new ONE_POSITION_GUI or raises the existing
%      singleton*.
%
%      H = ONE_POSITION_GUI returns the handle to a new ONE_POSITION_GUI or the handle to
%      the existing singleton*.
%
%      ONE_POSITION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ONE_POSITION_GUI.M with the given input arguments.
%
%      ONE_POSITION_GUI('Property','Value',...) creates a new ONE_POSITION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before one_position_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to one_position_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help one_position_gui

% Last Modified by GUIDE v2.5 07-Jan-2018 19:26:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @one_position_gui_OpeningFcn, ...
    'gui_OutputFcn',  @one_position_gui_OutputFcn, ...
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


% --- Executes just before one_position_gui is made visible.
function one_position_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to one_position_gui (see VARARGIN)

% Choose default command line output for one_position_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if nargin > 3
    %set filenames
    % Load image files
    handles.filenames = varargin{1};
    handles.numOfTimepoints = length(handles.filenames);
    handles.timepoint = struct('images',{[]},'dropletPositions',[]);
    handles.timepoint = loadImages(handles.filenames);
    handles.timepointNum = 1;
    handles.droplets = emptyDroplet;
    handles.curPlane = 1;
    handles.selectedDroplet = emptyDroplet;
    handles.numOfPlanes = length(handles.timepoint(1).images);
else
    handles.filnames = {};
end

set(handles.time_slider,'Max',handles.numOfTimepoints);
set(handles.time_slider,'Min',1);
set(handles.time_slider,'Value',1);
if handles.numOfTimepoints > 1
    set(handles.time_slider,'sliderStep',[1/(handles.numOfTimepoints-1),1/(handles.numOfTimepoints-1)]);
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

%set(hObject,'WindowButtonDownFcn',@(hObject,eventdata) winPressed(hObject,eventdata,'down'));
%set(hObject,'WindowButtonUpFcn',@(hObject,eventdata) winPressed(hObject,eventdata,'up')) ;

guidata(hObject, handles);
updateImage(hObject, eventdata, handles);

% UIWAIT makes one_image_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function updateImage(hObject, eventdata, handles)
hold on
if isfield(handles,'image') && isvalid(handles.image)
    handles.image.delete;
end
handles.image = imshow(imadjust(handles.timepoint(handles.timepointNum).images{handles.curPlane}));
handles.image.ButtonDownFcn = @axes1_ButtonDownFcn;
handles.axes1.XLimMode='manual';
handles.axes1.YLimMode='manual';
uistack(handles.image,'bottom');
set(handles.timepoint_text,'String',sprintf('Timepoint %d/%d',handles.timepointNum,handles.numOfTimepoints));
set(handles.plane_text,'String',sprintf('Plane %d/%d',handles.curPlane,handles.numOfPlanes));
guidata(hObject, handles);

function timepoint = loadImages(filenames)
for i=1:length(filenames)
    timepoint(i).images = load_tiff_file(filenames{i},1);
    timepoint(i).dropletPositions = [];
end

function positions = dropletsToPositions(droplets)
positions = [];
for i = 1:length(droplets)
    if isvalid(droplets(i).dropletCircle)
        positions(i,:) = droplets(i).dropletCircle.getPosition;
    end
end

function droplets = positionsToDroplets(hObject, positions)
droplets = emptyDroplet;
for i = 1:size(positions,1);
    if length(positions(i,:)) == 4
        droplets(i) = newDroplet(hObject, positions(i,:));
    end
end


% --- Outputs from this function are returned to the command line.
function varargout = one_position_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in save_buttom.
function save_buttom_Callback(hObject, eventdata, handles)
% hObject    handle to save_buttom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in export_button.
function export_button_Callback(hObject, eventdata, handles)
% hObject    handle to export_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in add_droplet.
function add_droplet_Callback(hObject, ~, handles)
% hObject    handle to add_droplet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dropletNum = length(handles.droplets) + 1;
handles.droplets(dropletNum) = newDroplet(hObject);
guidata(hObject, handles);
posSelect(handles.droplets(dropletNum).dropletCircle.getPosition, hObject, handles.droplets(dropletNum));

function droplet = newDroplet(hObject, position)
droplet = emptyDroplet;
if exist('position', 'var') && length(position) == 4
    droplet.dropletCircle = imellipse(gca, position);
else
    droplet.dropletCircle = imellipse('PositionConstraintFcn',@(pos) [pos(1) pos(2) max(pos(3:4)) max(pos(3:4))]);
end
droplet.dropletCircle.setFixedAspectRatioMode( '1' );
droplet.dropletCircle.setPositionConstraintFcn(@(pos) posSelect(pos, hObject, droplet));
set(droplet.dropletCircle,'DeleteFcn',@(aO,ed) deleteDropletCircle(aO, ed, hObject, droplet));

function deleteDropletCircle(~, ~, hObject, droplet)
if isvalid(hObject)
    handles = guidata(hObject);
    for i = 1:length(handles.droplets)
        if isequal(handles.droplets(i), droplet)
            delete(handles.droplets(i).aggCircle)
            handles.droplets(i) = [];
            break
        end
    end
    if isequaln(handles.selectedDroplet,droplet)
        handles.selectedDroplet = emptyDroplet;
    end
    guidata(hObject, handles);
end


function pos = posSelect(pos, hObject, droplet)
handles = guidata(hObject);
if ~isempty(handles.selectedDroplet.dropletCircle) && isvalid(handles.selectedDroplet.dropletCircle)
    handles.selectedDroplet.dropletCircle.setColor([0,0.2,0])
    if ~isempty(handles.selectedDroplet.aggCircle) && isvalid(handles.selectedDroplet.aggCircle)
        handles.selectedDroplet.aggCircle.setColor([0.2,0.2,0])
    end
end
droplet.dropletCircle.setColor('g')
if ~isempty(droplet.aggCircle) && isvalid(droplet.aggCircle)
    droplet.aggCircle.setColor('y')
end
handles.selectedDroplet = droplet;
guidata(hObject, handles);


% --- Executes on button press in clear_droplets.
function clear_droplets_Callback(hObject, ~, handles)
% hObject    handle to clear_droplets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = clear_droplets(handles);
guidata(hObject, handles);


function handles = clear_droplets(handles)
delete([handles.droplets.dropletCircle]);
handles.droplets = emptyDroplet;
handles.selectedDroplet = emptyDroplet;


% --- Executes on slider movement.
function plane_slider_Callback(hObject, eventdata, handles)
% hObject    handle to plane_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.curPlane = round(get(hObject,'Value'));
guidata(hObject, handles);
updateImage(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function plane_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plane_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function time_slider_Callback(hObject, eventdata, handles)
% hObject    handle to time_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.timepoint(handles.timepointNum).dropletPositions =...
    dropletsToPositions(handles.droplets);
handles.timepointNum = round(get(hObject,'Value'));
handles = clear_droplets(handles);
handles.droplets = positionsToDroplets(hObject, handles.timepoint(handles.timepointNum).dropletPositions);
guidata(hObject, handles);
updateImage(hObject, eventdata, handles);

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


% --- Executes on button press in remove_droplet.
function remove_droplet_Callback(hObject, eventdata, handles)
% hObject    handle to remove_droplet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.selectedDroplet.dropletCircle) && isvalid(handles.selectedDroplet.dropletCircle)
    delete(handles.selectedDroplet.dropletCircle);
    i = 1;
    while i <= length(handles.droplets)
        if ~isvalid(handles.droplets(i).dropletCircle)
            handles.droplets = [];
            i = i-1;
        end
        i = i+1;
    end
end
handles.selectedDroplet = emptyDroplet;

function droplet = emptyDroplet
droplet = struct('dropletCircle',imellipse.empty,'aggCircle',imellipse.empty);

% --- Executes on button press in add_aggregate.
function add_aggregate_Callback(hObject, eventdata, handles)
% hObject    handle to add_aggregate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if ~isempty(handles.selectedDroplet) && isvalid(handles.selectedDroplet.dropletCircle)
if ~isempty(handles.selectedDroplet.dropletCircle)...
        && isvalid(handles.selectedDroplet.dropletCircle)...
        && (isempty(handles.selectedDroplet.aggCircle) || ~isvalid(handles.selectedDroplet.aggCircle))
    handles.selectedDroplet.aggCircle = imellipse();
    handles.selectedDroplet.aggCircle.setColor('y');
    guidata(hObject, handles);
end


% --- Executes on button press in clear_aggregates.
function clear_aggregates_Callback(hObject, eventdata, handles)
% hObject    handle to clear_aggregates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in remove_aggregate.
function remove_aggregate_Callback(hObject, eventdata, handles)
% hObject    handle to remove_aggregate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~exist('handles','var')
    handles = guidata(hObject);
end
if ~isempty(handles.selectedDroplet.dropletCircle) && isvalid(handles.selectedDroplet.dropletCircle)
    handles.selectedDroplet.dropletCircle.setColor([0,0.3,0])
    if ~isempty(handles.selectedDroplet.aggCircle) && isvalid(handles.selectedDroplet.aggCircle)
        handles.selectedDroplet.aggCircle.setColor([0.3,0.3,0])
    end

end
handles.selectedDroplet = emptyDroplet;
guidata(hObject, handles);

