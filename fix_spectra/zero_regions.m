function zero_regions

regions = get_regions;
collections = getappdata(gcf,'collections');
% c = getappdata(gcf,'collection_inx');
% s = getappdata(gcf,'spectrum_inx');
for c = 1:length(collections)
    for s = 1:collections{c}.num_samples
        y = collections{c}.Y(:,s);
        x = collections{c}.x;
        xwidth = abs(x(1)-x(2));
        xmax = max(x);

        % w is a map
        w = zeros(size(y));
        nm = size(regions);
        if nm(1) == 0
            error_no_regions_selected
        end
        for i = 1:nm(1)
            inx1 = max([1,round((xmax - regions(i,1))/xwidth) + 1,1]);
            inx2 = min([round((xmax - regions(i,2))/xwidth) + 1,length(w)]);
            w(inx1:inx2) = 1;
        end
        inxs = find(w == 1);        

        if sum(abs(collections{c}.Y_fixed(:,s))) > 0 % Fixed answer available
            collections{c}.Y_fixed(inxs,s) = 0;
        else
            collections{c}.Y_fixed(:,s) = y;
            collections{c}.Y_fixed(inxs,s) = 0;
        end
    end
end
setappdata(gcf,'add_processing_log','Zero regions.');
setappdata(gcf,'temp_suffix','_zero_regions');
setappdata(gcf,'collections',collections);

plot_all