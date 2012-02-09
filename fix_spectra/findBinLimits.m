function [bins,num_of_bins] = findBinLimits(num_of_points,xy)

num_of_bins = ceil(length(xy.freq)/num_of_points);

for i = 1:num_of_bins
    bins.start(i) = 1 + ((i-1)*num_of_points);
    bins.end(i) = num_of_points*i;  
    %If the binwidth of the last bin is small, place end of the bin at end
    %of amplitude data
    if bins.end(i) >= length(xy.amp);
        bins.end(i) = length(xy.amp);
    end
end