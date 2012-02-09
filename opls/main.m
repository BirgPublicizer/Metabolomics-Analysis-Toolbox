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

% Last Modified by GUIDE v2.5 17-May-2011 15:08:23

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


% % --- Executes on button press in group_by_classification_pushbutton.
% function group_by_classification_pushbutton_Callback(hObject, eventdata, handles)
% % hObject    handle to group_by_classification_pushbutton (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [result,message] = validate_state(handles,get_version_string());
% if ~result
%     msgbox(message);
%     return;
% end
% 
% group_by_classification_pushbutton(hObject,handles);
% 
% % --- Executes on button press in group_by_time_and_classification_pushbutton.
% function group_by_time_and_classification_pushbutton_Callback(hObject, eventdata, handles)
% % hObject    handle to group_by_time_and_classification_pushbutton (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [result,message] = validate_state(handles,get_version_string());
% if ~result
%     msgbox(message);
%     return;
% end
% 
% group_by_time_and_classification_pushbutton(hObject,handles);
% 
% % --- Executes on button press in paired_by_time_pushbutton.
% function paired_by_time_pushbutton_Callback(hObject, eventdata, handles)
% % hObject    handle to paired_by_time_pushbutton (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [result,message] = validate_state(handles,get_version_string());
% if ~result
%     msgbox(message);
%     return;
% end
% 
% paired_by_time_pushbutton(hObject,handles);
% 
% % --- Executes on button press in paired_by_classification_pushbutton.
% function paired_by_classification_pushbutton_Callback(hObject, eventdata, handles)
% % hObject    handle to paired_by_classification_pushbutton (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [result,message] = validate_state(handles,get_version_string());
% if ~result
%     msgbox(message);
%     return;
% end
% 
% paired_by_classification_pushbutton(hObject,handles);
% 
% % --- Executes on button press in paired_by_time_and_classification_pushbutton.
% function paired_by_time_and_classification_pushbutton_Callback(hObject, eventdata, handles)
% % hObject    handle to paired_by_time_and_classification_pushbutton (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [result,message] = validate_state(handles,get_version_string());
% if ~result
%     msgbox(message);
%     return;
% end
% 
% paired_by_time_and_classification_pushbutton(hObject,handles);

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

[X,Y,available_X,available_Y,G,available_G] = get_run_data(hObject,handles);

try
    num_permutations = str2num(get(handles.num_permutations_edit,'String'));
    if num_permutations < 30
        error('Invalid number of permutations');
    end
catch ME
    msgbox('Enter a valid number of permutations (>= 30)');
    return;
end

try
    test_alpha = str2num(get(handles.test_alpha_edit,'String'));
    if test_alpha < 0 || test_alpha > 1
        error('Invalid test alpha');
    end
catch ME
    msgbox('Enter a valid test alpha');
    return;
end

CV = str2num(get(handles.cv_edit,'String'));
if isempty(CV)
    CV_str = get(handles.cv_edit,'String');
    fields = split(CV_str,'x');
    num_times = str2num(fields{end});
    fields = split(fields{1},'-');
    st = str2num(fields{1});
    en = str2num(fields{2});
    CV = [st,en,num_times];
end

if isempty(CV)
    msgbox('Enter a valid CV');
    return;
end

%% Run OPLS
if std(Y) == 0
    msgbox('Please selected more than one entry from model by');
    return;
end
[handles.model,handles.stats] = run_opls(X',Y',num_permutations,CV);
if handles.model.num_OPLS_fact == 0
    handles.model.t_ortho = handles.model.t*0;
end
contents = get(handles.model_by_listbox,'String');
available_groups = get(handles.group_by_listbox,'String');
groups = {contents{get(handles.model_by_listbox,'Value')}};
if get(handles.groups_checkbox,'Value')
    add_line_to_summary_text(handles.summary_text,sprintf('Groups: %s',join(groups,'  ')));
end
contents = get(handles.paired_by_listbox,'String');
if ~isempty(contents)
    paired_by = contents{get(handles.paired_by_listbox,'Value')};
else
    paired_by = [];
end
if ~isempty(paired_by)
    add_line_to_summary_text(handles.summary_text,sprintf('Paired by: %s',paired_by));
end
add_line_to_summary_text(handles.summary_text,sprintf('# OPLS factors removed: %d',handles.model.num_OPLS_fact));
add_line_to_summary_text(handles.summary_text,sprintf('R^2_X: %.4f',handles.stats.R2_X));
add_line_to_summary_text(handles.summary_text,sprintf('R^2_Y: %.4f',handles.stats.R2_Y));
add_line_to_summary_text(handles.summary_text,sprintf('Q^2: %.4f',handles.stats.Q2));
sorted = sort(handles.stats.permutation_Q2s,'descend');
ix = max([1,round(length(handles.stats.permutation_Q2s)*test_alpha)]); % One tailed
thres = sorted(ix);
add_line_to_summary_text(handles.summary_text,sprintf('Q^2 Sig. Threshold: %.4f',thres));
if get(handles.groups_checkbox,'Value')
    add_line_to_summary_text(handles.summary_text,sprintf('Accuracy: %.4f%',100*handles.stats.accuracy));
end

%% Now determine the sig. variables
sig_vars_num_permutations = str2num(get(handles.sig_vars_num_permutations_edit,'String'));
sig_vars_talpha = str2num(get(handles.sig_vars_talpha_edit,'String'));
sig_vars_inner_num_permutations = str2num(get(handles.sig_vars_inner_num_permutations_edit,'String'));
sig_vars_inner_talpha = str2num(get(handles.sig_vars_inner_talpha_edit,'String'));
[handles.sig_inxs,handles.not_sig_inxs,handles.significant,handles.p_permuted] = determine_significant_features(X',Y',handles.model,...
    sig_vars_num_permutations,sig_vars_talpha,sig_vars_inner_num_permutations,sig_vars_inner_talpha);
set(handles.sig_vars_listbox,'String',{'',handles.collection.x(handles.sig_inxs)});
set(handles.sig_vars_listbox,'Value',1);
set(handles.not_sig_vars_listbox,'String',{'',handles.collection.x(handles.not_sig_inxs)});
set(handles.not_sig_vars_listbox,'Value',1);
add_line_to_summary_text(handles.summary_text,sprintf('Sig. vars. # permutations: %d',sig_vars_num_permutations));
add_line_to_summary_text(handles.summary_text,sprintf('Sig. vars. test alpha: %.4f',sig_vars_talpha));

%% Scores plot
axes(handles.scores_axes);
load('colors');
markers = {'o','s','d','v','^','<','>'};
hold on
for g = 1:length(groups)
    inxs = find(G == g);
    plot(handles.model.t(inxs),handles.model.t_ortho(inxs,1),...
        'Marker',markers{mod(g-1,length(markers))+1},'Color',...
        colors{mod(g-1,length(colors))+1},'LineStyle','none',...
        'MarkerFaceColor',colors{mod(g-1,length(colors))+1});
end
hold off
if get(handles.groups_checkbox,'Value')
    legend(groups,'Location','Best');
end
xlabel('T','Interpreter','tex');
ylabel('T_{orthogonal}','Interpreter','tex');

%% Loadings plot
axes(handles.loadings_axes);
[vs,inxs] = sort(abs(handles.model.p),'descend');
h = bar(handles.model.p(inxs));
set(h,'EdgeColor','k');
set(h,'FaceColor','k');
ylabel('Loading','Interpreter','tex');
set(gca,'XTickLabel',{});
xlabel('Variable');

% Save a few things for later
data = {};
for g = 1:length(handles.group_by_inxs)
    if ~isempty(find(available_G == g)) % Make sure we have data
        data{end+1,1} = available_groups{g}; % Group
        data{end,2} = '1'; % Subplot
        data{end,3} = colors{mod(g-1,length(colors)-2)+1}; % -2 because the last two colors are vectors
        data{end,4} = markers{mod(g-1,length(markers))+1};
        data{end,5} = true; % Fill
        data{end,6} = available_groups{g}; % Legend
        data{end,7} = true; % Include
        data{end,8} = false;% Hide Legend
    end
end
set(handles.scores_uitable,'data',data);
handles.available_Y = available_Y';
handles.available_X = available_X';
handles.available_G = available_G';
handles.available_groups = available_groups;
handles.G = G';
handles.X = X';
handles.Y = Y';

%% Q2 distribution plot
axes(handles.q2_distribution_axes);
[f,xi] = ksdensity(handles.stats.permutation_Q2s);
plot(xi,f,'k-');
xlabel('Q2');
ylabel('Probability Density Estimate');
% [n,xi] = hist(handles.p_permuted{v},50);
% bar(xi,n/sum(n));
yl = ylim;
arrow([handles.stats.Q2,yl(2)/4],[handles.stats.Q2,0]);

handles.run_groups_checkbox = get(handles.groups_checkbox,'Value');

msgbox('Finished running OPLS');

% Update handles structure
guidata(hObject, handles);

function add_line_to_summary_text(h,line)
current = get(h,'String');
current = {line,current{:}};
set(h,'String',current);

function cv_edit_Callback(hObject, eventdata, handles)
% hObject    handle to cv_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cv_edit as text
%        str2double(get(hObject,'String')) returns contents of cv_edit as a double


% --- Executes during object creation, after setting all properties.
function cv_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cv_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function test_alpha_edit_Callback(hObject, eventdata, handles)
% hObject    handle to test_alpha_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of test_alpha_edit as text
%        str2double(get(hObject,'String')) returns contents of test_alpha_edit as a double


% --- Executes during object creation, after setting all properties.
function test_alpha_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test_alpha_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_permutations_edit_Callback(hObject, eventdata, handles)
% hObject    handle to num_permutations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_permutations_edit as text
%        str2double(get(hObject,'String')) returns contents of num_permutations_edit as a double


% --- Executes during object creation, after setting all properties.
function num_permutations_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_permutations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in results_listbox.
function results_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to results_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns results_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from results_listbox

contents = get(hObject,'String');
selected = contents(get(hObject,'Value'));
if strcmp(selected,'Scores')
    set(handles.scores_uipanel,'Visible','on');
    set(handles.loadings_uipanel,'Visible','off');
    set(handles.sig_vars_uipanel,'Visible','off');
    set(handles.q2_distribution_uipanel,'Visible','off');
elseif strcmp(selected,'Loadings')
    set(handles.scores_uipanel,'Visible','off');
    set(handles.loadings_uipanel,'Visible','on');
    set(handles.sig_vars_uipanel,'Visible','off');
    set(handles.q2_distribution_uipanel,'Visible','off');
elseif strcmp(selected,'Sig. vars.')
    set(handles.scores_uipanel,'Visible','off');
    set(handles.loadings_uipanel,'Visible','off');
    set(handles.sig_vars_uipanel,'Visible','on');
    set(handles.q2_distribution_uipanel,'Visible','off');
elseif strcmp(selected,'Q2 Distribution')
    set(handles.scores_uipanel,'Visible','off');
    set(handles.loadings_uipanel,'Visible','off');
    set(handles.sig_vars_uipanel,'Visible','off');
    set(handles.q2_distribution_uipanel,'Visible','on');
elseif strcmp(selected,'Error')
    set(handles.scores_uipanel,'Visible','off');
    set(handles.loadings_uipanel,'Visible','off');
    set(handles.sig_vars_uipanel,'Visible','off');
    set(handles.q2_distribution_uipanel,'Visible','off');
end

% --- Executes during object creation, after setting all properties.
function results_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to results_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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

[t,t_ortho,Y_pred] = apply_opls_model(handles.X,handles.Y,handles.model,handles.available_X);
if isempty(t_ortho)
    t_ortho = t*0;
end

contents = get(handles.scores_type_popupmenu,'String');
scores_type = contents{get(handles.scores_type_popupmenu,'Value')};

graph_Xs = {{t}};
graph_Ys = {{t_ortho}};
ylabels = {'T_{orthogonal}'};
xlabels = {'T'};
if ~handles.run_groups_checkbox
    graph_Xs{end+1} = {handles.available_Y};
    graph_Ys{end+1} = {Y_pred};
    xlabels{end+1} = 'Observed';
    ylabels{end+1} = 'Predicted';
end
for gi = 1:length(graph_Xs)
    figure;
    graph_X = graph_Xs{gi}{1};
    graph_Y = graph_Ys{gi}{1};
    
    rows = str2num(get(handles.scores_rows_edit,'String'));
    columns = str2num(get(handles.scores_columns_edit,'String'));
    data = get(handles.scores_uitable,'data');
    legends = {};
    h_groups = {};
    hide_legends = {};
    group_inxs = {};
    d = 0;
    for g = 1:length(handles.group_by_inxs)
        inxs = find(handles.available_G == g);
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
            if strcmp(scores_type,'Scatter')
                if fill
                    h_groups{subplot_inx}(end+1) = plot(graph_X(inxs),graph_Y(inxs,1),...
                        'Marker',data{d,4},'Color',...
                        data{d,3},'LineStyle','none',...
                        'MarkerFaceColor',data{d,3});
                else
                    h_groups{subplot_inx}(end+1) = plot(graph_X(inxs),graph_Y(inxs,1),...
                        'Marker',data{d,4},'Color',...
                        data{d,3},'LineStyle','none');
                end
                if get(handles.ids_radiobutton,'Value')
                    for i = 1:length(inxs)
                        subject_id = get_field(handles.collection,'subject_id',inxs(i));
                        text(graph_X(inxs(i)),graph_Y(inxs(i),1),num2str(subject_id),'VerticalAlignment','top');
                    end
                end
            else
                if fill
                    h_groups{subplot_inx}(end+1) = plot(mean(graph_X(inxs)),mean(graph_Y(inxs,1)),...
                        'Marker',data{d,4},'Color',...
                        data{d,3},'LineStyle','none',...
                        'MarkerFaceColor',data{d,3});
                else
                    h_groups{subplot_inx}(end+1) = plot(mean(graph_X(inxs)),mean(graph_Y(inxs,1)),...
                        'Marker',data{d,4},'Color',...
                        data{d,3},'LineStyle','none');
                end
                if strcmp(scores_type,'1 Standard error')
                    stderr_t = std(graph_X(inxs))/sqrt(length(inxs));
                    stderr_t_ortho = std(graph_Y(inxs,1))/sqrt(length(inxs));
                elseif strcmp(scores_type,'95% CI')
                    stderr_t = 1.96*std(graph_X(inxs))/sqrt(length(inxs));
                    stderr_t_ortho = 1.96*std(graph_Y(inxs,1))/sqrt(length(inxs));
                elseif strcmp(scores_type,'1 Standard deviation')
                    stderr_t = std(graph_X(inxs));
                    stderr_t_ortho = std(graph_Y(inxs,1));
                elseif strcmp(scores_type,'2 Standard deviations')
                    stderr_t = 2*std(graph_X(inxs));
                    stderr_t_ortho = 2*std(graph_Y(inxs,1));
                end
                if stderr_t > 0 && stderr_t_ortho > 0
                    rectangle('Position',[mean(graph_X(inxs))-stderr_t,mean(graph_Y(inxs,1))-stderr_t_ortho,2*stderr_t,2*stderr_t_ortho],'Curvature',[1,1],'EdgeColor',data{d,3});
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
    xlim_values = [];
    ylim_values = [];
    xlim_str = get(handles.xlim_edit,'String');
    ylim_str = get(handles.ylim_edit,'String');
    if ~isempty(xlim_str)
        xlim_fields = split(xlim_str,',');
        xlim_values = [str2num(xlim_fields{1}),str2num(xlim_fields{2})];
    end
    if ~isempty(ylim_str)
        ylim_fields = split(ylim_str,',');
        ylim_values = [str2num(ylim_fields{1}),str2num(ylim_fields{2})];
    end
    i = 1;
    axs = [];
    for r = 1:rows
        for c = 1:columns
            axs(end+1) = subplot(rows,columns,i);
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
                ylabel(ylabels{gi},'Interpreter','tex');
            end
            if r == rows
                xlabel(xlabels{gi},'Interpreter','tex');
            end
            if ~isempty(xlim_values)
                xlim(xlim_values);
            end
            if ~isempty(xlim_values)
                xlim(xlim_values);
            end
            if ~isempty(ylim_values)
                ylim(ylim_values);            
            end
        end
    end
    if get(handles.linkaxes_radiobutton,'Value')
        linkaxes(axs);
    end
end

if get(handles.dendrogram_radiobutton,'Value')
    all_legends = {data{:,6}};
    % figure out why there are so many exactly the same
    create_dendrogram_and_boxplot(all_legends,group_inxs,t);
end

% --- Executes on selection change in scores_type_popupmenu.
function scores_type_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to scores_type_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns scores_type_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from scores_type_popupmenu


% --- Executes during object creation, after setting all properties.
function scores_type_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scores_type_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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

% --- Executes on button press in save_table_loadings_pushbutton.
function save_table_loadings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_table_loadings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

data = {};
% Fill in columns
data{1,1} = 'x';
data{1,2} = 'P';
data{1,3} = '|P|';
data{1,4} = 'Significant?';

for i = 1:length(handles.collection.x)
    data{i+1,1} = handles.collection.x(i);
    data{i+1,2} = handles.model.p(i);
    data{i+1,3} = abs(handles.model.p(i));
    data{i+1,4} = handles.significant(i);
end

[filename, pathname] = uiputfile({'*.csv'},'Save as');

fid=fopen([pathname,filename],'wt');

for i = 1:size(data,1)
    if i > 1
        fprintf(fid,'\n');
    end
    for j = 1:size(data,2)
        if j > 1
            fprintf(fid,',');
        end
        if ischar(data{i,j})
            fprintf(fid,'%s',data{i,j});
        elseif isinteger(data{i,j})
            fprintf(fid,'%d',data{i,j});
        else
            fprintf(fid,'%f',data{i,j});
        end
    end        
end

fclose(fid);


% --- Executes on selection change in sig_vars_listbox.
function sig_vars_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to sig_vars_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns sig_vars_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sig_vars_listbox
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

axes(handles.sig_vars_axes);
set(handles.not_sig_vars_listbox,'Value',1);
inx = get(hObject,'Value')-1;
if inx == 0
    axes(handles.sig_vars_axes);
    h = plot(0,0);
    delete(h);
    return;
end
v = handles.sig_inxs(inx);
contents = get(hObject,'String');

[f,xi] = ksdensity(handles.p_permuted{v});
plot(xi,f,'k-');
% [n,xi] = hist(handles.p_permuted{v},50);
% bar(xi,n/sum(n));
yl = ylim;
arrow([handles.model.p(v),yl(2)/4],[handles.model.p(v),0]);
xlabel(['Loading ',contents{inx+1}]);
ylabel('Probability Density Estimate');


% --- Executes during object creation, after setting all properties.
function sig_vars_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sig_vars_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in not_sig_vars_listbox.
function not_sig_vars_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to not_sig_vars_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns not_sig_vars_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from not_sig_vars_listbox
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

axes(handles.sig_vars_axes);
set(handles.sig_vars_listbox,'Value',1);
inx = get(hObject,'Value')-1;
if inx == 0
    axes(handles.sig_vars_axes);
    h = plot(0,0);
    delete(h);
    return;
end
v = handles.not_sig_inxs(inx);
contents = get(hObject,'String');

[f,xi] = ksdensity(handles.p_permuted{v});
plot(xi,f,'k-');
% [n,xi] = hist(handles.p_permuted{v},50);
% bar(xi,n/sum(n));
yl = ylim;
arrow([handles.model.p(v),yl(2)/4],[handles.model.p(v),0]);
xlabel(['Loading ',contents{inx+1}]);
ylabel('Probability Density Estimate');

% --- Executes during object creation, after setting all properties.
function not_sig_vars_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to not_sig_vars_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sig_vars_talpha_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sig_vars_talpha_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sig_vars_talpha_edit as text
%        str2double(get(hObject,'String')) returns contents of sig_vars_talpha_edit as a double


% --- Executes during object creation, after setting all properties.
function sig_vars_talpha_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sig_vars_talpha_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sig_vars_num_permutations_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sig_vars_num_permutations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sig_vars_num_permutations_edit as text
%        str2double(get(hObject,'String')) returns contents of sig_vars_num_permutations_edit as a double


% --- Executes during object creation, after setting all properties.
function sig_vars_num_permutations_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sig_vars_num_permutations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dendrogram_radiobutton.
function dendrogram_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to dendrogram_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dendrogram_radiobutton




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

set(handles.model_by_fields_listbox,'String',{'',sorted_valid_flds{:}});
set(handles.model_by_fields_listbox,'Max',length({'',sorted_valid_flds{:}}));

set(handles.group_by_fields_listbox,'String',{'',sorted_valid_flds{:}});
set(handles.group_by_fields_listbox,'Max',length({'',sorted_valid_flds{:}}));

set(handles.paired_by_fields_listbox,'String',{'',sorted_valid_flds{:}});
set(handles.paired_by_fields_listbox,'Max',length({'',sorted_valid_flds{:}}));

set(handles.ignore_by_fields_listbox,'String',{'',sorted_valid_flds{:}});
set(handles.ignore_by_fields_listbox,'Max',length({'',sorted_valid_flds{:}}));

% --- Executes on button press in ids_radiobutton.
function ids_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to ids_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ids_radiobutton


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


% --- Executes on button press in about_pushbutton.
function about_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to about_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in model_by_fields_listbox.
function model_by_fields_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to model_by_fields_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns model_by_fields_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from model_by_fields_listbox
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

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


% --- Executes on button press in open_figure_pushbutton.
function open_figure_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to open_figure_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname] = uigetfile('*.fig', 'Open figure');
open([pathname,filename]);


% --- Executes on button press in open_separate_q2_distribution_pushbutton.
function open_separate_q2_distribution_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to open_separate_q2_distribution_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%set(0,'showhiddenhandles','on') % Make the GUI figure handle visible
%h = findobj(gcf,'type','axes') % Find the axes object in the GUI
f1 = figure; % Open a new figure with handle f1
copyobj(handles.q2_distribution_axes,f1); % Copy axes object h into figure f1


% --- Executes on button press in open_separate_sig_vars_pushbutton.
function open_separate_sig_vars_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to open_separate_sig_vars_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f1 = figure; % Open a new figure with handle f1
copyobj(handles.sig_vars_axes,f1); % Copy axes object h into figure f1


% --- Executes on button press in open_separate_loadings_axes_pushbutton.
function open_separate_loadings_axes_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to open_separate_loadings_axes_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f1 = figure; % Open a new figure with handle f1
copyobj(handles.loadings_axes,f1); % Copy axes object h into figure f1


% --- Executes on button press in groups_checkbox.
function groups_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to groups_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of groups_checkbox



% % --- Executes on button press in radiobutton3.
% function radiobutton3_Callback(hObject, eventdata, handles)
% % hObject    handle to radiobutton3 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of radiobutton3
% 
% 
% % --- Executes on selection change in popupmenu2.
% function popupmenu2_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu2
% 
% 
% % --- Executes during object creation, after setting all properties.
% function popupmenu2_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end




% % --- Executes on button press in error_radiobutton.
% function error_radiobutton_Callback(hObject, eventdata, handles)
% % hObject    handle to error_radiobutton (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of error_radiobutton


% --- Executes on button press in enable_parallization_checkbox.
function enable_parallization_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to enable_parallization_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable_parallization_checkbox

if get(hObject,'Value')
    prompt={'Enter the number of workers (pool size):'};
    name='Open MATLAB parallel computation session';
    numlines=1;
    sched = findResource();
    defaultanswer={num2str(sched.ClusterSize)};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    
    poolsize = str2num(answer{1});
    if poolsize > sched.ClusterSize
        msgbox(['Please specify a number less than ',num2str(sched.ClusterSize)]);
        return;
    end
    if poolsize > 0
        try
            matlabpool(poolsize);
        catch ME
            msgbox('Failed to start parallel computation session');
            throw(ME);
        end
    end
else
    isOpen = matlabpool('size') > 0;
    if isOpen
        matlabpool close
    end
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


% --- Executes on selection change in ignore_by_listbox.
function ignore_by_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to ignore_by_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ignore_by_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ignore_by_listbox


% --- Executes during object creation, after setting all properties.
function ignore_by_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ignore_by_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ignore_by_fields_listbox.
function ignore_by_fields_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to ignore_by_fields_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ignore_by_fields_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ignore_by_fields_listbox
[result,message] = validate_state(handles,get_version_string());
if ~result
    msgbox(message);
    return;
end

ignore_by_fields_listbox(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ignore_by_fields_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ignore_by_fields_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in linkaxes_radiobutton.
function linkaxes_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to linkaxes_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of linkaxes_radiobutton


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function sig_vars_inner_talpha_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sig_vars_inner_talpha_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sig_vars_inner_talpha_edit as text
%        str2double(get(hObject,'String')) returns contents of sig_vars_inner_talpha_edit as a double


% --- Executes during object creation, after setting all properties.
function sig_vars_inner_talpha_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sig_vars_inner_talpha_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sig_vars_inner_num_permutations_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sig_vars_inner_num_permutations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sig_vars_inner_num_permutations_edit as text
%        str2double(get(hObject,'String')) returns contents of sig_vars_inner_num_permutations_edit as a double


% --- Executes during object creation, after setting all properties.
function sig_vars_inner_num_permutations_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sig_vars_inner_num_permutations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
