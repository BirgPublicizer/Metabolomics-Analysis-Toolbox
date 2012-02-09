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

% Last Modified by GUIDE v2.5 30-Jun-2011 13:49:38

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

addpath('../../common_scripts');

% Choose default command line output for main
handles.output = hObject;

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

set(handles.group_by_fields_listbox,'String',{'',sorted_valid_flds{:}});
set(handles.group_by_fields_listbox,'Max',length({'',sorted_valid_flds{:}}));

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

% Get the data
try
    collection = handles.collection;
catch ME
    msgbox('No collection loaded');
    return;
end
try
    group_by_inxs = handles.group_by_inxs;
    selected = get(handles.group_by_listbox,'Value');
    group_by_inxs = {group_by_inxs{selected}};
catch ME
    msgbox('Select groups');
    return;
end

num_samples = 0;
for i = 1:length(group_by_inxs)
    num_samples = num_samples + length(group_by_inxs{i});
end
[num_variables,total_num_samples] = size(collection.Y);
   
available_Y = NaN*ones(1,total_num_samples);
available_X = NaN*ones(num_variables,total_num_samples);
Y = [];%NaN*ones(1,num_samples);
X = [];%NaN*ones(num_variables,num_samples);
s = 0;
for g = 1:length(group_by_inxs)    
    for i = 1:length(group_by_inxs{g})
        inx_unpaired = group_by_inxs{g}(i);
        s = s + 1;
        X(:,s) = collection.Y(:,inx_unpaired);
        Y(s) = g;
    end
end
% Now grab all that is available
for g = 1:length(handles.group_by_inxs)
    for i = 1:length(handles.group_by_inxs{g})
        inx_unpaired = handles.group_by_inxs{g}(i);
        s = s + 1;
        available_X(:,inx_unpaired) = collection.Y(:,inx_unpaired);
        available_Y(inx_unpaired) = g;
    end
end

contents = get(handles.group_by_listbox,'String');
available_groups = get(handles.group_by_listbox,'String');
groups = {contents{get(handles.group_by_listbox,'Value')}};

%% Spectra plot
axes(handles.spectra_axes);
load('colors');
hs = [];
hold on
for g = 1:length(groups)
    inxs = find(Y == g);
    for i = 1:length(inxs)
        h = plot(collection.x,X(:,inxs(i)),...
            'Marker','none','Color',...
            colors{mod(g-1,length(colors))+1},...
            'MarkerFaceColor',colors{mod(g-1,length(colors))+1});
        if i == 1
            hs(end+1) = h;
        end
    end
end
hold off
set(gca,'xdir','reverse');
legend(hs,groups,'Location','Best');
xlabel('x (ppm)','Interpreter','tex');
ylabel('Intensity','Interpreter','tex');

% Save a few things for later
data = {};
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
handles.available_Y = available_Y';
handles.available_X = available_X';
handles.available_groups = available_groups;
handles.X = X';
handles.Y = Y';

msgbox('Finished');

% Update handles structure
guidata(hObject, handles);

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

try
    collection = handles.collection;
catch ME
    msgbox('No collection loaded');
    return;
end

