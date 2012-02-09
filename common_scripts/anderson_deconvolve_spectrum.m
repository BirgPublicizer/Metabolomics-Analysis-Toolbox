function new_collection = anderson_deconvolve_spectrum(collection, s, ...
    min_width, max_width, num_iterations, baseline_width, x_limits)
%Deconvolves spectrum s in the given collection, returning the collection
%with the fields for spectrum s set appropriately - new fields are:
% x_baseline_BETA 
% baseline_BETA
% y_baseline 
% y_fit
% dirty
%
% Things will not be recalculated unless dirty(s) is set to true on entry
% or the array dirty(s) is not a field.
%
% collection the collection from which the spectrum comes.  maxs and mins must be fields of collection
%
% min_width the minimum width in x values of the segments into which to divide the
%           spectrum for processing
%
% max_width the maximum width in x valuse for the processing segments
%
% num_iterations - number of iterations to run the algorithm for
%
% baseline_width - I'm not sure what this does.  Glancing at the code,
%                  My guess is that it is the distance between the control 
%                  points for the baseline height.
%
% x_limits - the x bounds over-which to compute the deconvolution - as they
%            would be returned by the command xlim with no arguments
if ~isfield(collection,'maxs')
    uiwait(msgbox('Find peaks before running deconvolution'));
    return
end

% First deconvolution - add deconvolution fields
if isempty(find(collection.BETA{1}(1:4:end) ~= 0, 1))
    collection.x_baseline_BETA = {};
    collection.baseline_BETA = {};
    collection.y_baseline = {};
    collection.y_fit = {};
    collection.dirty = [];
    collection.dirty(1:length(collection.BETA)) = true;
end

