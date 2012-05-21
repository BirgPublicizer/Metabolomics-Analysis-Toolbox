function bins = dynamic_adaptive_bin(x,Y,left_noise,right_noise,max_dist_btw_maxs_ppm,min_dist_from_boundary_ppm,peak_identification_options)
% Usage:
%  bins = dynamic_adaptive_bin(x,Y,left_noise,right_noise,max_dist_btw_maxs_ppm,min_dist_from_boundary_ppm)
%  Arguments:
%    x - d x 1 vector with chemical shift values in ppm
%    Y - d x n matrix of intensities for n spectra
%    left_noise,right_noise - define a region containing only noise in the spectrum (left_noise > right_noise, e.g., 11.6,11)
%    max_dist_btw_maxs_ppm - maximum distance between the observed peak in a single bin measured in ppm
%    min_dist_from_boundary_ppm - minimum distance between observed peaks and the nearest boundary
% Optional arguments:
%    peak_identification_options.noise_std_mult - noise multiplier for standard deviation thresholding
%    peak_identification_options.tptr - type 'help wden' for complete options
%    peak_identification_options.sorh - type 'help wden' for complete options
%    peak_identification_options.scal - type 'help wden' for complete options
%    peak_identification_options.wname - type 'help wden' for complete options
%  Output:
%    bins - b x 2 matrix describing the bin boundaries
%
%  Example:
%    load 'example.mat';
%    bins = dynamic_adaptive_bin(x,Y,9.5,9.45,0.08,0.001);
%    [num_variables, num_samples] = size(Y);
%    figure;
%    hold on
%    for i = 1:num_samples
%      plot(x,Y(:,i));
%    end
%    hold off
%    set(gca,'xdir','reverse');
%    xlabel('Chemical shift, ppm');
%    [nBins,cols] = size(bins);
%    for i = 1:nBins
%      line([bins(i,1),bins(i,1)],ylim,'Color','g');
%      line([bins(i,2),bins(i,2)],ylim,'Color','r');
%    end

if ~exist('peak_identification_options')
    peak_identification_options = {};
    peak_identification_options.tptr = 'rigrsure'; % 'rigrsure','heursure','sqtwolog', or 'minimaxi'
    peak_identification_options.level = 1;
    peak_identification_options.sorh = 's'; % 's', or 'h'
    peak_identification_options.scal = 'one'; % 'one', 'sln', or 'mln'
    peak_identification_options.wavelet = 'sym7'; % 'haar', 'db2', 'coif1', 'coif2', 'coif3', 'coif4', 'coif5', 'sym2', 'sym3', 'sym4', 'sym5', 'sym6', 'sym7', 'sym8'
    peak_identification_options.noise_std_mult = 5;
end

nm = size(Y);
num_samples = nm(2);
if num_samples < 1
    bins = [];
    return;
end

spectra = create_spectra(x,Y,left_noise,right_noise,peak_identification_options);

max_spectrum = Y(:,1)';
for s = 1:num_samples
    if s > 1
        max_spectrum = max([max_spectrum;Y(:,s)']);
    end
end

xwidth = abs(x(1)-x(2));
max_dist_btw_maxs = round(max_dist_btw_maxs_ppm/xwidth);
min_dist_from_boundary = round(min_dist_from_boundary_ppm/xwidth);

nm = size(Y);
if nm(2) == 1 % Only 1 sample
    y_sum = Y';
else
    y_sum = sum(abs(Y'));    
end
nonzero_inxs = find(y_sum ~= 0);
i = 1;
all_inxs = {};
while i <= length(nonzero_inxs)
    inxs = [];
    new_inxs = nonzero_inxs(i);
    while (length(new_inxs)-length(inxs)) == 1
        inxs = new_inxs;
        i = i + 1;
        if i > length(nonzero_inxs)
            break;
        end
        new_inxs = inxs(1):nonzero_inxs(i);
    end
    if ~isempty(inxs)
        all_inxs{end+1} = inxs;
    end
end

bins = [];
total_score = 0;
for i = 1:length(all_inxs)
    inxs = all_inxs{i};
    for s = 1:num_samples
        tinxs = find(inxs(1) <= spectra{s}.all_maxs & spectra{s}.all_maxs <= inxs(end));
        spectra{s}.maxs = spectra{s}.all_maxs(tinxs);
        spectra{s}.mins = spectra{s}.all_mins(tinxs,:);
    end
    tbins = perform_heuristic_bin_dynamic(x,max_spectrum,spectra,max_dist_btw_maxs,min_dist_from_boundary);
    if tbins(1,1) > x(inxs(1))
        tbins(1,1) = x(inxs(1));
    end
    if tbins(end,2) < x(inxs(end))
        tbins(end,2) = x(inxs(end));
    end
    bins = [bins;tbins];
end