function [result,message] = validate_state( handles, version_string)
%VALIDATE_STATE Validates a program to make sure a collection is loaded and
%the version matches the executable.
result = true;
message = '';

if ~strcmp(get(handles.version_text,'String'),version_string)
    result = false;
    message = sprintf('Versions do not match. Find and run version %s',get(handles.version_text,'String'));
    return;
end

if ~isfield(handles,'collection')
    result = false;
    message = 'No collection loaded';
    return;
end

