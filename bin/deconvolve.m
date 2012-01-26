function results = deconvolve(x,y,maxs,mins,bins,deconvolve_mask,options)
% x (d x 1) and y (d x 1)
if ~exist('options')
    options = {};
end

y = interpolate_zeros(x,y);

regions = determine_regions(x,y,maxs,mins,bins);

% Determine the y_peaks
BETA = [];
for r = 1:length(regions)
    BETA = [BETA;regions{r}.BETA0];
end
y_peaks = global_model(BETA,x,length(BETA)/4,{});

[ix_baseline_BETA,x_baseline_BETA,baseline_BETA,baseline_lb,baseline_ub] = determine_initial_baseline(x,y,regions,y_peaks);

% Create the initial baseline
baseline_options = {};
baseline_options.x_baseline_BETA = x_baseline_BETA;
baseline_options.x_all = x;
y_baseline = global_model(baseline_BETA,x,0,baseline_options);

r2 = 1 - sum((y_peaks+y_baseline - y).^2)/sum((mean(y) - y).^2);
fprintf('r2: %f\n',r2);

max_generations = 2;
generation = 1;
while (true)
    % Calculate the y to fit for each region
    y_to_fit = y - y_baseline - y_peaks;
    for r = 1:length(regions)
        y_peaks_r = global_model(regions{r}.BETA0,regions{r}.x,regions{r}.num_maxima,{});    
        regions{r}.y = y_to_fit(regions{r}.inxs) + y_peaks_r;
    end

    regions = fit_regions(regions,deconvolve_mask);

%     figure;
%     hs = plot(x,y,x,y_baseline,x,y_to_fit + y_peaks);
    BETA = [];
    for r = 1:length(regions)
        if regions{r}.num_maxima > 0
            BETA = [BETA;regions{r}.BETA0];
        end
    end
    % Update the y_peaks
    y_peaks = global_model(BETA,x,length(BETA)/4,{});
%     hs(end+1) = line(x,y_peaks,'color','k');
%     hs(end+1) = line(x,y_peaks+y_baseline);
%     legend(hs,{'y','y-baseline','y to fit','y peaks','y fit'});
    
    % Update the baseline BETA values
    baseline_BETA = (baseline_BETA + y(ix_baseline_BETA)' - y_peaks(ix_baseline_BETA)')/2; % Take the average of the old baseline and the new baseline
    y_baseline = global_model(baseline_BETA,x,0,baseline_options);    
    
    r2 = 1 - sum((y_peaks+y_baseline - y).^2)/sum((mean(y) - y).^2);
    fprintf('r2: %f\n',r2);
    
    if generation >= max_generations
        break;
    end
    generation = generation + 1;
end

results = {};
results.BETA = BETA;
results.baseline_BETA = baseline_BETA;
results.x_baseline_BETA = x_baseline_BETA;
results.y_baseline = y_baseline;
results.y_fit = y_peaks + y_baseline;
results.y_peaks = y_peaks;
results.r2 = r2;
fprintf('Finished deconvolution');

function [ix_baseline_BETA,x_baseline_BETA,baseline_BETA,baseline_lb,baseline_ub] = determine_initial_baseline(x,y,regions,y_peaks)
y_residual = y - y_peaks;

x_baseline_BETA = x(1);
ix_baseline_BETA = 1;
baseline_BETA = y_residual(1);
baseline_lb = NaN;
baseline_ub = NaN;

for r = 2:2:length(regions)
    [v,ix] = min(regions{r}.y);
    ix_baseline_BETA(end+1) = regions{r}.inxs(ix);
    x_baseline_BETA(end+1) = regions{r}.x(ix);
    baseline_BETA(end+1) = y_residual(regions{r}.inxs(ix));
    baseline_lb(end+1) = min([0;regions{r}.y]);
    baseline_ub(end+1) = y_residual(regions{r}.inxs(ix));
end

ix_baseline_BETA(end+1) = length(x);
x_baseline_BETA(end+1) = x(end);
baseline_BETA(end+1) = y_residual(end);
baseline_lb(end+1) = NaN;
baseline_ub(end+1) = NaN;
    
function regions = fit_regions(regions,deconvolve_mask)
% Fit each region
for r = 1:length(regions)
    if regions{r}.num_maxima > 0
        if deconvolve_mask(r) || (r > 1 && deconvolve_mask(r-1)) || (r < length(regions) && deconvolve_mask(r+1))
            % Check for equal upper and lower bounds in the X direction
            if ~isempty(find(regions{r}.lb(4:4:end) == regions{r}.ub(4:4:end)))
                xwidth = regions{r}.x(1)-regions{r}.x(2);
                inxs = find(regions{r}.lb(4:4:end) == regions{r}.ub(4:4:end));
                regions{r}.lb(4*inxs) = regions{r}.lb(4*inxs) - xwidth /2;
                regions{r}.ub(4*inxs) = regions{r}.ub(4*inxs) + xwidth /2;
            end
            [BETA,EXITFLAG] = curve_fit(regions{r}.x,regions{r}.y,1:length(regions{r}.x),regions{r}.BETA0,...
                regions{r}.lb,regions{r}.ub,regions{r}.num_maxima,{});
            y_fit = global_model(BETA,regions{r}.x,regions{r}.num_maxima,{});
            % figure; plot(regions{r}.x,regions{r}.y,regions{r}.x,y_fit)
            regions{r}.y_fit = y_fit;
            regions{r}.BETA0 = BETA;
        end
    end
end

function y = interpolate_zeros(x,y)
% Construct a special y for the optimization, where the zero regions
% are interpolated
xs = [];
ys = [];
xi = [];
inxs = [];
for i = 2:length(y) % assume first is not zero
    if y(i) == 0
        xi(end+1) = x(i);
        inxs(end+1) = i;
        if isempty(xs)
            xs(end+1) = x(i-1);
            ys(end+1) = y(i-1);
        end
    elseif ~isempty(xi)
        xs(end+1) = x(i);
        ys(end+1) = y(i);
        y(inxs) = interp1(xs,ys,xi,'linear');
        xi = [];
        inxs = [];
        ys = [];
        xs = [];
    end
end

function regions = determine_regions(x,y,maxs,all_mins,bins)
% Divide the problem up into regions
regions = {};
[num_bins,junk] = size(bins);
for b = 1:num_bins
    xwidth = x(1) - x(2);
    i = round((x(1)-bins(b,1))/xwidth) + 1;
    last = round((x(1)-bins(b,2))/xwidth) + 1;
    sub_inxs = i:last;
    xsub = x(i:last);
    ysub = y(i:last);

    ixs = find(i <= maxs & maxs < last);
    sub_maxs = maxs(ixs) - i  + 1;
    sub_mins = all_mins(ixs,:) - i  + 1;            
    if ~isempty(sub_maxs)
        [BETA0,lb,ub] = compute_initial_inputs(xsub,ysub,sub_maxs,sub_mins,1:length(xsub));
    else
        BETA0 = [];
        lb = [];
        ub = [];
    end
    regions{b} = {};
    regions{b}.x = xsub;
    regions{b}.y = ysub;
    regions{b}.BETA0 = BETA0;
    regions{b}.lb = lb;
    regions{b}.ub = ub;
    regions{b}.inxs = sub_inxs;
    regions{b}.num_maxima = length(BETA0)/4;
end