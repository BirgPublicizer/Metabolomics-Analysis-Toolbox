function clear_before_run(hObject,handles)
set(handles.summary_text,'String',{''});

axes(handles.scores_axes);
h = plot(0,0);
delete(h);
