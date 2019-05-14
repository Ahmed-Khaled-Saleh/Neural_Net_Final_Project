function varargout = Perceptron(varargin)
% PERCEPTRON MATLAB code for Perceptron.fig
%      PERCEPTRON, by itself, creates a new PERCEPTRON or raises the existing
%      singleton*.
%
%      H = PERCEPTRON returns the handle to a new PERCEPTRON or the handle to
%      the existing singleton*.
%
%      PERCEPTRON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PERCEPTRON.M with the given input arguments.
%
%      PERCEPTRON('Property','Value',...) creates a new PERCEPTRON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Perceptron_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Perceptron_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Perceptron

% Last Modified by GUIDE v2.5 13-May-2019 14:05:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Perceptron_OpeningFcn, ...
                   'gui_OutputFcn',  @Perceptron_OutputFcn, ...
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


% --- Executes just before Perceptron is made visible.
function Perceptron_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Perceptron (see VARARGIN)

% Choose default command line output for Perceptron
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
w = [50 20];
b = [-10];
p = [0 1; 0 1];

handles.w = w;
handles.b = b;
handles.p = p;
guidata(hObject,handles)

% UIWAIT makes Perceptron wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Perceptron_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Fimage.
function Fimage_Callback(hObject, eventdata, handles)
% hObject    handle to Fimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mksqlite('open', 'animals.db');
results = mksqlite('select * from animal' );
handles.p(:,1) = feature_extraction(results(randi([1 5])).photo);
mksqlite('close');
 guidata(hObject,handles)



% --- Executes on button press in Simage.
function Simage_Callback(hObject, eventdata, handles)
% hObject    handle to Simage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mksqlite('open', 'animals.db');
results = mksqlite('select * from animal' );
handles.p(:,2) = feature_extraction(results(randi([6 10])).photo);
mksqlite('close');
 guidata(hObject,handles)


% --- Executes on button press in train.
function train_Callback(hObject, eventdata, handles)
% hObject    handle to train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
persistent i
persistent b
persistent w

t = [0 1];
st = 0;

while true
        
if isempty(b)
    b= handles.b;
end
    
if isempty(w)
   w= handles.w;
end
    
g = 10;
e = 0;
st = b;
while(g > 0)
 if isempty(i) || i > 2
    i = 1;
 end
 
  n = w * handles.p(:, i) + b;
  a = hardlim(n);
  e = t(:, i) - a;
  w = w + e *handles.p(:, i)';
  b = b + e; 
 
  i = i + 1;
  g = g - 1;
 end
 
  if st == b 
    break; 
  end
  
  fprintf('stop:%d\n', st);
 plotpv(handles.p,t);    
 hold on;
 plotpc(w,b);
 hold off;
 handles.w = w;
 handles.b = b;
 
 format short e
 myString = sprintf('%d', b);
 set(handles.B, 'string', myString);
 myString = sprintf(' %.3f ', w);
 set(handles.W, 'string', myString);
% fprintf('W: %d  ', handles.w);
%fprintf('B: %d\n', handles.b);

 guidata(hObject,handles);
 pause(.2); 
end

% --- Executes on button press in BEimage.
function BEimage_Callback(hObject, eventdata, handles)
% hObject    handle to BEimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 mksqlite('open', 'animals.db');
 results = mksqlite('select * from animal' );
 d = results(randi([1 10]));
 fprintf('the pic: %s', d.photo);
 df = feature_extraction(d.photo);
 mksqlite('close');
 p = df;
 w = handles.w;
 b = handles.b;
 n = w* p +b;
 a = hardlim(n);
 t = [0 1 a];
 pp = [handles.p, p]
 plotpv(pp,t);    
 hold on;
 plotpc(w,b);
 hold off;
 if a == 1
    myString = sprintf('Frog');
    set(handles.animal, 'string', myString);
 else
     myString = sprintf('Cow');
    set(handles.animal, 'string', myString);
 end

% --- Executes on button press in test.
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 df = get(handles.Eimage,'string');
 p = feature_extraction(df);
 w = handles.w;
 b = handles.b;
 n = w* p +b;
 a = hardlim(n);
 t = [0 1 a];
 pp = [handles.p, p]
 plotpv(pp,t);    
 hold on;
 plotpc(w,b);
 hold off;
 if a == 1
    myString = sprintf('Frog');
    set(handles.animal, 'string', myString);
 else
     myString = sprintf('Cow');
    set(handles.animal, 'string', myString);
 end
     


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Eimage_Callback(hObject, eventdata, handles)
% hObject    handle to Eimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Eimage as text
%        str2double(get(hObject,'String')) returns contents of Eimage as a double


% --- Executes during object creation, after setting all properties.
function Eimage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Eimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Netshow.
function Netshow_Callback(hObject, eventdata, handles)
% hObject    handle to Netshow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n = perceptron;

n = configure(n,handles.p,[0 1]);
view(n);
