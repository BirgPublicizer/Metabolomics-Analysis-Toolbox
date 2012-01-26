function regions = deconvolve2(x,y,maxs,mins,bins,deconvolve_mask,regions)
% x (d x 1) and y (d x 1)

y = interpolate_zeros(x,y);

regions = determine_regions(x,y,maxs,mins,bins,regions);
done_mask = zeros(1,length(regions));
regions = determine_initial_baseline(regions);

% Fit the regions
regions = fit_regions(regions,deconvolve_mask,done_mask);

function regions = determine_initial_baseline(regions)
for r = 1:length(regions)
    regions{r}.baseline_lb = [min([0;regions{r}.y]);min([0;regions{r}.y])];
    regions{r}.baseline_ub = [max(regions{r}.y);max(regions{r}.y)];
    if r == 1
        x_baseline_BETA = [regions{r}.x(1);regions{r}.x(end)];
    else
        x_baseline_BETA = [regions{r-1}.x(1);regions{r}.x(end)];
    end
    regions{r}.baseline_BETA = [regions{r}.y(1);regions{r}.y(end)];
    regions{r}.baseline_options = {};
    regions{r}.baseline_options.x_baseline_BETA = x_baseline_BETA;
    regions{r}.baseline_options.x_all = regions{r}.x;
end

function regions = determine_regions(x,y,maxs,all_mins,bins,regions)
% Divide the problem up into regions
[num_bins,junk] = size(bins);
for b = 1:num_bins
    xwidth = x(1) - x(2);
    i = round((x(1)-bins(b,1))/xwidth) + 1;
    last = round((x(1)-bins(b,2))/xwidth) + 1;
    ixs = find(i <= maxs & maxs < last);
    sub_mins = all_mins(ixs,:);
    i = min([i,min(sub_mins)]); % Adjust the start to make sure we include the max
    last = max([last,max(sub_mins)]);
    sub_inxs = i:(last-1);
    xsub = x(i:last-1);
    ysub = y(i:last-1);
    % Now adjust sub_mins
    sub_maxs = maxs(ixs) - i  + 1;
    sub_mins = all_mins(ixs,:) - i  + 1;            
    if ~isempty(sub_maxs)
        [BETA0,lb,ub] = compute_initial_inputs(xsub,ysub,sub_maxs,sub_mins,1:length(xsub));
    else
        BETA0 = [];
        lb = [];
        ub = [];
    end
    regions{b}.x = xsub;
    regions{b}.y = ysub;
    regions{b}.BETA0 = BETA0;
    regions{b}.lb = lb;
    regions{b}.ub = ub;
    regions{b}.inxs = sub_inxs;
    regions{b}.maxs = maxs(ixs);
    regions{b}.sub_maxs = sub_maxs;
    regions{b}.num_maxima = length(BETA0)/4;
end