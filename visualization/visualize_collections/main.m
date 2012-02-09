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

% Last Modified by GUIDE v2.5 11-May-2011 14:20:23

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

% Choose default command line output for main
handles.output = hObject;

set(handles.summary_text,'String',{''});

set(handles.version_text,'String',get_version_string());

% myfunc = @(hObject, eventdata, handles_) (key_press(handles));
% set(gcf,'KeyPressFcn',myfunc);

set(handles.collection_uipanel,'Visible','on');
set(handles.results_uipanel,'Visible','off');

data = cell(1,1);
data{1} = '';
set(handles.bins_listbox,'String',data);


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

function populate_listboxes(handles)
flds = fields(handles.collection);
valid_flds = {};
for i = 1:length(flds)
    [rows,cols] = size(handles.collection.(flds{i}));
    if rows == 1 && cols == handles.collection.num_samples && ~strcmp(flds{i},'X') && ~strcmp(flds{i},'Y')
        valid_flds{end+1} = flds{i};
    end
end
sorted_valid_flds = sort(valid_flds);

set(handles.group_by_fields_listbox,'String',{'',sorted_valid_flds{:}});
set(handles.group_by_fields_listbox,'Max',length({'',sorted_valid_flds{:}}));

% --- Executes on button press in get_collection_button.
function get_collection_button_Callback(hObject, eventdata, handles)
% hObject    handle to get_collection_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = get_collections_pushbutton(handles);

populate_listboxes(handles);

ymax = max(handles.collection.Y{1});
ymin = min(handles.collection.Y{1});
handles.ymax = ymax;
handles.ymin = ymin;
set(handles.y_zoom_edit,'String',sprintf('%f',(ymax-ymin)*.01));

msgbox('Finished loading collections');

% Update handles structure
guidata(hObject, handles);

function add_line_to_summary_text(h,line)
current = get(h,'String');
current = {line,current{:}};
set(h,'String',current);


function scores_columns_edit_Callback(hObject, eventdata, handles)
% hObject    handle to scores_columns_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scores_columns_edit as text
%        str2double(get(hObject,'String')) returns contents of scores_columns_edit as a double


% --- Executes during object creation, after setting all properties.
function scores_columns_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scores_columns_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scores_rows_edit_Callback(hObject, eventdata, handles)
% hObject    handle to scores_rows_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scores_rows_edit as text
%        str2double(get(hObject,'String')) returns contents of scores_rows_edit as a double


% --- Executes during object creation, after setting all properties.
function scores_rows_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scores_rows_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_pushbutton.
function plot_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to plot_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

figure;
plot_spectra(handles,false);

function plot_spectra(handles,disable_subplot_feature)

try
    collection = handles.collection;
catch ME
    msgbox('No collections loaded');
    throw(ME);
end

h = findobj(gcf,'tag','spectrum_line');
delete(h);

rows = str2num(get(handles.scores_rows_edit,'String'));
columns = str2num(get(handles.scores_columns_edit,'String'));
if disable_subplot_feature
    rows = 1;
    columns = 1;
end
data = get(handles.scores_uitable,'data');
legends = {};
h_groups = {};
hide_legends = {};
group_inxs = {};
d = 0;
for g = 1:length(handles.group_by_inxs)
    inxs = find(handles.available_Y == g);
    if isempty(inxs)
        continue;
    end
    d = d + 1;
    group_inxs{end+1} = handles.group_by_inxs{g};
    if ~data{d,7} % Don't include
        continue;
    end
    
    subplot_inxs = split(data{d,2},',');
    for z = 1:length(subplot_inxs)
        if disable_subplot_feature
            subplot_inx = 1;
        else
            subplot_inx = str2num(subplot_inxs{z});
            subplot(rows,columns,subplot_inx);
        end
        if subplot_inx > length(legends)
            legends{subplot_inx} = {};
            h_groups{subplot_inx} = [];
            hide_legends{subplot_inx} = [];
        end
        legends{subplot_inx}{end+1} = data{d,6};
        hide_legends{subplot_inx}(end+1) = data{d,8};
        hold on
        fill = data{d,5};        
        if fill
            for i = 1:length(inxs)
                h = plot(collection.X{inxs(i)},handles.available_X{inxs(i)},...
                    'Marker',data{d,4},'Color',data{d,3},...
                    'MarkerFaceColor',data{d,3},'tag','spectrum_line');
