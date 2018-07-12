function varargout = scale_gui3(varargin)
% SCALE_GUI3 MATLAB code for scale_gui3.fig
%      SCALE_GUI3, by itself, creates a new SCALE_GUI3 or raises the existing
%      singleton*.
%
%      H = SCALE_GUI3 returns the handle to a new SCALE_GUI3 or the handle to
%      the existing singleton*.
%
%      SCALE_GUI3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCALE_GUI3.M with the given input arguments.
%
%      SCALE_GUI3('Property','Value',...) creates a new SCALE_GUI3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scale_gui3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scale_gui3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scale_gui3

% Last Modified by GUIDE v2.5 11-Jul-2018 16:57:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scale_gui3_OpeningFcn, ...
                   'gui_OutputFcn',  @scale_gui3_OutputFcn, ...
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


% --- Executes just before scale_gui3 is made visible.
function scale_gui3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scale_gui3 (see VARARGIN)

% Choose default command line output for scale_gui2
handles.output = hObject;

% Update handles structure

% CLear all instances
delete(instrfindall);
cla;

% Update handles structure

% Initialize serial Sensor 1

handles.serial_handles{1} = serial('COM4', 'BaudRate', 9600);
handles.weight_handles{1} = weight_sensor('COM4');
set(handles.checkbox01, 'Value', 1)

handles.serial_handles{2} = serial('COM6', 'BaudRate', 9600);
handles.weight_handles{2} = weight_sensor('COM6');
set(handles.checkbox02, 'Value', 1)

handles.serial_handles{3} = serial('COM13', 'BaudRate', 9600);
handles.weight_handles{3} = weight_sensor('COM13');
set(handles.checkbox03, 'Value', 1)

handles.FID_list = zeros(3,1);
    
global isrunning
isrunning = zeros(12,1); % Which sensors are running...
isrunning(1:3) = 1; % First 3 are connected

global iswriting
iswriting = zeros(12,1);
iswriting(1:3) = 0;

global file_ids
file_ids = zeros(12,1); % empty cell

global checkboxColors
checkboxColors = [handles.checkbox01, handles.checkbox02, handles.checkbox03];

handles.gram_scale = 100;
handles.data = zeros(1000, 12);
% index and checkbox
guidata(hObject, handles);



function update_plot(hObject, eventdata, handles)
n_points_to_plot = 500;
i = 1;
global isrunning
global iswriting
global file_ids
global checkboxColors

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
            handles.data(i, idx(pp)) = 100*handles.weight_handles{idx(pp)}.readWeight;
            checkboxColors(pp).ForegroundColor = handles.p(pp).Color;
        end 
    end
    %set(handles.p, {'color'}, plotColors);
    title('Weight of Tree Shrews');
    ylabel('Weight in Grams');
    xlabel('Trials');
    drawnow
    
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
    
    pause(0.05);
    
    i = i+1; % iterate
    guidata(hObject, handles);
end
% UIWAIT makes scale_gui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = scale_gui3_OutputFcn(hObject, eventdata, handles) 
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
checkboxColors = [];
guidata(hObject, handles);

function tare_Callback(hObject, eventdata, handles)
sensor_n = str2double(hObject.Tag(end-1:end));
handles.weight_handles{sensor_n}.tareScale();
guidata(hObject, handles);

function savedir_Callback(hObject, eventdata, handles)
sensor_n = str2double(hObject.Tag(end-1:end));
global iswriting
iswriting(sensor_n) = 1;

global file_ids

locations = {handles.loc01, handles.loc02, handles.loc03};

isLoggingCheckBoxes = {handles.islog01, handles.islog02, handles.islog03};
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
global isrunning
global iswriting
global file_ids

isrunning(sensor_n) = 0;
iswriting(sensor_n) = 0;
fclose(file_ids(sensor_n));

guidata(hObject, handles);
