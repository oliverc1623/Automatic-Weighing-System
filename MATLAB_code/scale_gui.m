function varargout = scale_gui(varargin)
% SCALE_GUI MATLAB code for scale_gui.fig
%      SCALE_GUI, by itself, creates a new SCALE_GUI or raises the existing
%      singleton*.
%
%      H = SCALE_GUI returns the handle to a new SCALE_GUI or the handle to
%      the existing singleton*.
%
%      SCALE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCALE_GUI.M with the given input arguments.
%
%      SCALE_GUI('Property','Value',...) creates a new SCALE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scale_gui_OpeningFcn ge ts called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scale_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scale_gui

% Last Modified by GUIDE v2.5 27-Jun-2018 16:07:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scale_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @scale_gui_OutputFcn, ...
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


% --- Executes just before scale_gui is made visible.
function scale_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scale_gui (see VARARGIN)

% Choose default command line output for scale_gui
handles.output = hObject;

% CLear all instances
delete(instrfindall)
cla;
% Update handles structure

% Initialize serial object
handles.obj = serial('COM4', 'BaudRate',9600)
handles.m = weight_sensor('COM4')
handles.gram_scale = 100;
handles.run = true;

guidata(hObject, handles);

% UIWAIT makes scale_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = scale_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in tare_button.
function tare_button_Callback(hObject, eventdata, handles)
% hObject    handle to tare_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%x = (handles.m)
%x.tareScale()
handles.m.tareScale()
disp('Scale tared')

% --- Executes on button press in readweight_button.
function readweight_button_Callback(hObject, eventdata, handles)
% hObject    handle to readweight_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

n_points_to_plot = 500;

fileID = fopen('weight_data.txt', 'wt');

go = true;
while go
    for i = 1:1000
        data(i) = handles.gram_scale*handles.m.readWeight;
        starti = i-mod(i,n_points_to_plot)+1;   
        %write to file
        fprintf(fileID, '%s: %s\n', datestr(now,'HH:MM:SS'), num2str(data(i)));
        %plot graph
        plot([1:mod(i, n_points_to_plot)], data(starti:i));
        title('Weight of Tree Shrews')
        ylabel('Weight in Grams')
        xlabel('Trials')
        drawnow
        pause(0.1)
        if mod(i, n_points_to_plot) == 1
            xlabel('timepoints');ylabel('Grams')
        end
        if isappdata(handles.figure1,'stopPlot')
            rmappdata(handles.figure1,'stopPlot');
            fclose(fileID);
            break
        end

        % Lastly update the moving average every 20 frames
        if mod(i, 10) == 1 & i>=30
            set(handles.moving_average_text, 'String', ...
                        sprintf('%3.1f', mean(data(end-30:end))))
        end
    end
end
guidata(hObject, handles);

% --- Executes on selection change in calibration_menu.
function calibration_menu_Callback(hObject, eventdata, handles)
% hObject    handle to calibration_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.which_loadcell = hObject.String{hObject.Value};
disp(sprintf('We are now using a %s load cell', handles.which_loadcell))
%disp(get(hObject, 'value'))

val = get(hObject, 'value')

switch val
    case 1
        handles.m.setCalibrationFactor(val);
        handles.gram_scale = 100;
        disp('cf is 1 kg')
    case 2
        handles.m.setCalibrationFactor(val);
        handles.gram_scale = 102;
        disp('cf is 5kg')
    case 3
        handles.m.setCalibrationFactor(val);
        handles.gram_scale = 514;
        disp('cf is 20 kg')
end

guidata(hObject, handles);


% Hints: contents = cellstr(get(hObject,'String')) returns calibration_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from calibration_menu


% --- Executes during object creation, after setting all properties.
function calibration_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calibration_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in end_reading.
function end_reading_Callback(hObject, eventdata, handles)
% hObject    handle to end_reading (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.figure1,'stopPlot',1);
% Update handles structure
guidata(hObject, handles);
