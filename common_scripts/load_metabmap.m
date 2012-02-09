function [ metabmap ] = load_metabmap(full_filename, load_deleted)
% Loads the file as a metabmap
%
% Returns a metabmap (which is just an array of CompoundBin objects)
% loaded from a file passed as an argument.  If the the given file is
% invalid, an empty array is returned.
%
% If load_deleted = 'no_deleted_bins' then only returns the bins that are
% not marked deleted.
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
%
% full_filename  The filename of the file to load
%
% load_deleted   If present then only returns those bins that are not
%                marked deleted.  If present must be set to 
%                'no_deleted_bins' 
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% metabmap  An array of CompoundBin objects loaded from the file passed 
%           as an argument.  If the the given file is invalid, an 
%           empty array is returned.
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> mm=load_metabmap(filename);
%
% Puts all the compound bin objects from filename into mm
%
% >> mm=load_metabmap(filename,'no_deleted_bins');
%
% Ignores the deleted bins in filename and puts the rest into mm


if ( ~ischar(full_filename) )
    error('birg:invalid_param_type',...
        ['Argument 1 invalid type ''' ...
        class(full_filename) ...
        '''. ''char'' expected']);
end;

should_remove_deleted = false;
if nargin > 1
    if strcmp(load_deleted,'no_deleted_bins');
        should_remove_deleted = true;
    else
        error('load_metabmap:invalid_load_deleted', ...
            ['The load_deleted argument to load_metabmap must have ' ...
            'the value "no_deleted_bins" if it is present.  Instead ' ...
            'it was: "' load_deleted '"']);
    end
end

%Open the file
fid = fopen(full_filename,'r','n','ISO-8859-1');
if fid == -1
    metabmap = [];
    return;
end

header = fgetl(fid);
metabmap = CompoundBin; %Array with one element to set the type to CompoundBin
metabmap(1)=[];         %Erase the element to have empty array of CompoundBin
if ischar(header)
    while true
        line = fgetl(fid);
        if ischar(line)
            try
                metabmap(end+1) = CompoundBin(header, line); %#ok<AGROW>
            catch err
                if isequal(err.identifier, 'CompoundBin:unknown_header')
                    msgbox(['The metab-map had an unrecognized header: "'...
                        header '"'],'Error','error');
                    metabmap = [];
                    return;
                else
                    msgbox(['Problem creating bin from metab-map file ' ...
                        'line.  The line was: ' line ...
                        'The error message was: ' err.message ], ...
                        'Error','error');
                    metabmap = [];
                    return;
                end
            end
        else
            break;
        end
    end
    if should_remove_deleted
        metabmap = remove_deleted_bins_from_metabmap(metabmap);
    end
else
    msgbox('The metab-map file was empty','Error','error');
    metabmap = [];
    return;
end


end

