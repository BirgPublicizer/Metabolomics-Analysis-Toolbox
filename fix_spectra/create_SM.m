function SM = create_SM(bins,xy,signal_index)
SM = ones(length(xy.amp),1);
for j = 1:length(signal_index)
    signalstart = bins.start(signal_index(j));
    signalend = bins.end(signal_index(j));
    SM(signalstart:signalend) = zeros((signalend-signalstart+1),1);
end
%plotspectrum('h',[xy.freq xy.amp],[xy.freq abs(1-SM)])