function new_regions = add_buffer(regions,bins,maxs,x,decon_xbuffer)
new_regions = regions;
for s = 1:length(regions)
    for r = 1:length(regions{s})
        left_bin = bins(r,1) + decon_xbuffer;
        ixs = find(left_bin >= x(maxs{s}) & x(maxs{s}) >= bins(r,1));
        new_regions{s}{r}.include_mask(ixs) = 0;
        right_bin = bins(r,2) - decon_xbuffer;
        ixs = find(bins(r,2) >= x(maxs{s}) & x(maxs{s}) >= right_bin);
        new_regions{s}{r}.include_mask(ixs) = 0;
    end
end