function [region_inx,left,right,left_handle,right_handle,extra_left_handle,extra_right_handle] = get_region(region_inx,main_h)
% Return the properties of region region_inx in the figure main_h
%
% Interface hiding the differences between two different methods of
% representing regions, one given by the cursors library (in
% common_scripts/cursors) and the other storing them directly in gui
% objects (lines, I think)
%
% If you can't tell, this is maintenance programmer documentation, written
% long after the fact by a different author than that of the code.  Use at
% your own risk.
% 
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
%
% region_inx - The index of the region to return in the array of regions.
%
%              {Optional} If omitted, I think it returns the region with
%              the greatest overlap with the current window breaking ties
%              with the lowest index.
%
% main_h     - The GUI handle of the figure to use.
%
%              {Optional} If omitted, uses gcf
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
%
% region_inx   - the index of the region returned in the array of regions -
%                the region id
% left         - the x location of the left boundary of the region
% right        - the x location of the right boundary of the region
% left_handle  - the handle of the gui object for the left part of the
%                region (guess)
% right_handle  - the handle of the gui object for the right part of the
%                region (guess)
% extra_left_handle - another handle for the gui object (in some cases, it
%                     is the same as left_handle) (guess)
% extra_right_handle - another handle for the gui object (in some cases, it
%                     is the same as right_handle) (guess)
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% [region_inx,left,right,left_handle,right_handle, ...
%  extra_left_handle,extra_right_handle] = get_region(i)
%
% Gets the parameters of region i in the current figure
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
if ~exist('main_h','var')
    main_h = gcf;
end
regions_cursors = getappdata(main_h,'regions_cursors');
if ~exist('region_inx','var')
    collections = getappdata(main_h,'collections');
    x = collections{1}.x;
    xlim = get(gca,'xlim');

    z = zeros(size(x));
    x_in_window = xlim(1) <= x & x <= xlim(2);
    z(x_in_window) = 1;
    nm = size(regions_cursors);
    max_score = -Inf;
    max_b = 0;
    for b = 1:nm(1)        
        if is_integer(regions_cursors(b,1))
            left = GetCursorLocation(main_h,regions_cursors(b,1));
        else
            left = get(regions_cursors(b,1),'xdata');
            left = left(1);
        end
        if is_integer(regions_cursors(b,2))
            right = GetCursorLocation(main_h,regions_cursors(b,2));
        else
            right = get(regions_cursors(b,2),'xdata');
            right = right(1);
        end
        x_in_region = right <= x & x <= left;
        t = z;
        t(x_in_region) = t(x_in_region) + 1;
        score = sum(find(t == 2)); %This may be a bug - should it be "score = sum(t==2);" ?
        if score > max_score
            max_score = score;
            max_b = b;
        end
    end
    region_inx = max_b;
end
Cursors=getappdata(main_h,'VerticalCursors');
if is_integer(regions_cursors(region_inx,1))
    left = GetCursorLocation(main_h,regions_cursors(region_inx,1));
    left_handle = Cursors{regions_cursors(region_inx,1)}.Handles(1);
    extra_left_handle = Cursors{regions_cursors(region_inx,1)}.Handles(2);
else
    left = get(regions_cursors(region_inx,1),'xdata');
    left = left(1);
    left_handle = regions_cursors(region_inx,1);
    extra_left_handle = left_handle;
end

if is_integer(regions_cursors(region_inx,2))
    right = GetCursorLocation(main_h,regions_cursors(region_inx,2));
    right_handle = Cursors{regions_cursors(region_inx,2)}.Handles(1);
    extra_right_handle = Cursors{regions_cursors(region_inx,2)}.Handles(2);
else
    right = get(regions_cursors(region_inx,2),'xdata');
    right = right(1);
    right_handle = regions_cursors(region_inx,2);
    extra_right_handle = right_handle;
end