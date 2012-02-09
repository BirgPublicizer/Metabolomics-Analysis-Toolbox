function clear_all_except_regions
try
    lh = getappdata(gcf,'lh');
    if ~isempty(lh)
        delete(lh);
    end
catch
end

try
    yh = getappdata(gcf,'yh');
    if ~isempty(yh)
        delete(yh);
    end
catch
end

try
    yh_fixed = getappdata(gcf,'yh_fixed');
    if ~isempty(yh_fixed)
        delete(yh_fixed);
    end
catch
end

try
    yh_baseline = getappdata(gcf,'yh_baseline');
    if ~isempty(yh_baseline)
        delete(yh_baseline);
    end
catch
end

try
    extra_handles = getappdata(gcf,'extra_handles');
    if ~isempty(extra_handles)
        delete(extra_handles);
    end
catch
end
   
try
    collections = getappdata(gcf,'collections');
    for c = 1:length(collections)
        for s = 1:collections{c}.num_samples
            for i = 1:length(collections{c}.handles{s})
                set(collections{c}.handles{s}(i),'Visible','off');
            end
        end
    end
catch
end