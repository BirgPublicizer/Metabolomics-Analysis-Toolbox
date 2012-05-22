function delete_region(del_inx)
% Delete the region at index del_inx in the current figure
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
%
% del_inx - The index of the region to delete in the array of regions.
%
%           {Optional} If omitted, I think it returns the region with
%           the greatest overlap with the current window breaking ties
%           with the lowest index.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
%
% none
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% delete_region
%
% Deletes the largest region in the current window
%
% 
% delete_region(1)
%
% deletes the first region in the current figure
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Paul Anderson or Daniel Homer ????
%     Main Code
%
% Eric Moyer (eric_moyer@yahoo.com) 2012
%     Documentation and removed some warnings

regions_cursors = getappdata(gcf,'regions_cursors');
if exist('del_inx','var')
    [del_inx,left,right] = get_region(del_inx); %#ok<ASGLU,NASGU>
else
    [del_inx,left,right] = get_region; %#ok<NASGU,ASGLU>
end

if is_integer(regions_cursors(del_inx,1))
    DeleteCursor(gcf,regions_cursors(del_inx,1));
else
    delete(regions_cursors(del_inx,1));
end
if is_integer(regions_cursors(del_inx,2))
    DeleteCursor(gcf,regions_cursors(del_inx,2));
else
    delete(regions_cursors(del_inx,2));
end
regions_cursors = regions_cursors([1:del_inx-1,del_inx+1:end],:);
setappdata(gcf,'regions_cursors',regions_cursors);
region_inx = getappdata(gcf,'region_inx');
if ~isempty(region_inx)
    if region_inx >= del_inx
        setappdata(gcf,'region_inx',region_inx-1);
    end
end
