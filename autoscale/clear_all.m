function clear_all(hObject,handles)
set(handles.model_by_listbox,'String','');
try
    rmfield(handles,'model_by_inxs');
catch ME
end

clear_before_run(hObject,handles);

% Update handles structure
guidata(hObject, handles);
