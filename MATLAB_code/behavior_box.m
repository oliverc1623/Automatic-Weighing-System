function varargout = behavior_box(varargin)
% BEHAVIOR_BOX MATLAB code for behavior_box.fig
%      BEHAVIOR_BOX, by itself, creates a new BEHAVIOR_BOX or raises the existing
%      singleton*.
%
%      H = BEHAVIOR_BOX returns the handle to a new BEHAVIOR_BOX or the handle to
%      the existing singleton*.
%
%      BEHAVIOR_BOX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEHAVIOR_BOX.M with the given input arguments.
%
%      BEHAVIOR_BOX('Property','Value',...) creates a new BEHAVIOR_BOX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before behavior_box_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to behavior_box_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help behavior_box

% Last Modified by GUIDE v2.5 16-Jul-2018 12:27:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @behavior_box_OpeningFcn, ...
                   'gui_OutputFcn',  @behavior_box_OutputFcn, ...
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


% --- Executes just before behavior_box is made visible.
function behavior_box_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to behavior_box (see VARARGIN)

% Choose default command line output for behavior_box
handles.output = hObject;

% Update handles structure

% CLear all instances
delete(instrfindall);
cla;

% Update handles structure

% Initialize serial Sensor 1
handles.serial_handles{1} = serial('COM14', 'BaudRate', 9600);
handles.weight_handles{1} = weight_sensor('COM14');
set(handles.checkbox01, 'Value', 1)

handles.serial_handles{2} = serial('COM16', 'BaudRate', 9600);
handles.weight_handles{2} = weight_sensor('COM16');
%set(handles.checkbox02, 'Value', 1)

% handles.serial_handles{3} = serial('COM13', 'BaudRate', 9600);
% handles.weight_handles{3} = weight_sensor('COM13');
% set(handles.checkbox03, 'Value', 1)
% 
% handles.serial_handles{4} = serial('COM14', 'BaudRate', 9600);
% handles.weight_handles{4} = weight_sensor('COM14');
% set(handles.checkbox04, 'Value', 1)
% 
% handles.serial_handles{5} = serial('COM15', 'BaudRate', 9600);
% handles.weight_handles{5} = weight_sensor('COM15');
% set(handles.checkbox05, 'Value', 1)
% 
% handles.serial_handles{6} = serial('COM16', 'BaudRate', 9600);
% handles.weight_handles{6} = weight_sensor('COM16');
% set(handles.checkbox06, 'Value', 1)
% 
% handles.serial_handles{7} = serial('COM17', 'BaudRate', 9600);
% handles.weight_handles{7} = weight_sensor('COM17');
% set(handles.checkbox07, 'Value', 1)
% 
% handles.serial_handles{8} = serial('COM18', 'BaudRate', 9600);
% handles.weight_handles{8} = weight_sensor('COM18');
% set(handles.checkbox08, 'Value', 1)

handles.FID_list = zeros(8,1);
    
global isrunning
isrunning = zeros(12,1); % Which sensors are running...
isrunning(1:1) = 1; % First 3 are connected

global iswriting
iswriting = zeros(12,1);
iswriting(1:1) = 0;

global file_ids
file_ids = zeros(12,1); % empty cell
% 
%handles.weight_handles{1}.sensor1SetCfactor('-38650');
%handles.weight_handles{2}.sensor1SetCfactor('-42550');

%global checkboxColors
%checkboxColors = [handles.checkbox01, handles.checkbox02, handles.checkbox03, handles.checkbox04, handles.checkbox05, handles.checkbox06, handles.checkbox07, handles.checkbox08];

handles.gram_scale = 100;
handles.data = zeros(1000, 12);

guidata(hObject, handles);


function update_plot(hObject, eventdata, handles)
n_points_to_plot = 500;
i = 1;
global isrunning
global iswriting
global file_ids
%global checkboxColors

