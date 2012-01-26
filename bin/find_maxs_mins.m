function [maxs,mins,y_smoothed] = find_maxs_mins(x,y,noise_std)
% This will be set to the optimal from a previous experiment
options = {};
options.level = 1;
options.tptr = 'rigrsure';
options.sorh = 's';
options.scal = 'sln';
options.wname = 'sym7';
noise_std_mult = 5;
[y_smoothed,maxs,mins] = smooth(y,noise_std*noise_std_mult,options);
