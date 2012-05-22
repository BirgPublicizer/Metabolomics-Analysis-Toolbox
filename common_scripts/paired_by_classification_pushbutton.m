function paired_by_classification_pushbutton(hObject,handles)
[sorted_classifications_str,group_by_inxs,inxs] = by_classification_pushbutton(handles);

set(handles.paired_by_listbox,'String',sorted_classifications_str);
set(handles.paired_by_listbox,'Max',length(sorted_classifications_str));
set(handles.paired_by_listbox,'Value',1);

handles.paired_by_inxs = {group_by_inxs{inxs}};

% Update handles structure
guidata(hObject, handles);