function clear_regions_cursors
try
    regions_cursors = getappdata(gcf,'regions_cursors');
    nm = size(regions_cursors);
    for i = 1:nm(1)
        if is_integer(regions_cursors(i,1))
            DeleteCursor(gcf,regions_cursors(i,1));
        else
            delete(regions_cursors(i,1));
        end
        if is_integer(regions_cursors(i,2))
            DeleteCursor(gcf,regions_cursors(i,2));
        else
            delete(regions_cursors(i,2));
        end
    end
    setappdata(gcf,'regions_cursors',[]);
catch ME
end