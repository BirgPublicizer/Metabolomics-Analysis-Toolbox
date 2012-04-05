function delete_region(del_inx)
regions_cursors = getappdata(gcf,'regions_cursors');
if exist('del_inx')
    [del_inx,left,right] = get_region(del_inx);
else
    [del_inx,left,right] = get_region;
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
