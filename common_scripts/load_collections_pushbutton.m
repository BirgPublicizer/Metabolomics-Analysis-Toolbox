function handles = load_collections_pushbutton(handles)
% Ask the user for a file, load it, and replace handles.collection with it
%
% Code originally by Paul Anderson.  Comments added after-the-fact

collections = load_collections;

% Not sure why this was here - collections is not usually a field, so this
% may be a typo.  However, Paul uses this routine in several GUIs, I can't
% be sure.  Commenting it out should make 
%
%if isempty(handles.collections)
%    return
%end

handles.collection = merge_collections_cell(collections);

clear_all(handles.figure1,handles);

set(handles.description_text,'String',handles.collection.description);
