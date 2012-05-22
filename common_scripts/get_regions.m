function [regions,left_handles,right_handles] = get_regions(main_h)
% Return 3 arrays for the coords and handles of the regions in main_h
%
% This is maintenance programmer documentation, written
% long after the fact by a different author than that of the code.  Use at
% your own risk.
% 
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
%
% main_h     - The GUI handle of the figure whose regions will be returned
%
%              {Optional} If omitted, uses gcf, the current figure
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
%
% regions       - regions(i,:) is an array [left, right] giving the x
%                 coordinates of the left and right boundaries of the 
%                 i-th region respectively
%
% left_handles  - left_handles(i) is the handle of the gui object
%                 representing the left boundary of the i-th region
%
% right_handles - right_handles(i) is the handle of the gui object
%                 representing the right boundary of the i-th region
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% [regions,left_h, right_h] = get_regions()
%
% Returns the regions in the current figure
%
%
%
% [regions,left_h, right_h] = get_regions(h)
%
% Returns the regions in figure h
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

if exist('main_h','var')
    regions_cursors = getappdata(main_h,'regions_cursors');
else
    main_h = gcf;
    regions_cursors = getappdata(gcf,'regions_cursors');
end
nm_ary = size(regions_cursors);
nm = nm_ary(1);
regions = zeros(nm,2);
left_handles = zeros(nm,1);
right_handles = zeros(nm,1);
try
for b = 1:nm
    [region_inx,left,right,left_handle,right_handle] = get_region(b,main_h); %#ok<ASGLU>
    regions(b,:) = [left,right];
    left_handles(b) = left_handle;
    right_handles(b) = right_handle;
end
catch ME %#ok<NASGU>
end