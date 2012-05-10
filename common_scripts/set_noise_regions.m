if ~isempty(getappdata(gcf,'left_noise_cursor'))
    DeleteCursor(getappdata(gcf,'left_noise_cursor'));
end
if ~isempty(getappdata(gcf,'right_noise_cursor'))
    DeleteCursor(getappdata(gcf,'right_noise_cursor'));
end   

xlim = get(gca,'xlim');
left_noise = xlim(1) + (xlim(2)-xlim(1))*2/3;
right_noise = xlim(1) + (xlim(2)-xlim(1))*1/3;
left_noise_cursor = CreateCursor(gcf,'k');
SetCursorLocation(left_noise_cursor,left_noise);
right_noise_cursor = CreateCursor(gcf,'k');
SetCursorLocation(right_noise_cursor,right_noise);
setappdata(gcf,'left_noise_cursor',left_noise_cursor);
setappdata(gcf,'right_noise_cursor',right_noise_cursor);