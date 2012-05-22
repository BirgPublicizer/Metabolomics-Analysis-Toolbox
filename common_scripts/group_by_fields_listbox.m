function handles = group_by_fields_listbox(hObject,handles)
contents = cellstr(get(handles.group_by_fields_listbox,'String'));
selected_fields = contents(get(handles.group_by_fields_listbox,'Value'));
if isempty(selected_fields)
    msgbox('Select at least one group by field');
    return;
end

for i = 1:length(selected_fields)
    if isempty(selected_fields{i}) % Empty space was selected, so reset
        set(handles.group_by_listbox,'String',[]);
        set(handles.group_by_listbox,'Max',1);
        set(handles.group_by_listbox,'Min',0);
        set(handles.group_by_listbox,'Value',1);
        
        handles.group_by_inxs = {};
        guidata(hObject, handles);
        
        return;
    end
end
        

[sorted_fields_str,group_by_inxs,inxs] = by_fields_listbox(handles.collection,selected_fields);

set(handles.group_by_listbox,'String',sorted_fields_str);
set(handles.group_by_listbox,'Max',length(sorted_fields_str));
% set(handles.group_by_listbox,'Value',1);
% mx = get(handles.group_by_listbox,'Max');
set(handles.group_by_listbox,'Value',1:length(sorted_fields_str));

handles.group_by_inxs = {group_by_inxs{inxs}};

% Update handles structure
guidata(hObject, handles);
