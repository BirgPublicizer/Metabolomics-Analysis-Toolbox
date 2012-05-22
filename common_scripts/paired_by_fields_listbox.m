function paired_by_fields_listbox(hObject,handles)
contents = cellstr(get(handles.paired_by_fields_listbox,'String'));
selected_fields = contents(get(handles.paired_by_fields_listbox,'Value'));
if isempty(selected_fields)
    msgbox('Select at least one paired by field');
    return;
end

for i = 1:length(selected_fields)
    if isempty(selected_fields{i}) % Empty space was selected, so reset
        set(handles.paired_by_listbox,'String',[]);
        set(handles.paired_by_listbox,'Max',1);
        set(handles.paired_by_listbox,'Min',0);
        set(handles.paired_by_listbox,'Value',1);
        
        handles.paired_by_inxs = {};
        guidata(hObject, handles);
        
        return;
    end
end
        

[sorted_fields_str,paired_by_inxs,inxs] = by_fields_listbox(handles.collection,selected_fields);

set(handles.paired_by_listbox,'String',sorted_fields_str);
set(handles.paired_by_listbox,'Max',length(sorted_fields_str));
set(handles.paired_by_listbox,'Value',1);

handles.paired_by_inxs = {paired_by_inxs{inxs}};

% Update handles structure
guidata(hObject, handles);
