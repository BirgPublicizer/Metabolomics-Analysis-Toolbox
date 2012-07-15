function found = cell_find( in )
% Given a matrix same as find. Given cells, performs cell_find on each cell
%
% If in is a matrix, just calls find. If in is a cell array, returns an
% identical cell array with the contents of each cell replaced by the
% results of a call to cell_find with those contents.
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% in - the input
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% found - if in is a matrix, found = find(in). Otherwise found =
%         map(cell_find, in) (map being read as the functional programming
%         equivalent)
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> a = cell_find([0,1,2,0])
% 
% a = [2,3]
%
% >> a = cell_find({true,[0,1,2,0];[0,0],[1,1]})
% 
% a = {[1],[2,3];[],[1,2]}
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%


if iscell(in)
    found = cell(size(in));
    num_cells = numel(in);
    for i=1:num_cells
        found{i}=cell_find(in{i});
    end
else
    found = find(in);
end


end

