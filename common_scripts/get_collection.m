function [collection,message] = get_collection(collection_id,username,password)
% Gets the given collection from the birg website using the given username 
% and password.  If called without any of the parameters, displays dialogs
% to get them from the user.
%
% Returns the collection or {} on error.  If there is an error, message
% contains an error message for the user.
message = [];

if ~exist('username','var') || ~exist('password','var')
    [username,password] = logindlg;
    if isempty(username) && isempty(password)
        collection = {};
        message = 'You must enter a username and password';
        return;
    end
end

if ~exist('collection_id','var') || isempty(collection_id)
    prompt={'Collection ID:'};
    name='Enter the collection ID from the website';
    numlines=1;
    defaultanswer={''};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        message = 'You must enter a collection ID';
        collection = {};
        return;
    end
    collection_id = str2double(answer{1});
    if isnan(collection_id) || length(collection_id) ~= 1
        message = 'You must enter a number as the collection ID';
        collection = {};
        return;
    end
end

url = sprintf('http://birg.cs.wright.edu/omics_analysis/collections/%d.xml',collection_id);
try
    [xml,urlstatus] = urlread(url,'get',{'name',username,'password',password});
    if ~isempty(regexp(xml,'password', 'once'))
        message = 'Invalid password';
        collection = {};
        return;
    end
    if urlstatus == 0
        error('urlread failed with status 0: %s',url); %#ok<SPERR>
    end
catch ME
    disp(urlstatus);
    throw(ME);
end
n = regexp(xml,'<data>(.*)</data>','tokens');
data = n{1}{1};
% file = tempname;
% fid = fopen(file,'w');
% fwrite(fid,xml);
% %fprintf(fid,xml);
% fclose(fid);
% collection_xml = xml2struct(file);
% data = collection_xml.Children(2).Children.Data;
file = tempname;
fid = fopen(file,'w');
fwrite(fid,data);
%fprintf(fid,data);
fclose(fid);

collection = load_collection(file,'');