function handles = load_collection_pushbutton(handles)
collections = load_collections;
if isempty(collections)
    return
end
if length(collections) > 1
    msgbox('Only load a single collection');
    return;
end
handles.collection = collections{1};

clear_all(handles.figure1,handles);

set(handles.description_text,'String',handles.collection.description);
