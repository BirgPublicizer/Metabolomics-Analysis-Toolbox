function [region_inx,left,right,left_handle,right_handle,extra_left_handle,extra_right_handle] = get_region(region_inx,main_h)
if ~exist('main_h')
    main_h = gcf;
end
regions_cursors = getappdata(main_h,'regions_cursors');
if ~exist('region_inx')
    collections = getappdata(main_h,'collections');
    x = collections{1}.x;
    xlim = get(gca,'xlim');

    z = zeros(size(x));
    inxs = find(xlim(1) <= x & x <= xlim(2));
    z(inxs) = 1;
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
        inxs = find(right <= x & x <= left);
        t = z;
        t(inxs) = t(inxs) + 1;
        score = sum(find(t == 2));
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