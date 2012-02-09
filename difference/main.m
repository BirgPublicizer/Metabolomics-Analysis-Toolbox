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

% Last Modified by GUIDE v2.5 21-Jul-2011 16:08:01

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

set(handles.summary_text,'String',{});

set(handles.version_text,'String',get_version_string());

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function res = get_version_string()
res = '0r1';

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

handles = get_collection_pushbutton(handles);

populate_listboxes(handles);

msgbox('Finished loading collection');
    
% Update handles structure
guidata(hObject, handles);

% --- Executes on selection change in paired_by_listbox.
function paired_by_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to paired_by_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns paired_by_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from paired_by_listbox


% --- Executes during object creation, after setting all properties.
function paired_by_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to paired_by_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in run_pushbutton.
function run_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to run_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

clear_before_run(hObject,handles);

handles.group_by_inxs = {};
handles.group_by_inxs{1} = 1:size(handles.collection.Y,2);
[X,Y,available_X,available_Y,G,available_G] = get_run_data(hObject,handles);
contents = get(handles.paired_by_listbox,'String');
if ~isempty(contents)
    paired_by = contents{get(handles.paired_by_listbox,'Value')};
else
    paired_by = [];
end
if ~isempty(paired_by)
    add_line_to_summary_text(handles.summary_text,sprintf('Paired by: %s',paired_by));
end

inxs_to_keep = find(~isnan(available_Y));
new_collection = handles.collection;
input_names = handles.collection.input_names;
for i = 1:length(input_names)
    name = regexprep(input_names{i},' ','_');
    field_name = lower(name);
    if length(new_collection.(field_name)) == size(handles.collection.Y,2)
        if iscell(new_collection.(field_name))
            new_collection.(field_name) = {};
        else
            new_collection.(field_name) = [];
        end
        for j = 1:length(inxs_to_keep)
            ix = inxs_to_keep(j);
            if iscell(new_collection.(field_name))
                new_collection.(field_name){end+1} = handles.collection.(field_name){ix};
            else
                new_collection.(field_name)(end+1) = handles.collection.(field_name)(ix);
            end
        end
    end
end
new_collection.Y = available_X;
new_collection.num_samples = length(inxs_to_keep);
handles.new_collection = new_collection;

msgbox('Finished difference spectrum');

% Update handles structure
guidata(hObject, handles);

function add_line_to_summary_text(h,line)
current = get(h,'String');
current = {line,current{:}};
set(h,'String',current);

% --- Executes on button press in load_collection_pushbutton.
function load_collection_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to load_collection_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = load_collection_pushbutton(handles);

populate_listboxes(handles);

msgbox('Finished loading collection');
    
% Update handles structure
guidata(hObject, handles);

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

set(handles.paired_by_fields_listbox,'String',{'',sorted_valid_flds{:}});
set(handles.paired_by_fields_listbox,'Max',length({'',sorted_valid_flds{:}}));

% --- Executes on button press in about_pushbutton.
function about_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to about_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in paired_by_fields_listbox.
function paired_by_fields_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to paired_by_fields_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns paired_by_fields_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from paired_by_fields_listbox
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

paired_by_fields_listbox(hObject,handles);

% --- Executes during object creation, after setting all properties.
function paired_by_fields_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to paired_by_fields_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function summary_text_Callback(hObject, eventdata, handles)
% hObject    handle to summary_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of summary_text as text
%        str2double(get(hObject,'String')) returns contents of summary_text as a double


% --- Executes during object creation, after setting all properties.
function summary_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to summary_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in save_collection_pushbutton.
function save_collection_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_collection_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt={'File name:'};
name='Input for uploading file';
numlines=1;
defaultanswer={'difference_spectrum'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
pretty_file_name = answer{1};

new_collection = handles.new_collection;
new_collection.processing_log = [new_collection.processing_log,' Difference.'];
save_collections({new_collection},['_',pretty_file_name]);

% --- Executes on button press in post_collection_pushbutton.
function post_collection_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to post_collection_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt={'Analysis ID:'};
name='Enter the analysis ID from the website';
numlines=1;
defaultanswer={''};
answer=inputdlg(prompt,name,numlines,defaultanswer);
analysis_id = answer{1};        

new_collection = handles.new_collection;
new_collection.processing_log = [new_collection.processing_log,' Difference.'];
post_collections(gcf,{new_collection},'_difference',analysis_id);
