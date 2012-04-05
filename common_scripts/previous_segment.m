function previous_segment
max_spectrum = getappdata(gcf,'max_spectrum');
min_spectrum = getappdata(gcf,'min_spectrum');
x = getappdata(gcf,'x');

regions_cursors = getappdata(gcf,'regions_cursors');
nm = size(regions_cursors);

regions_cursors = getappdata(gcf,'regions_cursors');

if isempty(getappdata(gcf,'region_inx'))
    setappdata(gcf,'region_inx',1);
end
region_inx = getappdata(gcf,'region_inx');
region_inx = region_inx - 1;
if region_inx < 1
    region_inx = 1;
end

if is_integer(regions_cursors(region_inx,1))
    left = GetCursorLocation(gcf,regions_cursors(region_inx,1));
else
    left = get(regions_cursors(region_inx,1),'xdata');
    left = left(1);
end
if is_integer(regions_cursors(region_inx,2))
    right = GetCursorLocation(gcf,regions_cursors(region_inx,2));
else
    right = get(regions_cursors(region_inx,2),'xdata');
    right = right(1);
end
set(gca,'xlim',[right,left]);

% Set the ylim for creating the cursors
set(gca,'ylim',[min(min_spectrum),max(max_spectrum)]);
set_edit

% Set the yim for the segment
inxs = find(left >= x & x >= right);
ymax = max(max_spectrum(inxs));
ymin = min(min_spectrum(inxs));
set(gca,'ylim',[ymin,ymax]);

setappdata(gcf,'region_inx',region_inx);