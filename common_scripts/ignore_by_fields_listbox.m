function ignore_by_fields_listbox(hObject,handles)
contents = cellstr(get(handles.ignore_by_fields_listbox,'String'));
selected_fields = contents(get(handles.ignore_by_fields_listbox,'Value'));
if isempty(selected_fields)
    msgbox('Select at least one ignore by field');
    return;
end

for i = 1:length(selected_fields)
    if isempty(selected_fields{i}) % Empty space was selected, so reset
        set(handles.ignore_by_listbox,'String',[]);
        set(handles.ignore_by_listbox,'Max',1);
        set(handles.ignore_by_listbox,'Min',0);
        set(handles.ignore_by_listbox,'Value',1);
        
        handles.ignore_by_inxs = {};
        guidata(hObject, handles);
        
        return;
    end
end
        

[sorted_fields_str,ignore_by_inxs,inxs] = by_fields_listbox(handles.collection,selected_fields);

set(handles.ignore_by_listbox,'String',sorted_fields_str);
set(handles.ignore_by_listbox,'Max',length(sorted_fields_str));
set(handles.ignore_by_listbox,'Value',1);

handles.ignore_by_inxs = {ignore_by_inxs{inxs}};

% Update handles structure
guidata(hObject, handles);
