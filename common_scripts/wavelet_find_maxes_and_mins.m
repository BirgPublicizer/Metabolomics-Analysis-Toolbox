function [maxes,mins,y_smoothed] = wavelet_find_maxes_and_mins(y,noise_std)
%WAVELET_FIND_MAXES_AND_MINS return maxima and minima of a function
%
% Returns the maxima, minima and smoothed values of a function with a given
% noise standard deviation using wavelet denoising techniques.  The y
% samples are assumed to be evenly-spaced.
%
% y          The y-values of the function, in order
% noise_std  The noise standard deviation
%
% maxes      The indices of the maxima of the smoothed function
% mins       The indices two bracketing minima of the smoothed function for the
%            local maximum at the same index. mins(i,1) and mins(i,2)
%            bracket maxes(i)
% y_smoothed The y_values after wavelet smoothing


% This will be set to the optimal from experimentation
options = {};
options.level = 1;
options.tptr = 'rigrsure';
options.sorh = 's';
options.scal = 'sln';
options.wname = 'sym7';
noise_std_mult = 5;
[y_smoothed,maxes,mins] = ...
    wavelet_smooth(y, noise_std*noise_std_mult, options);
