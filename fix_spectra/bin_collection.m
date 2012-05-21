function binned = bin_collection( collection, first_bin_min, last_bin_pt, bin_width )
% Return collection with Y values summed into bin_width bins.
%
% To avoid double-counting, all bins except are half-open
% intervals [center-width/2, center+width/2). So a point that falls on the
% border between two bins goes into the higher bin.
%
% The measurements in the spectrum are taken to be point measurements that
% fall entirely into one bin or another. A better approximation for some
% other time might be to consider them evenly distributed through the
% interval between their point and their nearest neighbors.
%
% A warning will be printed if not all y values fell into a bin. (This
% warning is mainly for programmers - this routine should never be called
% in that situation.)
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% collection    - a spectrum collection: one of the cells returned by 
%                 load_collections.m in common_scripts.
%
% first_bin_min - the minimum value in the minimum valued bin to use
%
% last_bin_pt   - a point in the last bin to use. Must be greater than or
%                 equal to first_bin. If it falls within the first bin, only
%                 one bin is used.
%
% bin_width     - the number of ppm wide each final bin will be. The bins
%                 start at the minimum x value in all collections.  A bin
%                 width of 0 means that no binning is done. Negative bin
%                 widths cause an error
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% binned - collections unchanged except now each spectrum has x
%          values that are the centers of bin_width bins and Y
%          values that are the sum of the original Y values
%          that fell into each bin. If bin_width is 0, this is
%          the same as the original input.
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% binned = bin_collection(my_collections, 0, 0.9, 0.5)
%
% Returns my_collections binned into two bins of width 0.5 centered at 0.25
% and 0.75 respectively
%
%
%
% binned = bin_collections(my_collections, 0, 0.3, 0.5)
%
% Returns my_collections binned into one bin of width 0.5 centered at 0.25
% 
%
%
% binned = bin_collection(my_collections, 0, 1.1, 0.25)
%
% Returns my_collections binned into five bins of width 0.25 centered at 
% 0.125, 0.375, 0.625, 0.875, and 1.125
%
%
%
% binned = bin_collection(my_collections, 0, 1.0, 0.25)
%
% Returns my_collections binned into four bins of width 0.25 centered at 
% 0.125, 0.375, 0.625, and 0.875
%
%
%
% binned = bin_collection(my_collections, 0, 1.25, 0.25)
%
% Returns my_collections binned into six bins of width 0.25 centered at 
% 0.125, 0.375, 0.625, 0.875, 1.125, and 1.375
%
%
%
% binned = bin_collection(my_collections, 0, 1.249, 0.25)
%
% Returns my_collections binned into five bins of width 0.25 centered at 
% 0.125, 0.375, 0.625, 0.875, and 1.125
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012)
%

% Take care of 0 width bins
binned = collection;
if(bin_width == 0)
    return;
elseif (bin_width < 0)
    error('bin_collection:neg_binwidth','Bin width passed to bin_collection cannot be negative');
end

% Calculate the centers of the new bins - these will be the new x-values
half_w = bin_width / 2;
bin_centers = (first_bin_min + half_w):bin_width:(last_bin_pt+half_w);

% Calculate which of the old x-values fall into which new bin.
% bin_contents{i} is a vector containing the indices of the x-values that
% fall into bin i.
bin_contents = cell(size(bin_centers));
print_warning = false;
for x_idx = 1:length(collection.x)
    x_val = collection.x(x_idx);
    bin_idx = floor((x_val-first_bin_min)/bin_width) + 1;
    if(bin_idx >= 1 && bin_idx <= length(bin_contents))
        bin_contents{bin_idx}(end+1)=x_idx;
    else
        print_warning = true;
    end
end

if(print_warning)
    warning('bin_collection:out_of_bin_val','Some x values passed to bin_collection were not included any bin');
end

% Do the summation
binned.x = bin_centers;
binned.Y = zeros(length(binned.x), binned.num_samples);
for bin_idx = 1:length(bin_centers)
    %This does the binning for all spectra simultaneously
    binned.Y(bin_idx, :) = sum(collection.Y(bin_contents{bin_idx},:));
end


end