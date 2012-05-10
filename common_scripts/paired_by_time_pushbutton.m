function paired_by_time_pushbutton(hObject,handles)
[sorted_times_str,group_by_inxs,inxs] = by_time_pushbutton(handles);

set(handles.paired_by_listbox,'String',sorted_times_str);
set(handles.paired_by_listbox,'Max',length(sorted_times_str));
set(handles.paired_by_listbox,'Value',1);

handles.paired_by_inxs = {group_by_inxs{inxs}};

% Update handles structure
guidata(hObject, handles);