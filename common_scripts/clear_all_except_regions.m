function clear_all_except_regions
try
    yhs = getappdata(gcf,'yhs');
    for i = 1:length(yhs)
        delete(yhs);
    end
    
    lh = getappdata(gcf,'lh');
    if ~isempty(lh)
        delete(lh);
    end
catch
end