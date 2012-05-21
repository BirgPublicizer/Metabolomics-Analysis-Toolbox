function binned_collections = bin_collections( collections, bin_width, use_waitbar )
% Return a new collection cell array with each sample binned to bin_width ppm bins
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% collections - a cell array of spectral collections. Each spectral
%               collection is a struct. This is the format
%               of the return value of load_collections.m in
%               common_scripts.
%
% bin_width   - the number of ppm wide each final bin will be. The bins
%               start at the minimum x value in all collections.  A bin
%               width of 0 means that no binning is done.
%
% usw_waitbar - if true a waitbar object is created to illustrate binning
%               progress. If omitted, assumed to be true
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% binned_collections - collections unchanged except now each spectrum has x
%                      values that are the centers of bin_width bins and Y
%                      values that are the sum of the original Y values
%                      that fell into each bin. If bin_width is 0, this is
%                      the same as the original input.
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% binned = bin_collections(my_collections, 0.04)
%
% Returns my_collections binned to 0.04 ppm bins after using a waitbar
% object to display work-in progress
%
%
%
% binned = bin_collections(my_collections, 0, false)
%
% Returns a copy of my_collections and does not display a waitbar
% 
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012)

if isempty(collections)
    binned_collections = collections;
    return;
end

if ~exist('use_waitbar','var')
    use_waitbar = true;
end

if (use_waitbar); wait_h = waitbar(0, 'Binning spectrum collections'); end

min_x = min(collections{1}.x);
max_x = max(collections{1}.x);
for idx = 2:length(collections)
    cur=collections{idx};
    min_x = min([min_x, min(cur.x)]);
    max_x = max([max_x, max(cur.x)]);
end

binned_collections=cell(length(collections),1);
for idx = 1:length(collections)
    binned_collections{idx}=bin_collection(collections{idx}, ... 
        min_x, max_x, bin_width);
    if(use_waitbar); waitbar(idx/length(collections), wait_h); end
end

if (use_waitbar); delete(wait_h); end

end

