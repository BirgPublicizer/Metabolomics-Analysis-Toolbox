function clear_all(hObject,handles)
set(handles.group_by_listbox,'String','');
try
    rmfield(handles,'group_by_inxs');
catch ME
end

clear_before_run(hObject,handles);

% Update handles structure
guidata(hObject, handles);
