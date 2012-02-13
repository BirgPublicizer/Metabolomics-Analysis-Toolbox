function create_new
regions_cursors = getappdata(gcf,'regions_cursors');
nm = size(regions_cursors);
insert_inx = nm(1) + 1;

xlims = get(gca,'xlim');
left = xlims(1)+(xlims(2)-xlims(1))*9/10;
right = xlims(1)+(xlims(2)-xlims(1))*1/10;
old_ylim = get(gca,'ylim');
orig_ylim = getappdata(gcf,'orig_ylim');
if ~isempty(orig_ylim)
    set(gca,'ylim',old_ylim);
end
left_cursor = CreateCursor(gcf,'g');
SetCursorLocation(left_cursor,left);
right_cursor = CreateCursor(gcf,'r');
SetCursorLocation(right_cursor,right);
regions_cursors(end+1,:) = [left_cursor,right_cursor];
setappdata(gcf,'regions_cursors',regions_cursors);

[region_inx,left,right,left_handle,right_handle,extra_left_handle,extra_right_handle] = get_region(insert_inx);
myfunc = @(hObject, eventdata, handles) (region_click_menu(left_handle));
menu = uicontextmenu('Callback',myfunc);
set(left_handle,'UIContextMenu',menu);
set(extra_left_handle,'UIContextMenu',menu);
myfunc = @(hObject, eventdata, handles) (region_click_menu(right_handle));
menu = uicontextmenu('Callback',myfunc);
set(right_handle,'UIContextMenu',menu);
set(extra_right_handle,'UIContextMenu',menu);

% Make sure regions are sorted
regions = get_regions;
if ~isempty(regions)
    lefts = regions(:,1);
    [vs,inxs] = sort(lefts,'descend');
    regions_cursors = regions_cursors(inxs,:);
    setappdata(gcf,'regions_cursors',regions_cursors);
end