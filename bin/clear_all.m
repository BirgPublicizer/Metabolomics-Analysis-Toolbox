function clear_all(hObject,handles)
set(handles.group_by_listbox,'String','');
set(handles.model_by_listbox,'String','');
try
    rmfield(handles,'group_by_inxs');
catch ME
end
try
    rmfield(handles,'model_by_inxs');
catch ME
end

clear_before_run(hObject,handles);

% Update handles structure
guidata(hObject, handles);
