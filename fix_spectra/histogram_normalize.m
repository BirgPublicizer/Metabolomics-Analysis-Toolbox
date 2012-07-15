function collections = histogram_normalize(collections, baseline_pts, n_std_dev, num_bins, use_waitbar)
% Applies Torgrip's histogram normalization to the spectra 
%
% collections = HISTOGRAM_NORMALIZE(collections, baseline_pts, std_dev, num_bins, use_waitbar)
%
% Uses the algorithm from "A note on normalization of biofluid 1D 1H-NMR
% data" by R. J. O. Torgrip, K. M. Aberg, E. Alm, I. Schuppe-Koistinen and
% J. Lindberg published in Metabolomics (2008) 4:114–121, 
% DOI 10.1007/s11306-007-0102-2
%
% To normalize nmr spectra.
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% collections  - a cell array of spectral collections. Each spectral
%                collection is a struct. This is the format
%                of the return value of load_collections.m in
%                common_scripts. All collections must use the same set of x
%                values. Check with only_one_x_in.m
%
% baseline_pts - the number of points to use at the beginning of each
%                spectrum to estimate the standard deviation of the noise.
%                Must be at least 2.
%
% n_std_dev    - all samples less than n_std_dev * noise_standard_deviation
%                are ignored in creating the histogram. Must be
%                non-negative.
%
% num_bins     - the number of bins to use in the histogram must be at
%                least 1
%
% use_waitbar  - if true then a waitbar is displayed during processing.
%                Must be a logical.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% collections - the collections after normalization. The processing log is
%               updated and the histograms are all multiplied by their
%               respective dilution factors.
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> collections = histogram_normalize(collections, 30, 5, 60, true)
%
% Uses histogram normalization on the spectra in collections. It creates
% an estimate of the noise standard deviation from the first 30 points in 
% each spectrum. Then it excludes all points in a spectrum that have an 
% intensity less than 5 standard deviations above 0. Finally it bins
% the intensities into 60 bins and uses a waitbar to report progress to 
% the user.
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%

function expurgated = remove_values(values, baseline_pts, n_std_dev)
    % Return an array of the entries in values that were more than 
    % n_std_dev standard deviations above 0. The size of one standard
    % deviation is calcualted from the first baseline_pts entries in
    % values. 
    %
    % values must have at least baseline_pts entries.
    %
    % baseline_pts must be a scalar
    %
    % n_std_dev must be a scalar
    
    assert(length(values) >= baseline_pts);
    dev = std(values(1:baseline_pts));
    expurgated = values(values > n_std_dev*dev);
end

function err_v = err(mult, values, y_bins, ref_histogram)
    % Returns the sum of squared differences between the histogram of 
    % values*mult using y_bins and ref_histogram.
    h = histc(mult.*values, y_bins);
    diffs = h-ref_histogram;
    err_v = sum(diffs.^2);
end

function mult = best_mult_for(values, y_bins, ref_histogram, min_y, max_y)
    % Return the multiplier that minimizes the sum of squared differences
    % between the histogram of values*mult using y_bins and ref_histogram.
    %
    % The search looks at all values between (min_y/max_y) and
    % (max_y/min_y). 0 < min_y <= max_y
    
    % Initialize the search bounds to (min_y/max_y) and (max_y/min_y).
    low_b = min_y/max_y;
    up_b  = max_y/min_y;
    
    % Now, tighten the search bounds because fminbnd does not do well
    % searching for optima when there are large flat spaces in the upper
    % part of the search range (probably in the lower part as well).
    
    % Make a list of the errors at multipliers low_b, low_b*2,
    % low_b * 4 ... first_element_in_this_series_greater_than_up_b
    num_steps = ceil(log2(up_b/low_b));
    bound_mults = low_b.*(2.^(0:num_steps));
    errs = arrayfun(@(m) err(m, values, y_bins, ref_histogram), ...
        bound_mults);
    
    % Get the indices of the two elements that bound the first interval of minimum error
    min_err_idx = find(errs == min(errs),1,'first');
    low_b_idx = find(errs(1:min_err_idx-1) > errs(min_err_idx),1,'last');
    if isempty(low_b_idx)
        % All previous elements equal to the minimum - or there were no
        % previous elements
        low_b_idx = 1;
    end
    up_b_idx = find(errs(min_err_idx+1:end) > errs(min_err_idx),1,'first');
    if isempty(up_b_idx)
        up_b_idx = length(errs);
    else
        up_b_idx = up_b_idx + min_err_idx;
    end
    
    % Make those two elements the new search bounds if they are tighter
    if bound_mults(up_b_idx) < up_b
        up_b = bound_mults(up_b_idx);
    end
    if bound_mults(low_b_idx) > low_b
        low_b = bound_mults(low_b_idx);
    end
    
    mult = fminbnd(@(mult) err(mult, values, y_bins, ref_histogram), ...
       low_b , up_b);