% Perform deconvolution
x = collection.x;
xwidth = collection.x(1) - collection.x(2);
maxs = round((x(1) - collection.BETA{s}(4:4:end)')/xwidth)+1;
if ~collection.dirty(s) % Check if anything changed
    append_to_log(handles,sprintf('No deconvolution required for spectrum %d/%d',s,num_spectra));
    return;
end
% A peak has been added
prev_BETA = collection.BETA{s};
prev_maxs = maxs;
if length(maxs) ~= length(collection.maxs{s}) && ~isempty(maxs)
    collection.BETA{s} = []; % Reinitialize
end
options = {};
options.min_width = min_width/xwidth;
options.max_width = max_width/xwidth;
options.num_iterations = num_iterations;
% Only optimize those peaks within the current zoom
xl = x_limits;
X = collection.x(collection.maxs{s});
m_inxs = find(xl(1) <= X & X <= xl(2));
if ~isempty(m_inxs)
    stdin = create_hadoop_input(collection.x',collection.Y(:,s),collection.maxs{s}(m_inxs),collection.mins{s}(m_inxs,:),[],options);
    stdin = mapper(stdin,[]);
    options = {};
    options.baseline_width = baseline_width;
    options.min_width = min_width/xwidth;
    options.max_width = max_width/xwidth;
    options.num_generations = 100;
    o_inxs = find(collection.x(prev_maxs) < xl(1) | collection.x(prev_maxs) > xl(2)); % Find only those outside of the region
    o_prev_BETA = [];
    for q = 1:length(o_inxs)
        o_prev_BETA = [o_prev_BETA;prev_BETA(4*(o_inxs(q)-1)+(1:4))];
    end
    results = reducer(collection.x',collection.Y(:,s),stdin,o_prev_BETA,collection.x(prev_maxs(o_inxs)),options);
    collection.BETA{s} = results.BETA;
    collection.y_fit{s} = results.solution.y_fit;
    collection.x_baseline_BETA{s} = results.x_baseline_BETA;
    collection.y_baseline{s} = results.y_baseline;
    collection.dirty(s) = false;
    
    % Update the max indices
    collection.maxs{s} = round((x(1) - collection.BETA{s}(4:4:end)')/xwidth)+1;
    
    %append_to_log(handles,sprintf('Finished spectrum %d/%d',s,num_spectra));
else
    %append_to_log(handles,sprintf('No peaks within current zoom for spectrum %d/%d',s,num_spectra));
end
    
new_collection = collection;

%refresh_axes2(handles);
%append_to_log(handles,sprintf('Finished deconvolution'));

function output = create_hadoop_input(x,y,all_maxs,all_mins,outfile,options)
% x (d x 1) and y (d x 1)
% e.g., outfile = 'hadoop_output.txt'
if ~exist('options')
    options = {};
    options.min_width = 30;
    options.max_width = 70;
    options.num_iterations = 3;
end
if ~isempty(outfile)
    fid = fopen(outfile,'w');
end
output = '';

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

mins = all_mins;
biggest_gap = max(abs(mins(:,1)-mins(:,2)));
mins = mins(:,1);
for iter = 1:options.num_iterations
    i = 1;
    regions = {};
    r = 1;
    while (i <= length(x))
        width = randi([options.min_width,options.max_width]);
        inxs = find(i < mins & mins <= i+width); % Find mins within range
        if isempty(inxs)
            width = biggest_gap;
            inxs = find(i < mins & mins <= i+width); % Find mins within range
        end
        if isempty(inxs) % Does not contain a max
            last = i+width;
        else
            [v,inx] = min(y(mins(inxs)));
            last = mins(inxs(inx));
        end
        if (last >= length(x))
            last = length(x);
        end
        xsub = x(i:last);
        ysub = y(i:last);
        
        ixs = find(i <= all_maxs & all_maxs <= last);
        sub_maxs = all_maxs(ixs) - i  + 1;
        sub_mins = all_mins(ixs,:) - i  + 1;            
        if ~isempty(sub_maxs)
            [BETA0,lb,ub] = compute_initial_inputs(xsub,ysub,sub_maxs,sub_mins,1:length(xsub));
        else
            BETA0 = [];
            lb = [];
            ub = [];
        end
        regions{r} = {};
        regions{r}.x = xsub;
        regions{r}.y = ysub;
        regions{r}.BETA0 = BETA0;
        regions{r}.lb = lb;
        regions{r}.ub = ub;
        
        i = last + 1;
        r = r + 1;
    end
    
    all_peaks_X = [];
    for r = 1:length(regions)        
        if isempty(regions{r}.BETA0) % Nothing in this region
            continue;
        end
        all_peaks_X = [all_peaks_X;regions{r}.BETA0(4:4:end)];
        if r == 1
            eval_str = sprintf(['x_r=%s;y_r=%s;BETA0_r=%s;lb_r=%s;ub_r=%s;',...
                'x_a=%s;y_a=%s;BETA0_a=%s;lb_a=%s;ub_a=%s;'],...
                mat2str(regions{r}.x'),mat2str(regions{r}.y'),mat2str(regions{r}.BETA0'),mat2str(regions{r}.lb'),mat2str(regions{r}.ub'),...
                mat2str(regions{r+1}.x'),mat2str(regions{r+1}.y'),mat2str(regions{r+1}.BETA0'),mat2str(regions{r+1}.lb'),mat2str(regions{r+1}.ub'));
        elseif r == length(regions)
            eval_str = sprintf(['x_b=%s;y_b=%s;BETA0_b=%s;lb_b=%s;ub_b=%s;',...
                'x_r=%s;y_r=%s;BETA0_r=%s;lb_r=%s;ub_r=%s;'],...
                mat2str(regions{r-1}.x'),mat2str(regions{r-1}.y'),mat2str(regions{r-1}.BETA0'),mat2str(regions{r-1}.lb'),mat2str(regions{r-1}.ub'),...
                mat2str(regions{r}.x'),mat2str(regions{r}.y'),mat2str(regions{r}.BETA0'),mat2str(regions{r}.lb'),mat2str(regions{r}.ub'));
        else
            eval_str = sprintf(['x_b=%s;y_b=%s;BETA0_b=%s;lb_b=%s;ub_b=%s;',...
                'x_r=%s;y_r=%s;BETA0_r=%s;lb_r=%s;ub_r=%s;',...
                'x_a=%s;y_a=%s;BETA0_a=%s;lb_a=%s;ub_a=%s;'],...
                mat2str(regions{r-1}.x'),mat2str(regions{r-1}.y'),mat2str(regions{r-1}.BETA0'),mat2str(regions{r-1}.lb'),mat2str(regions{r-1}.ub'),...
                mat2str(regions{r}.x'),mat2str(regions{r}.y'),mat2str(regions{r}.BETA0'),mat2str(regions{r}.lb'),mat2str(regions{r}.ub'),...
                mat2str(regions{r+1}.x'),mat2str(regions{r+1}.y'),mat2str(regions{r+1}.BETA0'),mat2str(regions{r+1}.lb'),mat2str(regions{r+1}.ub'));
        end
        if ~isempty(outfile)
            fprintf(fid,'s=%d;r=%d;iter=%d;num_regions=%d',1,r,iter,length(regions));
            fprintf(fid,'\t');
            fprintf(fid,'%s',eval_str);
            fprintf(fid,'\n');
        end
        output = sprintf('%ss=%d;r=%d;iter=%d;num_regions=%d\t%s\n',output,1,r,iter,length(regions),eval_str);
    end
%     fprintf('%d\t\t%s\n',iter,mat2str(all_peaks_X));
end
if ~isempty(outfile)
    fclose(fid);
end

function output = mapper(stdin,outfile)
data = process_stdin(stdin);
output = '';

% Loop through each region
for inx = 1:length(data)
  data{inx}.new_eval_strs = {};
  data{inx}.lb = {};
  data{inx}.ub = {};
  data{inx}.x = {};
  data{inx}.y = {};
  data{inx}.BETA0 = {};
  data{inx}.num_maxima = {};
  data{inx}.x_baseline_BETA = {};
  for j = 1:length(data{inx}.eval_strs) % Could be more than 1 but for now there is only 1
    % Core of the algorithm
    eval_str = data{inx}.eval_strs{j};
    eval(eval_str);
    r = data{inx}.r;
    if r == 1
        num_maxima = length(BETA0_r)/4 + length(BETA0_a)/4;
        x = [x_r';x_a'];
        y = [y_r';y_a'];
        BETA0 = [BETA0_r';BETA0_a';y_r(1);y_a(1);y_a(end)]; %#ok<COLND>
        x_baseline_BETA = [x_r(1);x_a(1);x_a(end)]; %#ok<COLND>
        lb = [lb_r';lb_a';0;0;0];
        ub = [ub_r';ub_a';max(y);max(y);max(y)];
    elseif r == data{inx}.num_regions
        num_maxima = length(BETA0_b)/4 + length(BETA0_r)/4;
        x = [x_b';x_r'];
        y = [y_b';y_r'];
        BETA0 = [BETA0_b';BETA0_r';y_b(1);y_r(1);y_r(end)]; %#ok<COLND>
        x_baseline_BETA = [x_b(1);x_r(1);x_r(end)]; %#ok<COLND>
        lb = [lb_b';lb_r';0;0;0];
        ub = [ub_b';ub_r';max(y);max(y);max(y)];
    else
        num_maxima = length(BETA0_b)/4 + length(BETA0_r)/4 + length(BETA0_a)/4;
        x = [x_b';x_r';x_a'];
        y = [y_b';y_r';y_a'];
        BETA0 = [BETA0_b';BETA0_r';BETA0_a';y_b(1);y_r(1);y_a(1);y_a(end)]; %#ok<COLND>
        x_baseline_BETA = [x_b(1);x_r(1);x_a(1);x_a(end)]; %#ok<COLND>
        lb = [lb_b';lb_r';lb_a';0;0;0;0];
        ub = [ub_b';ub_r';ub_a';max(y);max(y);max(y);max(y)];
    end
    data{inx}.lb{j} = lb;
    data{inx}.ub{j} = ub;
    data{inx}.x{j} = x;
    data{inx}.y{j} = y;
    data{inx}.BETA0{j} = BETA0;
    data{inx}.num_maxima{j} = num_maxima;
    data{inx}.x_baseline_BETA{j} = x_baseline_BETA;
  end
end
parfor inx = 1:length(data)
  for j = 1:length(data{inx}.eval_strs) % Could be more than 1 but for now there is only 1
    [data{inx}.new_eval_strs{j},y_fit] = perform_deconvolution(data{inx}.x{j},data{inx}.y{j},data{inx}.BETA0{j},...
        data{inx}.lb{j},data{inx}.ub{j},data{inx}.num_maxima{j},data{inx}.x_baseline_BETA{j});
  end
end

% Output results
if exist('outfile') && ~isempty(outfile)
    fid = fopen(outfile,'w');
end
for inx = 1:length(data)
    r = data{inx}.r;
    for j = 1:length(data{inx}.eval_strs) % For now only 1      
        eval_str = data{inx}.eval_strs{j};
        eval(eval_str);    
        orig_BETA = BETA0_r;
        if r == 1
            region_inxs = 1:length(BETA0_r);
        elseif r == data{inx}.num_regions
            region_inxs = (length(BETA0_b)+1):(length(BETA0_b)+length(BETA0_r));
        else
            region_inxs = (length(BETA0_b)+1):(length(BETA0_b)+length(BETA0_r));
        end    
        eval(data{inx}.new_eval_strs{j});
        new_BETA = BETA(region_inxs);
        for p = 1:length(new_BETA)/4
            new_res_str = sprintf('%f\t%s\n',orig_BETA(4*(p-1)+4),mat2str(new_BETA(4*(p-1)+(1:4))));
            if exist('outfile') && ~isempty(outfile)
                fprintf(fid,new_res_str);
            elseif ~exist('outfile');
                fprintf(new_res_str);
            else
                output = sprintf('%s%s',output,new_res_str);
            end
        end
    end
end
if exist('outfile') && ~isempty(outfile)
    fclose(fid);
end

function results = reducer(x,y,stdin,prev_BETA,prev_x_maxs,options)
if ~exist('options')
    options = {};
    options.baseline_width = 0.01;    
    options.max_width = 70;
    options.num_generations = 100;
end
data = process_stdin_mapper(stdin);
if ~isempty(prev_BETA)    
    peaks_to_add = [];
    for i = 1:length(prev_x_maxs)
        found = false;
        for k = 1:length(data)
            if strcmp(num2str(data{k}.key),num2str(prev_x_maxs(i)))
                found = true;
                break;
            end
        end
        if ~found
            peaks_to_add(end+1) = i;
        end
    end
    for j = 1:length(peaks_to_add)
        i = peaks_to_add(j);
        data{end+1} = data{end}; % Make copy first
        data{end}.key = prev_x_maxs(i);
        for z = 1:length(data{end}.BETAs)
            data{end}.BETAs{z} = prev_BETA(4*(i-1)+(1:4));
        end
    end
end

xwidth = x(1)-x(2);
baseline_width_inx = round(options.baseline_width/xwidth);
x_baseline_BETA = x(1:baseline_width_inx:end);
if x_baseline_BETA ~= x(end)
    x_baseline_BETA(end+1) = x(end);
end
baseline_BETA = 0*x_baseline_BETA;

num_peaks = length(data);
keys = zeros(1,num_peaks);
for k = 1:length(data)
    keys(k) = data{k}.key;
end
[sorted_keys,sorted_key_inxs] = sort(keys,'descend');
num_iterations = length(data{1}.BETAs);

% Precompute peaks
peaks = cell(length(data{1}.BETAs),length(keys));
peak_locs = zeros(1,length(keys));
for k = 1:length(sorted_key_inxs)
    inx = sorted_key_inxs(k);
    peak_locs(k) = sorted_keys(k);
    for p = 1:length(data{inx}.BETAs);
        peaks{p,k} = one_peak_model(data{inx}.BETAs{p},x);
    end
end

% Initialize a random solution
solution = {};
solution.pinxs = zeros(1,num_peaks);
for k = 1:num_peaks
    solution.pinxs(k) = randi([1,num_iterations]);
end

% Construct initial y_peaks
for k = 1:length(solution.pinxs)
    if k == 1
        y_peaks = peaks{solution.pinxs(k),k};
    elseif ~isempty(peaks{solution.pinxs(k),k}) % Sometimes there is a failure
        y_peaks = y_peaks + peaks{solution.pinxs(k),k};
    end
end

% Construct baseline matrices
lambda = 20;
xwidth = x(1)-x(2);
inxs = round((x(1) - x_baseline_BETA)/xwidth) + 1;
     
% Weights (0 = ignore this intensity)
w = zeros(size(y));
w(inxs) = 1;
% Matrix version of W
W = sparse(length(y),length(y));
for i = 1:length(w)
    W(i,i) = w(i);
end
% Difference matrix (they call it derivative matrix, which a little
% misleading)
D = sparse(length(y),length(y));
for i = 1:length(y)-1
    D(i,i) = 1;
    D(i,i+1) = -1;
end

A = W + lambda*D'*D;

% Construct a special y for the fitness function, where the zero regions
% are interpolated
xs = [];
ys = [];
xi = [];
inxs = [];
y_for_fitness = y;
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
        y_for_fitness(inxs) = interp1(xs,ys,xi,'linear');
        xi = [];
        inxs = [];
        ys = [];
        xs = [];
    end
end

[solution,y_baseline] = fitness(solution,y_for_fitness,y_peaks,A,W);

% Define the regions
i = 1;
regions = {};
r = 1;
while (i <= length(x))
    width = options.max_width;
    last = i+width;
    if (last >= length(x))
        last = length(x);
    end

    regions{r} = {};
    regions{r}.peak_inxs = find(x(i) >= peak_locs & peak_locs >= x(last));

    i = last + 1;
    r = r + 1;
end

% Now optimize two regions at a time, keeping the region on the left
for r = 1:length(regions)-1    
    peak_inxs = [regions{r}.peak_inxs,regions{r+1}.peak_inxs];
    prev_num_changed = NaN;
%     fprintf('Region %d/%d\n',r,length(regions));
    if ~isempty(peak_inxs)
        for g = 1:options.num_generations
%             fprintf('Generation %d\n',g);
            order_inxs = randperm(length(peak_inxs)); % Randomly pick the order to change the peaks
            num_changed = 0;
            for i = 1:length(order_inxs)
                k = peak_inxs(order_inxs(i));
                scores = zeros(1,num_iterations);
                temps = cell(1,num_iterations);
                for j = 1:num_iterations
                    temp = solution;
                    if temp.pinxs(k) ~= j % Don't need to check
                        temp.pinxs(k) = j;
                        y_peaks = y_peaks - peaks{solution.pinxs(k),k}; % Remove previous
                        y_peaks = y_peaks + peaks{temp.pinxs(k),k}; % Add new peak
                        [temp,y_baseline] = fitness(temp,y_for_fitness,y_peaks,A,W);
                        y_peaks = y_peaks - peaks{temp.pinxs(k),k}; % Remove new peak
                        y_peaks = y_peaks + peaks{solution.pinxs(k),k}; % Add previous back
                    end
                    scores(j) = temp.r2;
                    temps{j} = temp;
                end
                [v,ix] = max(scores);
                if ix ~= solution.pinxs(k) % New solution
                    solution = temps{ix};
                    num_changed = num_changed + 1;
                end
            end
            if num_changed == 0 && prev_num_changed == 0
                break;
            else
                prev_num_changed = num_changed;
            end
        end 
    end
end


results = {};
results.solution = solution;
BETA = [];
for k = 1:length(sorted_key_inxs)
    inx = sorted_key_inxs(k);
    BETA = [BETA;data{inx}.BETAs{solution.pinxs(inx)}];
end
results.BETA = BETA;
results.x_baseline_BETA = x_baseline_BETA;
results.y_baseline = y_baseline;

fprintf('r2: %.4f\n',solution.r2);

