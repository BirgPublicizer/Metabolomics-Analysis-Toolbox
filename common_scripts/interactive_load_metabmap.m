function [ metabmap ] = interactive_load_metabmap()
%Displays a file dialog and loads the file as a metabmap
%
%   Returns a metabmap (which is just an array of CompoundBin objects)
%   loaded from a file selected by the user.  If the user does not
%   select a file, then an empty array is returned

%Get the filename from the user
[filename,pathname] = uigetfile('*.csv','Select a metab map file');

if filename == 0
    metabmap = {};
    return;
end

metabmap = load_metabmap(fullfile(pathname, filename));
