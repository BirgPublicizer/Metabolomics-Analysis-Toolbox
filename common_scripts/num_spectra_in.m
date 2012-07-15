function num_spectra = num_spectra_in( collections )
% Return the number of spectra in the collections
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% collections - a cell array of spectral collections. Each spectral
%               collection is a struct array of spectra. This is the format
%               of the return value of load_collections.m in
%               common_scripts.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% num_spectra - how many spectra were in the collections total (a scalar)
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% count = num_spectra_in(my_collections)
%
% Returns the number of spectra in my_collections
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com

if ~iscell( collections )
    error('num_spectra_in:not_cell','The collections object passed to num_spectra_in must be a cell array');
end

num_spectra = 0;
if isempty(collections)
    return;
end

for idx=1:length(collections)
    cur=collections{idx};
    num_spectra = num_spectra + size(cur.Y,2);
end

end

