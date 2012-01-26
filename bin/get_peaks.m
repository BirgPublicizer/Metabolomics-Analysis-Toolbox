function handles = get_peaks(handles)
if ~isfield(handles.collection,'maxs')
    handles = find_peaks(handles,30);
    guidata(handles.figure1,handles);
end
