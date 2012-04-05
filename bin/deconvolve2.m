function [regions,file_link,calculate_async_id] = deconvolve2(x,y,maxs,mins,bins,deconvolve_mask,regions,decon_xbuffer,baseline_xwidth,positive_baseline_constraint,to_the_cloud)
% x (d x 1) and y (d x 1)

y = interpolate_zeros(x,y);

regions = determine_regions(x,y,maxs,mins,bins,regions,decon_xbuffer);
regions = determine_initial_baseline(regions,baseline_xwidth,positive_baseline_constraint);
if ~to_the_cloud
    regions = fit_regions(regions,deconvolve_mask);
else
    output = output_regions(regions,deconvolve_mask);
    file_link = urlread('http://birg.cs.wright.edu/NMR-Webservice/upload/process_file.plain','post',{'file_as_string',output});
    calculate_async_id = urlread('http://birg.cs.wright.edu/NMR-Webservice/deconvolution/calculate_async.plain','post',{'filename',file_link,'mapred.map.tasks','10'});
end

function regions = determine_initial_baseline(regions,baseline_xwidth,positive_baseline_constraint)
for r = 1:length(regions)
    x = regions{r}.x;
    y = regions{r}.y;
    if ~isempty(baseline_xwidth) && ~isnan(baseline_xwidth)
        num_baseline_points = max([round((x(1)-x(end))/baseline_xwidth),2]);
    else
        num_baseline_points = 2;
    end
    
    if positive_baseline_constraint
        regions{r}.baseline_lb = 0*ones(num_baseline_points,1);
    else
        regions{r}.baseline_lb = min([y;0])*ones(num_baseline_points,1);
    end
    regions{r}.baseline_ub = max(y)*ones(num_baseline_points,1);    
    x_baseline_BETA = linspace(x(1),x(end),num_baseline_points);
    inxs = round(linspace(1,length(x),num_baseline_points));
    regions{r}.baseline_BETA = y(inxs);
    regions{r}.baseline_options = {};
    regions{r}.baseline_options.x_baseline_BETA = x_baseline_BETA;
    regions{r}.baseline_options.x_all = regions{r}.x;
end

function regions = determine_regions(x,y,maxs,all_mins,bins,regions,decon_xbuffer)
% Divide the problem up into regions
[num_bins,junk] = size(bins);
for b = 1:num_bins
    left_bin = bins(b,1) + decon_xbuffer;
    right_bin = bins(b,2) - decon_xbuffer;
    xwidth = x(1) - x(2);
    i = round((x(1)-left_bin)/xwidth) + 1;
    last = round((x(1)-right_bin)/xwidth) + 1;
    ixs = find(i <= maxs & maxs < last);
    sub_mins = all_mins(ixs,:);
    if ~isempty(sub_mins)
        i = min([i,min(sub_mins)]); % Adjust the start to make sure we include the max
        last = max([last,max(sub_mins)]);
    end
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
    regions{b}.region_inx = b;
end