figure;
rows = str2num(get(handles.scores_rows_edit,'String'));
columns = str2num(get(handles.scores_columns_edit,'String'));
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
        subplot_inx = str2num(subplot_inxs{z});
        subplot(rows,columns,subplot_inx);
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
                h = plot(collection.x,handles.available_X(inxs(i),:),...
                    'Marker',data{d,4},'Color',data{d,3},...
                    'MarkerFaceColor',data{d,3});
                myfunc = @(hObject, eventdata, handles) (line_click_info(collection,inxs(i)));
                set(h,'ButtonDownFcn',myfunc);                
                if i == 1
                    h_groups{subplot_inx}(end+1) = h;
                end
            end                                
        else
            for i = 1:length(inxs)
                h = plot(collection.x,handles.available_X(inxs(i),:),...
                    'Marker',data{d,4},'Color',data{d,3});
                myfunc = @(hObject, eventdata, handles) (line_click_info(collection,inxs(i)));
                set(h,'ButtonDownFcn',myfunc);                
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
% xlim_values = [];
% ylim_values = [];
% xlim_str = get(handles.xlim_edit,'String');
% ylim_str = get(handles.ylim_edit,'String');
% if ~isempty(xlim_str)
%     xlim_fields = split(xlim_str,',');
%     xlim_values = [str2num(xlim_fields{1}),str2num(xlim_fields{2})];
% end
% if ~isempty(ylim_str)
%     ylim_fields = split(ylim_str,',');
%     ylim_values = [str2num(ylim_fields{1}),str2num(ylim_fields{2})];
% end
i = 1;
for r = 1:rows
    for c = 1:columns
        subplot(rows,columns,i);
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
%         if ~isempty(xlim_values)
%             xlim(xlim_values);
%         end
%         if ~isempty(xlim_values)
%             xlim(xlim_values);
%         end
%         if ~isempty(ylim_values)
%             ylim(ylim_values);            
%         end
    end
end


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

% --- Executes on button press in load_loadings_pushbutton.
function load_loadings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to load_loadings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    [filename, pathname] = uigetfile('*.csv', 'Pick an OPLS loadings file');
    [NUMERIC,TXT,RAW] = xlsread([pathname,filename]);
    x_inx = find(strcmp({TXT{1,:}},'x'));
    p_inx = find(strcmp({TXT{1,:}},'P'));
    s_inx = find(strcmp({TXT{1,:}},'Significant?'));
    x = NUMERIC(:,x_inx);
    p = NUMERIC(:,p_inx);
    s = NUMERIC(:,s_inx);
    [vs,inxs] = sort(abs(p),'descend');
    % Sort by the absolute value of p by default    
    data = {};
    for j = 1:length(inxs)
        i = inxs(j);
        data{j,1} = x(i);
    end
    for j = 1:length(inxs)
        i = inxs(j);
        data{j,2} = p(i);
        data{j,3} = abs(p(i));
    end
    for j = 1:length(inxs)
        i = inxs(j);
        if s(i) == 1
            data{j,4} = 'Y';
        else
            data{j,4} = 'N';
        end
    end
    % Left and right bin
    for j = 1:length(inxs)
        i = inxs(j);
        data{j,5} = NaN;
        data{j,6} = NaN;
    end
    set(handles.loadings_uitable,'data',data);
    set(handles.loadings_uitable,'ColumnName',{'x (ppm)','P','abs(P)','Sig?','Left (ppm)','Right (ppm)'});
catch ME
    msgbox('Invalid loadings');
    throw(ME);
end


% --- Executes on button press in load_bins_pushbutton.
function load_bins_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to load_bins_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.txt', 'Pick a bin file');
fid = fopen([pathname,filename],'r');
line = fgetl(fid);
fclose(fid);
data = get(handles.loadings_uitable,'data');
centers = cell2mat({data{:,1}});
fields = split(line,';');
max_error_match = 0.001; % ppm
for i = 1:length(fields)
    left_right = split(fields{i},',');
    left = str2num(left_right{1});
    right = str2num(left_right{2});
    center = (left+right)/2;
    matched = false;
    for j = 1:length(centers)
        if abs(center-centers(j)) < max_error_match
            data{j,5} = left;
            data{j,6} = right;
            matched = true;
            break;
        end
    end
    if ~matched
        fprintf('%f not matched\n',center);
    end
end
set(handles.loadings_uitable,'data',data);



% --- Executes when selected cell(s) is changed in loadings_uitable.
function loadings_uitable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to loadings_uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(eventdata.Indices)
    data = get(handles.loadings_uitable,'data');
    row_inx = eventdata.Indices(1,1);
    handles.xlim = [data{row_inx,6},data{row_inx,5}];
    guidata(hObject, handles);

    xlim(handles.xlim);
end


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


function res = get_version_string()
res = '0r1';

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

group_by_fields_listbox(hObject,handles);

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
