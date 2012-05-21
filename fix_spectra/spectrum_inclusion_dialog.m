function varargout = spectrum_inclusion_dialog(varargin)
% Return list of spectra selected for inclusion
%
%   out = spectrum_inclusion_dialog({collections, use_spectrum})
%   
%   collections - a cell array of spectral collections. Each spectral
%                 collection is a struct. This is the format
%                 of the return value of load_collections.m in
%                 common_scripts.
%
%   out - cell array {handle, was_cancelled, use_spectrum}
%
%     handle        - the handle to the spectrum_inclusion_dialog
%
%     was_cancelled - true if the dialog box ended with the cancel button
%
%     use_spectrum  - use_spectrum{i}(j) is a logical value that is true if
%                     collections{i}.Y(:,j) should be included. 
%                     use_spectrum{i} should be a row vector.
% 
% =========================================================================
% The following are from the machine-generated documentation. I think they
% still hold, but, no guarantees.
%
%   SPECTRUM_INCLUSION_DIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%   function named CALLBACK in SPECTRUM_INCLUSION_DIALOG.M with the given input arguments.
%
%   SPECTRUM_INCLUSION_DIALOG('Property','Value',...) creates a new SPECTRUM_INCLUSION_DIALOG or raises the
%   existing singleton*.  Starting from the left, property value pairs are
%   applied to the GUI before spectrum_inclusion_dialog_OpeningFcn gets called.  An
%   unrecognized property name or invalid value makes property application
%   stop.  All inputs are passed to spectrum_inclusion_dialog_OpeningFcn via varargin.
%
%   *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%   instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spectrum_inclusion_dialog

% Last Modified by GUIDE v2.5 08-May-2012 13:58:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spectrum_inclusion_dialog_OpeningFcn, ...
                   'gui_OutputFcn',  @spectrum_inclusion_dialog_OutputFcn, ...
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


% --- Executes just before spectrum_inclusion_dialog is made visible.
function spectrum_inclusion_dialog_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spectrum_inclusion_dialog (see VARARGIN)

% Extract command-line arguments
handles.spectra = varargin{1}{1};
handles.use_spectrum = varargin{1}{2};

% Choose default command line output for spectrum_inclusion_dialog
handles.output = {hObject, true, handles.use_spectrum};


% Set the contents of the dropdown menus
field_names = spectrum_attributes(handles.spectra);
set(handles.field_name_popup,'String', field_names);
set(handles.field_name_popup,'Value', 1);
handles.field_values = ...
    values_for_spectrum_attribute(field_names{1}, handles.spectra);
set(handles.field_value_popup,'String', handles.field_values);

% Update handles structure
guidata(hObject, handles);
update_ui(handles);

% UIWAIT makes spectrum_inclusion_dialog wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = spectrum_inclusion_dialog_OutputFcn(hObject, eventdata, handles)  %#ok<INUSL>
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isstruct(handles)
    % Get command line output from handles structure
    varargout{1} = handles.output;
    delete(hObject);
else
    % The close button was pressed and the handles object is invalid
    varargout{1} = {hObject, true, 'Not valid, shouldn''t be using'};
    % No need to delete the object, it has already been deleted
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


function update_ui(handles)
% Update the user interface to reflect the underlying gui state
%
% handles    structure with handles and user data (see GUIDATA)

used_in_each_collection = cellfun(@(col) sum(col), handles.use_spectrum);
total_used = sum(used_in_each_collection);

total_spectra = sum(cellfun(@(col) length(col), handles.use_spectrum));

set(handles.num_selected_label, 'String', sprintf(...
    '%d of %d spectra selected', total_used, total_spectra));

function described = described_spectra(handles)
% Return spectra described by the dialog box text
%
% handles    structure with handles and user data (see GUIDATA)
%
% described  same format as use_spectrum described{i}(j) is true iff
%            handles.spectra{i}.Y(:,j) should be used
spectra = handles.spectra;

field_name = cellstr(get(handles.field_name_popup,'String'));
field_name = field_name{get(handles.field_name_popup,'Value')};

field_value = handles.field_values;
field_value = field_value{get(handles.field_value_popup,'Value')};

described = spectra_matching(spectra, field_name, field_value);

% --- Executes on button press in add_all_button.
function add_all_button_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
% hObject    handle to add_all_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i=1:length(handles.use_spectrum)
    handles.use_spectrum{i}=true(size(handles.use_spectrum{i}));
end
guidata(handles.figure1, handles);
update_ui(handles);


% --- Executes on button press in remove_all_button.
function remove_all_button_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
% hObject    handle to remove_all_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i=1:length(handles.use_spectrum)
    handles.use_spectrum{i}=false(size(handles.use_spectrum{i}));
end
guidata(handles.figure1, handles);
update_ui(handles);


% --- Executes on button press in add_button.
function add_button_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
% hObject    handle to add_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
described = described_spectra(handles);
for i=1:length(handles.use_spectrum)
    handles.use_spectrum{i}=handles.use_spectrum{i} | described{i};
end
guidata(handles.figure1, handles);
update_ui(handles);


% --- Executes on button press in remove_button.
function remove_button_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
% hObject    handle to remove_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
described = described_spectra(handles);
for i=1:length(handles.use_spectrum)
    handles.use_spectrum{i}=handles.use_spectrum{i} & ~described{i};
end
guidata(handles.figure1, handles);
update_ui(handles);


% --- Executes on selection change in field_name_popup.
function field_name_popup_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
% hObject    handle to field_name_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns field_name_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from field_name_popup
field_names = cellstr(get(hObject,'String'));
index = get(hObject,'Value');
set(handles.field_value_popup,'Value', 1);
handles.field_values = ...
    values_for_spectrum_attribute(field_names{index}, handles.spectra);
set(handles.field_value_popup,'String', handles.field_values);

guidata(handles.figure1, handles);

% --- Executes during object creation, after setting all properties.
function field_name_popup_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to field_name_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in field_value_popup.
function field_value_popup_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to field_value_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns field_value_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from field_value_popup


% --- Executes during object creation, after setting all properties.
function field_value_popup_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to field_value_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in done_button.
function done_button_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
% hObject    handle to done_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = {handles.figure1, false, handles.use_spectrum};
guidata(handles.figure1, handles);
uiresume(handles.figure1);


% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
% hObject    handle to cancel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = {handles.figure1, true, handles.use_spectrum};
guidata(handles.figure1, handles);
uiresume(handles.figure1);
