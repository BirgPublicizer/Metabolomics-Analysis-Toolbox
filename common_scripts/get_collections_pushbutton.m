function handles = get_collections_pushbutton(handles)
collection_ids_str = split(get(handles.collection_id_edit,'String'),',');
collection_ids = [];
for i = 1:length(collection_ids_str)
    collection_ids(i) = str2num(collection_ids_str{i});
end

[username,password] = logindlg;
if isempty(username) && isempty(password)
    msgbox('You must enter a username and password');
    return;
end

try
    collections = {};
    for i = 1:length(collection_ids)
        collection_id = collection_ids(i);
        [collections{i},message] = get_collection(collection_id,username,password);
        if ~isempty(message)
            msgbox(message);
            return;
        end
    end
    
    handles.collection = merge_collections_cell(collections);
catch ME
    msgbox('Error loading collection');
    throw(ME);
end

clear_all(handles.figure1,handles);

set(handles.description_text,'String',handles.collection.description);
