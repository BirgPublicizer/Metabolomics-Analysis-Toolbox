
function new_collection = anderson_deconvolve(collection, ...
    min_width, max_width, num_iterations, baseline_width, x_limits)
%Deconvolve the given spectral collection and return the deconvolved
%version ... see anderson_deconvolve_spectrum for explanation of the
%options

%append_to_log(handles,sprintf('Starting deconvolution'));

[~,num_spectra] = size(collection.Y);
% Perform deconvolution
for s = 1:num_spectra
    new_collection = anderson_deconvolve_spectrum(collection,s, ...
        min_width, max_width, num_iterations, baseline_width, x_limits);
end

