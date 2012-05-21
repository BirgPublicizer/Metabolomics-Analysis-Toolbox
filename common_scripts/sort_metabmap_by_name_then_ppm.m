function sorted=sort_metabmap_by_name_then_ppm(metab_map)
% Returns metab_map sorted by compound name then by left bin boundary ppm.  
%
% metab_map is an array of CompoundBin objects.  The compound names are
% sorted alphabetically, ignoring case.
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
%
% sorted = sort_metabmap_by_name_then_ppm(metab_map)
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
%
% metabmap  An array of CompoundBin objects to be sorted
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% sorted    The input array after being sorted by the compound_name field
%           then by the left bin boundary field
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% sorted = sort_metabmap_by_name_then_ppm(metab_map)

if isempty(metab_map) 
    sorted = metab_map;
    return;
end
bins = [metab_map.bin];
lefts = [bins.left];
[unused,indexes] = sort(lefts, 'descend'); %#ok<ASGLU>
sorted = metab_map(indexes);
names = lower({sorted.compound_name});
[unused, indexes] = sort(names); %#ok<ASGLU>
sorted = sorted(indexes);
