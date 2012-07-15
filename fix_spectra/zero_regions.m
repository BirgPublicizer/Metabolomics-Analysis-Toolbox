function zero_regions

regions = get_regions;
num_regions = size(regions); num_regions = num_regions(1);
if num_regions == 0
    error_no_regions_selected
end
collections = getappdata(gcf,'collections');
% c = getappdata(gcf,'collection_inx');
% s = getappdata(gcf,'spectrum_inx');
for c = 1:length(collections)
    x = collections{c}.x;
    for s = 1:collections{c}.num_samples
        y = collections{c}.Y(:,s);

        % in_region is true iff the corresponding x value is in one of the
        % regions
        in_region = false(size(x));
        for i = 1:num_regions
            in_region = in_region | ((regions(i,1) >= x) & (x >= regions(i,2)));
        end
        
        if sum(abs(collections{c}.Y_fixed(:,s))) > 0 % Fixed answer available
            collections{c}.Y_fixed(in_region,s) = 0;
        else
            collections{c}.Y_fixed(:,s) = y;
            collections{c}.Y_fixed(in_region,s) = 0;
        end
    end
end
setappdata(gcf,'add_processing_log','Zero regions.');
setappdata(gcf,'temp_suffix','_zero_regions');
setappdata(gcf,'collections',collections);

plot_all