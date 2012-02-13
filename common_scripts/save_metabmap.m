function [ filename ] = save_metabmap( varargin )
%Saves an array of compound bins to a file readable by load_metabmap
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
%
% filename   The name of the file to write to - a string
%
% metab_map  An array of CompoundBin objects that will be written to the
%            file
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
%
% filename  The file that was written to
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% fn = save_metabmap( filename, metab_map )
%
% Writes the compound bins in metab_map to the file filename and
% returns that name.

if ( length(varargin) ~= 2 )
    error('birg:incorrect_param_count', ...
        ['Invalid function parameter count.' ...
        ' Two (2) parameters expected.']);
end;

filename = varargin{1};
if ( ~ischar(filename) )
    error('birg:invalid_param_type',...
        ['Argument 1 invalid type ''' ...
        class(filename) ...
        '''. ''char'' expected.']);
end;

metab_map = varargin{2};
if ( ~strcmp(class(metab_map), 'CompoundBin') )
    error('birg:invalid_param_type',...
        ['Argument 2 invalid type ''' ...
        class(metab_map) ...
        '''. ''CompoundBin'' expected.']);
end;

fid = fopen(filename,'w');
if fid == -1
    error('birg:not_open_file', ...
        ['Could not open metab map file named ''' ...
        filename '''.']);
end

fprintf(fid, '%s\n', CompoundBin. csv_file_header_string);
for i = 1:length(metab_map);
    fprintf(fid, '%s\n', metab_map(i).as_csv_string);
end
fclose(fid);

