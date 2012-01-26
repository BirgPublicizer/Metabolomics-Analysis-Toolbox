function [y_peaks, y_baseline] = regions_to_global(regions,x,y)
y_peaks = 0*y;
y_baseline = 0*y;
for r = 1:length(regions)
    inxs = regions{r}.inxs;
    y_baseline(inxs) = global_model(regions{r}.baseline_BETA,x(inxs),0,regions{r}.baseline_options);
    if regions{r}.num_maxima > 0
        y_peaks(inxs) = global_model(regions{r}.BETA0,x(inxs),regions{r}.num_maxima,{});
    end
end