end

if baseline_pts < 2
    error('histogram_normalize:two_baseline',['You must use at least '...
        'two baseline points to estimate the noise standard deviation.']);
end

if num_bins < 1
    error('histogram_normalize:one_bin',['You must use at least '...
        'one histogram bin in histogram normalization.']);
end

if n_std_dev < 0
    error('histogram_normalize:nonneg_std',['n_std_dev '...
        'parameter cannot be negative.']);
end

if use_waitbar; 
    wait_h = waitbar(0,'Initializing histogram normalization'); 
else
    wait_h = -1;
end

% Calculate the reference spectrum
all_spectra = cellfun(@(in) true(in.num_samples,1), collections, 'UniformOutput', false);
ref_spectrum = median_spectrum(collections, all_spectra);
ref_values = remove_values(ref_spectrum.Y, baseline_pts, n_std_dev);

% Calculate the y-values we will histogram y{i} is the values remaining 
% from the i'th spectrum, where the first spectrum is collection{1}.Y(:,1)
% and you continue increasing the spectrum number until you run out of
% spectra in the collection, at which point, you go through the spectra in
% the next collection.
y=cell(num_spectra_in(collections), 1);
cur = 1;
for c=1:length(collections)
    if use_waitbar; waitbar(0.1*(c-1)/length(collections),...
            wait_h, 'Removing baseline points'); end
    for s=1:collections{c}.num_samples
        y{cur}=remove_values(collections{c}.Y(:,s), ...
            baseline_pts, n_std_dev);
        cur=cur+1;
    end
end

% Calculate histogram edges. Note that rather than taking the log(y+1) each
% iteration, I move the histogram edges according to the inverse of this
% function. edge=2^edge-1. This means that we are not translating the y
% values anymore (I'd have to change this if I wanted to use the fourier
% autocorrelation trick, for example) but we are only doing multiplications
% each time through the main optimization loop - and multiplications are
% faster than additions for floating point.
min_y = min(ref_values); % Calculate the bounds of the histogram based on the reference spectrum
max_y = max(ref_values);
assert(min_y > 0);
assert(max_y >= min_y);
min_z = log2(min_y+1); %z values are those transformed into logarithmic space
max_z = log2(max_y+1); 
z_bins = linspace(min_z, max_z, num_bins+1);
y_bins = (2.^z_bins)-1;
y_bins(1) = -inf;
y_bins(end) = inf;

% Calculate the multipliers
ref_histogram = histc(ref_values, y_bins);
multipliers = zeros(length(y), 1);
for cur = 1:length(y)
    if use_waitbar
        waitbar(0.1+0.85*(cur-1)/length(y), wait_h, 'Calcuating multipliers'); 
    end

    multipliers(cur)=best_mult_for(y{cur}, y_bins, ref_histogram, min_y, max_y);
end

% Scale the spectra
collections = ensure_original_multiplied_by_field(collections);
cur = 1;
for c=1:length(collections)
    if use_waitbar
        waitbar(0.95+0.05*(c-1)/length(collections), wait_h, 'Scaling spectra'); 
    end
    collections{c}.processing_log = sprintf([...
        '%s  Histogram normalized with %d bins using the first ' ...
        '%d points for a noise estimate and excluding points with an ' ...
        'intensity less than %g noise standard deviations above 0.'], ...
        collections{c}.processing_log, num_bins, baseline_pts, n_std_dev);
    for s=1:collections{c}.num_samples
        collections{c}.Y(:,s)=multipliers(cur)*collections{c}.Y(:,s);
        collections{c}.original_multiplied_by(s)=...
            multipliers(cur)*collections{c}.original_multiplied_by(s);
        cur = cur + 1;
    end
end

if use_waitbar; delete(wait_h); end;


end