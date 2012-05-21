function is_overlapping = bins_overlapping_regions( bin_centers, regions )
% is_overlapping(i) is true iff the bin centered at bin_centers overlaps with at least one region in regions
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% bin_centers - the centers of the bins. Each bin is assumed to have a
%               boundary half-way between it and each of its neighbors. 
%               The bins on the end have an additional boundary on the 
%               side with no neighbour. This boundary is the same distance
%               from the center that the other boundary is. 
%
%               This way of calculating the boundaries only really works
%               for equal-sized bins. But that is what this routine will
%               receive for inputs, so that should not be a problem.
%
%               If there is only one bin, it is assumed to encompass the
%               whole real line. Thus it overlaps any region.
%
%               The bin centers must be sorted.
%
% regions     - an array of region end points. regions(i,1) and
%               regions(i,2) are the endpoints of the i'th interval. Each
%               interval is half open. It contains the points x where 
%               lower <= x < higher. lower = min(regions(i,:) and higher =
%               max(regions(i,:))
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% is_overlapping - is_overlapping(i) is true iff the bin centered at 
%                  bin_centers overlaps with at least one region in
%                  regions. is_overlapping is an array of logicals
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> bins_overlapping_regions([1,2,3],[1,1])'
% 
% ans =
% 
%      1     0     0
%
%
%
% >> bins_overlapping_regions([1,2,3],[1,1;3,3.5])'
% 
% ans =
% 
%      1     0     1
%
%
% >> bins_overlapping_regions([1,2,3,4,5],[2.43,3.6])'
% 
% ans =
% 
%      0     1     1     1     0
% 
% 
% >> bins_overlapping_regions([1.5,2.5,3.5],[])'
% 
% ans =
% 
%      0     0     0
% 
% 
% >> bins_overlapping_regions([1.5],[1,1])'
% 
% ans =
% 
%      1
% 
% 
% >> bins_overlapping_regions([1,2,3],[1,1.6])'
% 
% ans =
% 
%      1     1     0
% 
% 
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer 2012 (eric_moyer@yahoo.com)

% Ensure preconditions on input are met.
if ~isvector(bin_centers)
    error('bins_overlapping_regions:vector',['The bin centers passed to'...
        'bins_overlapping_regions must a vector.']);
end

if ~issorted(bin_centers)
    error('bins_overlapping_regions:sorted',['The bin centers passed to'...
        'bins_overlapping_regions must be sorted.']);
end

if ~isempty(regions) && (length(size(regions)) ~= 2 || size(regions,2) ~= 2)
    error('bins_overlapping_regions:bad_regions', ...
        ['The regions array passed to bins_overlapping regions must'...
        'have two columns or be empty.']);
end

% Deal with special cases
if isempty(regions)
    is_overlapping = false(length(bin_centers),1);
    return;
end

nbins = length(bin_centers);
if nbins == 0
    is_overlapping = [];
    return;
elseif nbins == 1
	is_overlapping = true(1);
    return;
end

% Ensure that regions(i,1) <= regions(i,2)
regions = sort(regions, 2);

% Make bin_centers a column vector
if size(bin_centers,2) ~= 1
    bin_centers = bin_centers';
end

% Calculate bin boundaries
all_but_first = bin_centers(2:end);
all_but_last  = bin_centers(1:end-1);
edges_between_bins = (all_but_first + all_but_last)/2;
first_bin_half_width = abs(edges_between_bins(1)-bin_centers(1));
last_bin_half_width = abs(edges_between_bins(end)-bin_centers(end));
bin_mins = [bin_centers(1)-first_bin_half_width
            edges_between_bins];
bin_maxes= [edges_between_bins
            bin_centers(end)+last_bin_half_width];

% Calculate overlaps
is_overlapping = false(nbins,1);
reg_low = regions(:,1);
reg_hi = regions(:,2);
for bin_num=1:nbins
    % A bin overlaps a region if bin_hi > reg_low AND reg_hi > bin_low
    bin_low = bin_mins(bin_num);
    bin_hi  = bin_maxes(bin_num);
    is_overlapping(bin_num) = any(bin_hi > reg_low & reg_hi > bin_low);    
end

end

