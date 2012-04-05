function model_by_fields_listbox(hObject,handles)
contents = cellstr(get(handles.model_by_fields_listbox,'String'));
selected_fields = contents(get(handles.model_by_fields_listbox,'Value'));
if isempty(selected_fields)
    msgbox('Select at least one model by field');
    return;
end

for i = 1:length(selected_fields)
    if isempty(selected_fields{i}) % Empty space was selected, so reset
        set(handles.model_by_listbox,'String',[]);
        set(handles.model_by_listbox,'Max',1);
        set(handles.model_by_listbox,'Min',0);
        set(handles.model_by_listbox,'Value',1);
        
        handles.model_by_inxs = {};
        guidata(hObject, handles);
        
        return;
    end
end
        

[sorted_fields_str,group_by_inxs,inxs,handles.collection] = by_fields_listbox(handles.collection,selected_fields);

set(handles.model_by_listbox,'String',sorted_fields_str);
set(handles.model_by_listbox,'Max',length(sorted_fields_str));
set(handles.model_by_listbox,'Value',1);

handles.model_by_inxs = {group_by_inxs{inxs}};

% Update handles structure
guidata(hObject, handles);
