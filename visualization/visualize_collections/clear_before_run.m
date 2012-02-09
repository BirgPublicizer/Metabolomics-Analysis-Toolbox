function clear_before_run(hObject,handles)
% Clear summary text and the any fixed xlim boundaries
%
% Code originally by Paul Anderson.  Comments initially added 
% after-the-fact by Eric Moyer

set(handles.summary_text,'String',{''});
try
    rmfield(handles,'xlim');
catch ME
end
