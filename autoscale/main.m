function varargout = main(varargin)
% MAIN M-file for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 09-May-2012 10:27:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

addpath('../common_scripts');

% Choose default command line output for main
handles.output = hObject;

set(handles.summary_text,'String',{''});

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function collection_id_edit_Callback(hObject, eventdata, handles)
% hObject    handle to collection_id_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of collection_id_edit as text
%        str2double(get(hObject,'String')) returns contents of collection_id_edit as a double


% --- Executes during object creation, after setting all properties.
function collection_id_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to collection_id_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in get_collection_button.
function get_collection_button_Callback(hObject, eventdata, handles)
% hObject    handle to get_collection_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    collection_id = str2num(get(handles.collection_id_edit,'String'));
    handles.collection = get_collection(collection_id);
    
    clear_all(hObject,handles);

    set(handles.description_text,'String',handles.collection.description);
    
    populate_listboxes(handles);
    
    msgbox('Finished loading collection');
    
    % Update handles structure
    guidata(hObject, handles);
catch ME
    msgbox('Invalid collection ID');
end


% --- Executes on selection change in group_by_listbox.
function group_by_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to group_by_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns group_by_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from group_by_listbox


% --- Executes during object creation, after setting all properties.
function group_by_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to group_by_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in group_by_time_pushbutton.
function group_by_time_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to group_by_time_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

group_by_time_pushbutton(hObject,handles);

% --- Executes on button press in group_by_classification_pushbutton.
function group_by_classification_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to group_by_classification_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

group_by_classification_pushbutton(hObject,handles);

% --- Executes on button press in group_by_time_and_classification_pushbutton.
function group_by_time_and_classification_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to group_by_time_and_classification_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

group_by_time_and_classification_pushbutton(hObject,handles);

% --- Executes on button press in run_pushbutton.
function run_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to run_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear_before_run(hObject,handles);

try
    collection = handles.collection;
catch ME
    msgbox('Load a collection');
    return;
end

try
    model_by_inxs = handles.model_by_inxs;
    selected = get(handles.model_by_listbox,'Value');
    model_by_inxs = {model_by_inxs{selected}};
catch ME
    msgbox('Select models');
    return;
end

% For OPLS (X and Y are switched, Y is now the labels)
Y = [];%NaN*ones(1,num_samples);
X = [];%NaN*ones(num_variables,num_samples);
s = 0;
for g = 1:length(model_by_inxs)    
    for i = 1:length(model_by_inxs{g})
        inx_unpaired = model_by_inxs{g}(i);
        s = s + 1;
        X(:,s) = collection.Y(:,inx_unpaired);
        Y(s) = g;
    end
end

% Save a few things for later
handles.X = X';
handles.Y = Y';

contents = get(handles.model_by_listbox,'String');
groups = {contents{get(handles.model_by_listbox,'Value')}};
str = [];
for g = 1:length(groups)
    str = [str,' ',groups{g}];
end
add_line_to_summary_text(handles.summary_text,['Finished running:',str]);

% Update handles structure
guidata(hObject, handles);

function add_line_to_summary_text(h,line)
current = get(h,'String');
current{end+1} = line;
set(h,'String',current);


% --- Executes on button press in post_to_analysis_pushbutton.
function post_to_analysis_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to post_to_analysis_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

username = [];
password = [];
if isempty(username) || isempty(password)
    [username,password] = logindlg;
end

file = tempname;
saveas(handles.figure1,[file,'.fig']);

