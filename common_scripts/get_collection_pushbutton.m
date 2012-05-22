function handles = get_collection_pushbutton(handles)
collection_id = str2num(get(handles.collection_id_edit,'String'));
try
    [handles.collection,message] = get_collection(collection_id);
    if ~isempty(message)
        msgbox(message);
        return;
    end
catch ME
    msgbox('Error loading collection');
    throw(ME);
end

clear_all(handles.figure1,handles);

set(handles.description_text,'String',handles.collection.description);
