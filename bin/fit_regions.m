function regions = fit_regions(regions,deconvolve_mask,done_mask)
% Transform the data into structures that can be used in a parfor loop
lb = {};
ub = {};
BETA0 = {};
baseline_BETA = {};
y_peaks = {};
y_baseline = {};
x = {};
y = {};
baseline_lb = {};
baseline_ub = {};
num_maxima = {};
baseline_options = {};
rinxs = {};
for r = 1:length(regions)
    lb{r} = regions{r}.lb;
    ub{r} = regions{r}.ub;
    baseline_lb{r} = regions{r}.baseline_lb;
    baseline_ub{r} = regions{r}.baseline_ub;
    BETA0{r} = regions{r}.BETA0;
    baseline_BETA{r} = regions{r}.baseline_BETA;
    x{r} = regions{r}.x;
    y{r} = regions{r}.y;
    num_maxima{r} = regions{r}.num_maxima;
    baseline_options{r} = regions{r}.baseline_options;
    rinxs{r} = regions{r}.inxs;
end

% Fit each region
parfor r = 1:length(regions)
    if ~done_mask(r)
        if deconvolve_mask(r)% || (r > 1 && deconvolve_mask(r-1)) || (r < length(regions) && deconvolve_mask(r+1))
            % Check for equal upper and lower bounds in the X direction
            if ~isempty(find(lb{r}(4:4:end) == ub{r}(4:4:end)))
                xwidth = x{r}(1)-x{r}(2);
                inxs = find(lb{r}(4:4:end) == ub{r}(4:4:end));
                lb{r}(4*inxs) = lb{r}(4*inxs) - xwidth /2;
                ub{r}(4*inxs) = ub{r}(4*inxs) + xwidth /2;
            end
            % Check for equal upper and lower bounds in the baseline lb/ub
            if ~isempty(find(baseline_lb{r} == baseline_ub{r}))
                inxs = find(baseline_lb{r} == baseline_ub{r});
                baseline_lb{r} = baseline_lb{r}(inxs) - 0.0000001;
                baseline_ub{r} = baseline_ub{r}(inxs) + 0.0000001;
            end
%             if r > 1 && r < length(regions)
%                 inxs_to_fit = [rinxs{r-1},rinxs{r},rinxs{r+1}];
%                 x_to_fit = [x{r-1};x{r};x{r+1}];
%                 y_to_fit = [y{r-1};y{r};y{r+1}];
%             elseif r == 1
%                 inxs_to_fit = [rinxs{r},rinxs{r+1}];
%                 x_to_fit = [x{r};x{r+1}];
%                 y_to_fit = [y{r};y{r+1}];                
%             else
%                 inxs_to_fit = [rinxs{r},rinxs{r+1}];
%                 x_to_fit = [x{r};x{r+1}];
%                 y_to_fit = [y{r-1};y{r}];                
%             end
            x_to_fit = x{r};
            y_to_fit = y{r};
            inxs_to_fit = rinxs{r};
            prev_y_bin = global_model(BETA0{r},x_to_fit,length(BETA0{r})/4,{});          
            try
                [BETA,EXITFLAG] = curve_fit(x_to_fit,y_to_fit,1:length(x_to_fit),[BETA0{r};baseline_BETA{r}],...
                    [lb{r};baseline_lb{r}],[ub{r};baseline_ub{r}],num_maxima{r},baseline_options{r});
            catch ME % Ignoring any errors for now               
                BETA = [BETA0{r};baseline_BETA{r}]; % Use previous
            end
            y_fit_r = global_model(BETA,x{r},num_maxima{r},baseline_options{r});
            % figure; plot(regions{r}.x,regions{r}.y,regions{r}.x,y_fit_r)
            y_fit{r} = y_fit_r;
            BETA0{r} = BETA(1:4*num_maxima{r});
            baseline_BETA{r} = BETA((4*num_maxima{r}+1):end);
            y_peaks{r} = global_model(BETA0{r},regions{r}.x,num_maxima{r},{});
            y_baseline{r} = global_model(baseline_BETA{r},x{r},0,baseline_options{r});
        end
    end
end

% Update the regions
for r = 1:length(regions)
    if ~done_mask(r)
        if deconvolve_mask(r)% || (r > 1 && deconvolve_mask(r-1)) || (r < length(regions) && deconvolve_mask(r+1))
            regions{r}.BETA0 = BETA0{r};
            regions{r}.baseline_BETA = baseline_BETA{r};
            regions{r}.y_fit = y_fit{r};
            regions{r}.y_peaks = y_peaks{r};
            regions{r}.y_baseline = y_baseline{r};
            regions{r}.lb = lb{r};
            regions{r}.ub = ub{r};
            regions{r}.baseline_lb = baseline_lb{r};
            regions{r}.baseline_ub = baseline_ub{r};
        end
    end
end

% function y = interpolate_zeros(x,y)
% % Construct a special y for the optimization, where the zero regions
% % are interpolated
% xs = [];
% ys = [];
% xi = [];
% inxs = [];
% for i = 2:length(y) % assume first is not zero
%     if y(i) == 0
%         xi(end+1) = x(i);
%         inxs(end+1) = i;
%         if isempty(xs)
%             xs(end+1) = x(i-1);
%             ys(end+1) = y(i-1);
%         end
%     elseif ~isempty(xi)
%         xs(end+1) = x(i);
%         ys(end+1) = y(i);
%         y(inxs) = interp1(xs,ys,xi,'linear');
%         xi = [];
%         inxs = [];
%         ys = [];
%         xs = [];
%     end
% end