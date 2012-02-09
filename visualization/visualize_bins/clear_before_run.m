function clear_before_run(hObject,handles)

axes(handles.spectra_axes);
h = plot(0,0);
delete(h);