prompt={'Analysis ID:','Description:','File name:'};
name='Input for uploading file';
numlines=1;
defaultanswer={'','Auto-scaled','autoscale_results'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
analysis_id = answer{1};
description = answer{2};
pretty_file_name = answer{3};

f = fopen([file,'.fig']); 
d = fread(f,Inf,'*uint8'); % Read in byte stream
fclose(f); 
str = urlreadpost('http://birg.cs.wright.edu/omics_analysis/saved_files', ... 
        {'data',d,'name',username,'password',password,'analysis_id',analysis_id,'description',description,'pretty_file_name',pretty_file_name});
fprintf(str);

% --- Executes on button press in load_collection_pushbutton.
function load_collection_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to load_collection_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    collections = load_collections;
    if isempty(collections)
        return
    end
    if length(collections) > 1
        msgbox('Only load a single collection');
        return;
    end
    handles.collection = collections{1};
    
    clear_all(hObject,handles);
    
    set(handles.description_text,'String',handles.collection.description);
    
    populate_listboxes(handles);

    msgbox('Finished loading collection');
    
    % Update handles structure
    guidata(hObject, handles);
catch ME
    msgbox('Invalid collection');
end

function populate_listboxes(handles)
flds = fields(handles.collection);
valid_flds = {};
for i = 1:length(flds)
    [rows,cols] = size(handles.collection.(flds{i}));
    if rows == 1 && cols == handles.collection.num_samples
        valid_flds{end+1} = flds{i};
    end
end
sorted_valid_flds = sort(valid_flds);

set(handles.model_by_fields_listbox,'String',{'',sorted_valid_flds{:}});
set(handles.model_by_fields_listbox,'Max',length({'',sorted_valid_flds{:}}));

% --- Executes on selection change in model_by_listbox.
function model_by_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to model_by_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns model_by_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from model_by_listbox


% --- Executes during object creation, after setting all properties.
function model_by_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to model_by_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in model_by_time_pushbutton.
function model_by_time_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to model_by_time_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

model_by_time_pushbutton(hObject,handles);

% --- Executes on button press in model_by_classification_pushbutton.
function model_by_classification_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to model_by_classification_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

model_by_classification_pushbutton(hObject,handles);

% --- Executes on button press in model_by_time_and_classification_pushbutton.
function model_by_time_and_classification_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to model_by_time_and_classification_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

model_by_time_and_classification_pushbutton(hObject,handles);

function new_collection = scale(handles,new_collection,type)
means = mean(handles.X);
stdevs = std(handles.X);
if strcmp(type,'Auto-scale')
    for j = 1:new_collection.num_samples
        new_collection.Y(:,j) = (new_collection.Y(:,j)-means')./stdevs';
    end
elseif strcmp(type,'Pareto scale')
    for j = 1:new_collection.num_samples
        new_collection.Y(:,j) = (new_collection.Y(:,j)-means')./stdevs';
    end
end

% --- Executes on button press in save_collection_pushbutton.
function save_collection_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_collection_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt={'Description:','File name:'};
name='Input for uploading file';
numlines=1;
defaultanswer={'Auto-scaled','autoscale_results'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
description = answer{1};
pretty_file_name = answer{2};

contents = get(handles.scaling_popupmenu,'String'); % returns scaling_popupmenu contents as cell array
type = contents{get(handles.scaling_popupmenu,'Value')};
new_collection = scale(handles,handles.collection,type);
new_collection.processing_log = [new_collection.processing_log,' ',description,'.'];
save_collections({new_collection},['_',pretty_file_name]);

% --- Executes on button press in post_collection_pushbutton.
function post_collection_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to post_collection_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


prompt={'Analysis ID:','Description:','File name:'};
name='Input for uploading file';
numlines=1;
defaultanswer={'','Auto-scaled','autoscale_results'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
analysis_id = answer{1};
description = answer{2};
pretty_file_name = answer{3};

contents = get(handles.scaling_popupmenu,'String'); % returns scaling_popupmenu contents as cell array
type = contents{get(handles.scaling_popupmenu,'Value')};
new_collection = scale(handles,handles.collection,type);
new_collection.processing_log = [new_collection.processing_log,' ',description,'.'];
post_collections(gcf,{new_collection},['_',pretty_file_name],analysis_id);

% --- Executes on button press in save_figure_pushbutton.
function save_figure_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_figure_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname] = uiputfile('*.fig', 'Save figure');
try
    if strcmp(filename,'main.fig')
        msgbox('Cannot overwrite main.fig. Pick another name and another directory.');
        return;
    end
    saveas(gcf,[pathname,filename]);
catch ME
end




% --- Executes on selection change in scaling_popupmenu.
function scaling_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to scaling_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns scaling_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from scaling_popupmenu


% --- Executes during object creation, after setting all properties.
function scaling_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scaling_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in model_by_fields_listbox.
function model_by_fields_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to model_by_fields_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns model_by_fields_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from model_by_fields_listbox

model_by_fields_listbox(hObject,handles);


% --- Executes during object creation, after setting all properties.
function model_by_fields_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to model_by_fields_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