%                 myfunc = @(hObject, eventdata, handles_) (line_click_info(collection,inxs(i)));
                setappdata(h,'inx',inxs(i));
                set(h,'ButtonDownFcn',@line_click_info_myfunc);
                if i == 1
                    h_groups{subplot_inx}(end+1) = h;
                end
            end                                
        else
            for i = 1:length(inxs)
                h = plot(collection.X{inxs(i)},handles.available_X{inxs(i)},...
                    'Marker',data{d,4},'Color',data{d,3},'tag','spectrum_line');
                setappdata(h,'inx',inxs(i));
%                 myfunc = @(hObject, eventdata, handles_) (line_click_info(collection,inxs(i)));
                set(h,'ButtonDownFcn',@line_click_info_myfunc);
                if i == 1
                    h_groups{subplot_inx}(end+1) = h;
                end
            end
        end
        hold off
    end
end
for i = 1:rows*columns
    if length(legends) < i
        legends{i} = {};
        h_groups{i} = [];
        hide_legends{i} = [];
    end
end

% Go through subplots and fix legends
i = 1;
for r = 1:rows
    for c = 1:columns
        if ~disable_subplot_feature
            subplot(rows,columns,i);
        end
        set(gca,'xdir','reverse');
        selected_legends = {};
        selected_h_groups = [];
        for j = 1:length(legends{i})
            if ~hide_legends{i}(j)
                selected_legends{end+1} = legends{i}{j};
                selected_h_groups(end+1) = h_groups{i}(j);
            end
        end
        if ~isempty(selected_legends)
            [vs,inxs] = sort(selected_legends);
            legend(selected_h_groups(inxs),{selected_legends{inxs}});
        end
        i = i + 1;
        if c == 1
            ylabel('Intensity','Interpreter','tex');
        end
        if r == rows
            xlabel('Chemical shift (ppm)','Interpreter','tex');
        end
        if isfield(handles,'xlim')
            xlim(handles.xlim);
        end
    end
end

function line_click_info_myfunc(hObject,eventdata)
inx = getappdata(hObject,'inx');
handles = guidata(hObject);
line_click_info(handles.collection,inx);

function xlim_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xlim_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlim_edit as text
%        str2double(get(hObject,'String')) returns contents of xlim_edit as a double


% --- Executes during object creation, after setting all properties.
function xlim_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlim_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ylim_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ylim_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ylim_edit as text
%        str2double(get(hObject,'String')) returns contents of ylim_edit as a double


% --- Executes during object creation, after setting all properties.
function ylim_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylim_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_collection_pushbutton.
function load_collection_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to load_collection_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = load_collections_pushbutton(handles);

populate_listboxes(handles);

ymax = max(handles.collection.Y{1});
ymin = min(handles.collection.Y{1});
handles.ymax = ymax;
handles.ymin = ymin;
set(handles.y_zoom_edit,'String',sprintf('%f',(ymax-ymin)*.01));

msgbox('Finished loading collections');

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in load_bins_pushbutton.
function load_bins_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to load_bins_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

[filename,pathname] = uigetfile('*.txt', 'Load regions');
file = fopen([pathname,filename],'r');
myline = fgetl(file);
regions = split(myline,';');
lefts = [];
rights = [];
for i = 1:length(regions)
    region = regions{i};
    fields = split(region,',');
    lefts(end+1) = str2num(fields{1});
    rights(end+1) = str2num(fields{2});
end
regions = zeros(length(lefts),2);
regions(:,1) = lefts';
regions(:,2) = rights';

data = cell(size(regions,1)+1,1);
data{1} = '';
for b = 1:size(regions,1)
    data{b+1} = sprintf('%f,%f',regions(b,1),regions(b,2));
end

set(handles.bins_listbox,'String',data);
set(handles.bins_listbox,'Value',1);

xlim auto;
ylim auto;

% --- Executes on button press in sort_pushbutton.
function sort_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to sort_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

sort_bins(handles);

