function collections = copy_y_to_y_fixed(fixed_collections, collections)
% Executes collections{i}.Y_fixed = fixed_collections{i}.Y for all i and returns the result
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% fixed_collections - a cell array whose members are structs with a field
%                     called 'Y'
% 
% collections       - a cell array with the same number of entries as
%                     fixed_collections, whose members are structs
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% collections       - collections{i}.Y_fixed == fixed_collections{i}.Y for all i
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> c{1}.Y=[1]; c{2}.Y=[1,2]; fc{1}.Y=[5]; fc{2}.Y=[22,21]; n=copy_y_to_y_fixed(fc, c);
%
% Afterwards:
%
% n{1}.Y == 1
%
% n{1}.Y_fixed == 5
%
% n{2}.Y == [1,2]
%
% n{2}.Y_fixed == [22,21]
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com

if ~iscell(collections) || ~iscell(fixed_collections)
    error('copy_y_to_y_fixed:cell', ['The collections and '...
        'fixed_collections parameters passed to copy_y_to_y_fixed ' ...
        'must be cell arrays']);
end

if length(collections) ~= length(fixed_collections)
    error('copy_y_to_y_fixed:same_len', ['The collections and '...
        'fixed_collections parameters passed to copy_y_to_y_fixed ' ...
        'must be the same length']);
end

for i=1:length(collections)
    collections{i}.Y_fixed = fixed_collections{i}.Y;
end

end

