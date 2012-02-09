function clear_all(hObject,handles)
% Clear all selections dependent on the current collection & update guidata
%
% Clears "group by" calls clear_before_run
%
% Code originally by Paul Anderson.  Comments initially added 
% after-the-fact by Eric Moyer

set(handles.group_by_listbox,'String','');
try
    rmfield(handles,'group_by_inxs');
catch ME
end

clear_before_run(hObject,handles);

% Update handles structure
guidata(hObject, handles);