function sort_bins(handles)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

bins = get_bins(handles);
bins = sortrows(bins,1);

data = cell(size(bins,1)+1,1);
for b = 1:size(bins,1)
    data{b} = sprintf('%f,%f',bins(b,1),bins(b,2));
end
data{end} = '';

set(handles.bins_listbox,'String',data(end:-1:1));
set(handles.bins_listbox,'Value',1);

% xlim auto;
% ylim auto;

guidata(handles.figure1, handles);

% --- Executes on button press in zoom_out_pushbutton.
function zoom_out_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_out_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

xlim auto;
ylim auto;


% --- Executes on button press in save_figure_pushbutton.
function save_figure_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_figure_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

[filename,pathname] = uiputfile('*.fig', 'Save figure');
try
    if strcmp(filename,'main.fig')
        msgbox('Cannot overwrite main.fig. Pick another name and another directory.');
        return;
    end
    saveas(handles.figure1,[pathname,filename]);
catch ME
    throw(ME);
end

function delete_cursors()
h = findobj(gcf,'tag','right_cursor');
delete(h);
h = findobj(gcf,'tag','left_cursor');
delete(h);

% --- Executes on button press in x_zoom_out_pushbutton.
function x_zoom_out_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to x_zoom_out_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

buf = str2num(get(handles.x_zoom_edit,'String'));
xl = xlim;
xlim([xl(1)-buf,xl(2)+buf]);
% ylim auto;

% --- Executes on button press in x_zoom_in_pushbutton.
function x_zoom_in_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to x_zoom_in_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

buf = str2num(get(handles.x_zoom_edit,'String'));
xl = xlim;
xlim([xl(1)+buf,xl(2)-buf]);
% ylim auto;

function x_zoom_edit_Callback(hObject, eventdata, handles)
% hObject    handle to x_zoom_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_zoom_edit as text
%        str2double(get(hObject,'String')) returns contents of x_zoom_edit as a double


% --- Executes during object creation, after setting all properties.
function x_zoom_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_zoom_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in bins_listbox.
function bins_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to bins_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bins_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bins_listbox
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

delete_cursors;

contents = cellstr(get(hObject,'String'));
bin_inx = get(hObject,'Value')-1;
bin_str = contents{bin_inx+1};
if strcmp(bin_str,'');
    xlim auto;
    ylim auto;
    return;
end

fields = split(bin_str,',');
bin = [str2num(fields{1}),str2num(fields{2})];
inverted_bin = false;
buf = str2num(get(handles.x_zoom_edit,'String'));
if bin(1) < bin(2)
    inverted_bin = true;
    handles.xlim = [bin(1)-buf,bin(2)+buf];
else
    handles.xlim = [bin(2)-buf,bin(1)+buf];
end

if get(handles.lock_window_checkbox,'Value')
    x_range = handles.x_range;
    current_x_range = handles.xlim(2) - handles.xlim(1);
    diff = x_range - current_x_range;
    handles.xlim = [handles.xlim(1)-diff/2,handles.xlim(2)+diff/2];
end

xlim(handles.xlim);
ylim auto;
    
yl = ylim;
bins = get_bins(handles);
for b = 1:size(bins,1)
    color = 'm';
    if mod(b-1,2) == 0
        color = 'b';
    end
    right_cursor = create_cursor(bins(b,2),[handles.ymin,handles.ymax],color);
%     if b == bin_inx
    set(right_cursor,'LineWidth',3);
    set(right_cursor,'LineStyle','--');
%     end
    set(right_cursor,'tag','right_cursor');
    left_cursor = create_cursor(bins(b,1),[handles.ymin,handles.ymax],color);
%     if b == bin_inx
    set(left_cursor,'LineWidth',3);
%     end
    set(left_cursor,'tag','left_cursor');           
end

if inverted_bin
    msgbox(sprintf('Inverted bin: %f,%f',bin(1),bin(2)));    
end

ylim(yl);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function bins_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bins_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in debug_pushbutton.
function debug_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to debug_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

