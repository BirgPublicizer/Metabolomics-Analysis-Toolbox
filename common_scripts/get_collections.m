function [collections,message] = get_collections
% Displays dialogs for downloading collections from the BIRG server.  
% Returns a cell array of collections. On error returns an empty array.

% username = getappdata(gcf,'username');
% password = getappdata(gcf,'password');    
% if isempty(username) || isempty(password)
    [username,password] = logindlg;
%     setappdata(gcf,'username',username);
%     setappdata(gcf,'password',password);
% end

%Return empty collection username and password were not entered
if isempty(username) || isempty(password)
    collections={};
    return;
end
    
% Read which collections to get
prompt={'Collection ID(s) [comma separated]:'};
name='Enter the collection ID from the website';
numlines=1;
defaultanswer={''};
answer=inputdlg(prompt,name,numlines,defaultanswer);
if(isempty(answer))
    collections={};
    return;    
end
collection_ids = split(answer{1},',');

% Download collections
collections = {};
xml = '';
try
    for i = 1:length(collection_ids)
        
        collection_id = str2num(collection_ids{i});
        [collections{end+1},message] = get_collection(collection_id,username,password);
        if ~isempty(message)
            collections = {};
            return;
        end
    end
catch ME
    collections = {};
    if(regexp( ME.identifier,'MATLAB:urlread'))
        msgbox(['Could not read a collection from BIRG server.\n' ...
            'Either the collection number was not valid or the server ' ...
            'is not working\n']);
    else
        fprintf(ME.message);
        fprintf('\n');
        fprintf('Get Collections failed with following xml:\n');
        fprintf(xml);
        fprintf('\n');
    end
end
