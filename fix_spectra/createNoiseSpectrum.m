function noiseOnlySpectrum = createNoiseSpectrum(xy,groomed_signal_index,num_of_points)
%Generate new spectrum based on given noise signal map
%Generate Bin Values
[bins,num_of_bins] = findBinLimits(num_of_points,xy);
noiseOnlySpectrum = [xy.freq xy.amp];
for i = 1:length(groomed_signal_index)
    %Determine start and end points of sample
    sampleStart = bins.start(groomed_signal_index(i));
    sampleEnd = bins.end(groomed_signal_index(i));
    %mark signal as NaN
    noiseOnlySpectrum(sampleStart:sampleEnd,2) = NaN;
end