add_line_to_summary_text(handles.summary_text,'Debugging...');
bins = get_bins(handles);
for b = 1:size(bins,1)
    if bins(b,1) < bins(b,2)
        add_line_to_summary_text(handles.summary_text,sprintf('Inverted bin boundaries: %f,%f',bins(b,1),bins(b,2)));
    end
end
add_line_to_summary_text(handles.summary_text,'Finished debugging');

% --- Executes on button press in y_zoom_out_pushbutton.
function y_zoom_out_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to y_zoom_out_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

buf = str2num(get(handles.y_zoom_edit,'String'));
yl = ylim;
ylim([yl(1),yl(2)+buf]);

% --- Executes on button press in y_zoom_in_pushbutton.
function y_zoom_in_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to y_zoom_in_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

buf = str2num(get(handles.y_zoom_edit,'String'));
yl = ylim;
ylim([yl(1),yl(2)-buf]);

function y_zoom_edit_Callback(hObject, eventdata, handles)
% hObject    handle to y_zoom_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_zoom_edit as text
%        str2double(get(hObject,'String')) returns contents of y_zoom_edit as a double


% --- Executes during object creation, after setting all properties.
function y_zoom_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_zoom_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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


% --- Executes on button press in results_pushbutton.
function results_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to results_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

set(handles.collection_uipanel,'Visible','off');
set(handles.results_uipanel,'Visible','on');

% --- Executes on button press in collection_pushbutton.
function collection_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to collection_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

set(handles.collection_uipanel,'Visible','on');
set(handles.results_uipanel,'Visible','off');

% --- Executes on button press in update_plot_pushbutton.
function update_plot_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to update_plot_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

% Now update plot
axes(handles.spectra_axes);
plot_spectra(handles,true);



% --- Executes on button press in lock_window_checkbox.
function lock_window_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to lock_window_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lock_window_checkbox
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

xl = xlim;
handles.x_range = xl(2)-xl(1);

guidata(hObject, handles);


% --- Executes on button press in left_pushbutton.
function left_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to left_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

xlim1 = xlim;
xdist = str2num(get(handles.x_zoom_edit,'String'));
xlim([xlim1(1)+xdist,xlim1(2)+xdist]); 
    
% --- Executes on button press in right_pushbutton.
function right_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to right_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

xlim1 = xlim;
xdist = str2num(get(handles.x_zoom_edit,'String'));
xlim([xlim1(1)-xdist,xlim1(2)-xdist]);        


% --- Executes on button press in open_figure_pushbutton.
function open_figure_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to open_figure_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname] = uigetfile('*.fig', 'Open figure');
open([pathname,filename]);


% --- Executes on button press in about_pushbutton.
function about_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to about_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web('about.html'); 


% --- Executes on selection change in group_by_fields_listbox.
function group_by_fields_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to group_by_fields_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns group_by_fields_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from group_by_fields_listbox
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

handles = group_by_fields_listbox(hObject,handles);

update_spectra_plot(handles);

% --- Executes during object creation, after setting all properties.
function group_by_fields_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to group_by_fields_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in group_by_listbox.
function group_by_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to group_by_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns group_by_listbox contents as cell array
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

function update_spectra_plot(handles)
if ~isfield(handles,'collection')
    msgbox('No collection loaded');
    return;
end

[X,Y,available_X,available_Y] = get_run_data(handles.figure1,handles);
handles.available_X = available_X';
handles.available_Y = available_Y';

% Save a few things for later
available_groups = get(handles.group_by_listbox,'String');
data = {};
load('colors');
for g = 1:length(handles.group_by_inxs)
    if ~isempty(find(available_Y == g)) % Make sure we have data
        data{end+1,1} = available_groups{g}; % Group
        data{end,2} = '1'; % Subplot
        data{end,3} = colors{mod(g-1,length(colors)-2)+1}; % -2 because the last two colors are vectors
        data{end,4} = 'none';
        data{end,5} = true; % Fill
        data{end,6} = available_groups{g}; % Legend
        data{end,7} = true; % Include
        data{end,8} = false;% Hide Legend
    end
end
set(handles.scores_uitable,'data',data);
handles.available_groups = available_groups;

% Now update plot
axes(handles.spectra_axes);
plot_spectra(handles,true);

% Update handles structure
guidata(handles.figure1, handles);
