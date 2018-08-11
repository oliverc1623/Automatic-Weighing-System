function varargout = run_scale(varargin)
% RUN_SCALE MATLAB code for run_scale.fig
%      RUN_SCALE, by itself, creates a new RUN_SCALE or raises the existing
%      singleton*.
%
%      H = RUN_SCALE returns the handle to a new RUN_SCALE or the handle to
%      the existing singleton*.
%
%      RUN_SCALE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUN_SCALE.M with the given input arguments.
%
%      RUN_SCALE('Property','Value',...) creates a new RUN_SCALE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before run_scale_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to run_scale_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help run_scale

% Last Modified by GUIDE v2.5 06-Aug-2018 15:31:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @run_scale_OpeningFcn, ...
                   'gui_OutputFcn',  @run_scale_OutputFcn, ...
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

% --- Executes just before run_scale is made visible.
function run_scale_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to run_scale (see VARARGIN)

% Choose default command line output for run_scale
cla;
handles.output = hObject;
handles.system = scale_system;
set(handles.checkbox01, 'Value', 1);
set(handles.checkbox02, 'Value', 1);
set(handles.checkbox03, 'Value', 1);
set(handles.checkbox04, 'Value', 1);
handles.data = zeros(1000, 12);
title('Weight of Tree Shrews');    
ylabel('Weight in Grams');
xlabel('Trials');

handles.locationsTexts = {handles.loc01, handles.loc02, handles.loc03, handles.loc04, handles.loc05, handles.loc06, handles.loc07, handles.loc08, handles.loc09, handles.loc10, handles.loc11, handles.loc12};
handles.isLoggingCheckBoxes = {handles.islog01, handles.islog02, handles.islog03, handles.islog04, handles.islog05, handles.islog06, handles.islog07, handles.islog08, handles.islog09, handles.islog10, handles.islog11, handles.islog12};
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes run_scale wait for user response (see UIRESUME)
% uiwait(handles.figure1)
function update_plot(hObject, eventdata, handles)
n_points_to_plot = 500;
i = 1;  
% Instantiate system object
clearPorts(handles.system);
instantiatePorts(handles.system);
setIsRunning(handles.system, 4); % set number of boxes we want to run
while 1
    % Check which channels to plot...
    currentisrunning = handles.system.getIsRunning;
    idx = find(currentisrunning == 1);
    % Reset before 1000
    if i == 999
        i = 1; handles.data = zeros(1000, 12);
    end   
    starti = i-mod(i,n_points_to_plot)+1;
    xAxis = [1:mod(i, n_points_to_plot)];
    if length(idx) ~= 0
        for pp = 1:length(idx) % Iterate through active sensors
            handles.data(i, idx(pp)) = handles.system.getAvg(idx(pp));
        end
    end
    plot(xAxis, handles.data(starti:i,idx));
    title('Weight of Tree Shrews');
    ylabel('Weight in Grams');
    xlabel('Trials');
    drawnow; 
    % Now iterate through the files that need to be written...
    idx_write = find(handles.system.iswriting == 1);
    if length(idx_write) ~= 0
        for pp = 1:length(idx_write)
            fid = handles.system.file_ids(idx_write(pp));
            % Write to file fprintf(fid, )
            disp(handles.data(i, idx_write(pp)));
            fprintf(fid, '%s: %s\n', datestr(now,'HH:MM:SS'), num2str(handles.data(i, idx_write(pp))) );
        end
    end
    i = i+1; % iterate
    guidata(hObject, handles);
end

% --- Outputs from this function are returned to the command line.
function varargout = run_scale_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
update_plot(hObject, eventdata, handles);
varargout{1} = handles.output;

function checkbox_Callback(hObject, eventdata, handles)
sensor_n = str2double(hObject.Tag(end-1:end));
handles.system.modIsRunning(sensor_n, hObject.Value);
guidata(hObject, handles);

function tare_Callback(hObject, eventdata, handles)
sensor_n = str2double(hObject.Tag(end-1:end));
handles.system.tare(sensor_n);
guidata(hObject, handles);

function savedir_Callback(hObject, eventdata, handles)
sensor_n = str2double(hObject.Tag(end-1:end));
[fn, pathname, indx] = uiputfile(strcat(date,'.txt'));
if isequal(fn,0)
    disp('user selected cancel');
    set(handles.isLoggingCheckBoxes{sensor_n}, 'Value', 0); % update islog checkbox
else 
    handles.system.iswriting(sensor_n) = 1; % update list of sensors we'll be writing data from
    set(handles.isLoggingCheckBoxes{sensor_n}, 'Value', 1); % update islog checkbox
    File = fullfile(pathname, fn);
    handles.system.file_ids(sensor_n) = fopen(File, 'wt'); % store file in designated sensor list
    handles.locationsTexts{sensor_n}.String = File; % set text the file location of txt file
end

guidata(hObject, handles);

function cf_Callback(hObject, eventdata, handles)
sensor_n = str2double(hObject.Tag(end-1:end));
newCf = hObject.String;
handles.system.setNewCf(sensor_n, newCf);
guidata(hObject, handles);

function end_Callback(hObject, eventdata, handles)
sensor_n = str2double(hObject.Tag(end-1:end));
handles.system.iswriting(sensor_n) = 0;
fclose(handles.system.file_ids(sensor_n));
set(handles.isLoggingCheckBoxes{sensor_n}, 'Value', 0); % update islog checkbox
guidata(hObject, handles);