while 1
    % Check which channels to plot...
    idx = find(isrunning == 1);
    
    % Reset before 1000
    if i == 999
        i = 1; handles.data = zeros(1000, 12);
    end   
    starti = i-mod(i,n_points_to_plot)+1; 
    xAxes = [1:mod(i, n_points_to_plot)];     
    handles.p = plot(xAxes, handles.data(starti:i,idx));
    if length(idx) ~= 0
        for pp = 1:length(idx) % Iterate through active sensors
            s1 = handles.weight_handles{idx(pp)}.readWeight
            s2 = handles.weight_handles{2}.readWeight
            avg = (100*(s1+s2))/2
            handles.data(i, idx(pp)) = avg;
            %checkboxColors(pp).ForegroundColor = handles.p(pp).Color;
        end 
    end
    %set(handles.p, {'color'}, plotColors);
    title('Weight of Tree Shrews');
    ylabel('Weight in Grams');
    xlabel('Trials');
    drawnow;
    
    % Now iterate through the files that need to be written...
    idx_write = find(iswriting == 1);
    
    if length(idx_write) ~= 0
        for pp = 1:length(idx_write)
            fid = file_ids(idx_write(pp));
            % Write to file fprintf(fid, )
            disp(handles.data(i, idx_write(pp)));
            fprintf(fid, '%s: %s\n', datestr(now,'HH:MM:SS'), num2str(handles.data(i, idx_write(pp))) );
        end
    end
    
    if isappdata(handles.figure1,'stopPlot')
        rmappdata(handles.figure1,'stopPlot');
        break
    end
    
    pause(0.5);
    
    i = i+1; % iterate
    guidata(hObject, handles);
end
% UIWAIT makes scale_gui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = behavior_box_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_plot(hObject, eventdata, handles);

% Get default command line output from handles structure
varargout{1} = handles.output;

function checkbox_Callback(hObject, eventdata, handles)
sensor_n = str2double(hObject.Tag(end-1:end));
global isrunning
global checkboxColors
isrunning(sensor_n) = hObject.Value;
%checkboxColors(sensor_n) = [];
guidata(hObject, handles);

function tare_Callback(hObject, eventdata, handles)
sensor_n = str2double(hObject.Tag(end-1:end));
handles.weight_handles{sensor_n}.tareScale();
handles.weight_handles{2}.tareScale();
guidata(hObject, handles);

function savedir_Callback(hObject, eventdata, handles)
sensor_n = str2double(hObject.Tag(end-1:end));
global iswriting
iswriting(sensor_n) = 1;

global file_ids

locations = {handles.loc01};

isLoggingCheckBoxes = {handles.islog01};
set(isLoggingCheckBoxes{sensor_n}, 'Value', 1);

[fn, pathname, indx] = uiputfile(strcat(date,'.txt'));
File = fullfile(pathname, fn);
locations{sensor_n}.String = File;
file_ids(sensor_n) = fopen(File, 'wt');

guidata(hObject, handles);

function cf_Callback(hObject, eventdata, handles)
sensor_n = str2double(hObject.Tag(end-1:end));
newCf = hObject.String;
handles.weight_handles{sensor_n}.sensor1SetCfactor(newCf);
handles.weight_handles{2}.sensor1SetCfactor(newCf);

guidata(hObject, handles);

function load_Callback(hObject, eventdata, handles)
setappdata(handles.figure1,'stopPlot',1);

[filename1,filepath1]=uigetfile({'*.*','All Files'},...
  'Select Data File 1');
if isequal(filename1,0)
    disp('user selected cancel');
else
     %cd(filepath1);
  handles.rawdata1=load([filepath1 filename1]);
  plot(handles.rawdata1(:,2));

  title('Weight of Tree Shrews');
  ylabel('Weight in Grams');
  xlabel('Trials');
end

guidata(hObject, handles);

function end_Callback(hObject, eventdata, handles)
sensor_n = str2double(hObject.Tag(end-1:end));
cla reset;
% global isrunning
% global iswriting
% global file_ids
% 
% isrunning(sensor_n) = 0;
% iswriting(sensor_n) = 0;
fclose(file_ids(sensor_n));

guidata(hObject, handles);
