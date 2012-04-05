function spectra = create_spectra(x,Y,left_noise,right_noise,options)
spectra = {};
inxs = find(left_noise >= x & x >= right_noise);
nm = size(Y);
num_samples = nm(2);
for s = 1:num_samples
    spectra{s}.noise_std = std(Y(inxs,s));
    spectra{s}.mean = mean(Y(inxs,s));
    [spectra{s}.y_smoothed,spectra{s}.all_maxs,spectra{s}.all_mins] = smooth(Y(:,s),spectra{s}.noise_std*options.noise_std_mult,options);
end