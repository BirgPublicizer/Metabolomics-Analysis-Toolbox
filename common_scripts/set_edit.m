function set_edit(region_inx)
if exist('region_inx')
    [region_inx,left,right,left_handle] = get_region(region_inx);
else
    [region_inx,left,right,left_handle] = get_region;
end
info = getappdata(left_handle,'info');
regions_cursors = getappdata(gcf,'regions_cursors');
if ~is_integer(regions_cursors(region_inx,1))
    delete(regions_cursors(region_inx,1));
    cursor = CreateCursor(gcf,'g');
    SetCursorLocation(gcf,cursor,left);
    regions_cursors(region_inx,1) = cursor;
end

if ~is_integer(regions_cursors(region_inx,2))
    delete(regions_cursors(region_inx,2));
    cursor = CreateCursor(gcf,'r');
    SetCursorLocation(gcf,cursor,right);
    regions_cursors(region_inx,2) = cursor;
end

setappdata(gcf,'regions_cursors',regions_cursors);
[region_inx,left,right,left_handle,right_handle,extra_left_handle,extra_right_handle] = get_region(region_inx);
myfunc = @(hObject, eventdata, handles) (region_click_menu(left_handle));
menu = uicontextmenu('Callback',myfunc);
set(left_handle,'UIContextMenu',menu);
set(extra_left_handle,'UIContextMenu',menu);
myfunc = @(hObject, eventdata, handles) (region_click_menu(right_handle));
menu = uicontextmenu('Callback',myfunc);
set(right_handle,'UIContextMenu',menu);
set(extra_right_handle,'UIContextMenu',menu);

setappdata(left_handle,'info',info);