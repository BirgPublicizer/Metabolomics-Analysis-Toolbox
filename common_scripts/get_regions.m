function [regions,left_handles,right_handles] = get_regions(main_h)
if exist('main_h')
    regions_cursors = getappdata(main_h,'regions_cursors');
else
    main_h = gcf;
    regions_cursors = getappdata(gcf,'regions_cursors');
end
nm = size(regions_cursors);
regions = [];
left_handles = [];
right_handles = [];
try
for b = 1:nm(1)
    [region_inx,left,right,left_handle,right_handle] = get_region(b,main_h);
    regions(end+1,:) = [left,right];
    left_handles(end+1) = left_handle;
    right_handles(end+1) = right_handle;
end
catch ME
end