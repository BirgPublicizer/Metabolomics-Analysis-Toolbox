function med_spec = median_spectrum( collections, use_spectrum )
% Returns a median spectrum from all the spectra in collections selected for use
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% collections  - a cell array of spectral collections. Each spectral
%                collection is a struct. This is the format
%                of the return value of load_collections.m in
%                common_scripts. All collections must use the same set of x
%                values. Check with only_one_x_in.m
%
% use_spectrum - a cell array of logical arrays. use_spectrum{i}(j) is
%                true iff the j-th spectrum in the i-th collection should
%                be used in calculating the median.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% med_spec - for each x value in the selected spectra, the median of the Y
%            values for the spectra selected by use_spectrum is the Y value
%            in med_spec. med_spec is a structure with two members x and Y.
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> med_spec = median_spectrum(collections, {[true,false], true})
%
% assuming collections has two entries and they have two and one spectra 
% respectively.
%
% med_spec.x will be collections{1}.x (which must be the same as
% collections{2}.x)
%
% med_spec.Y(i) will be the median of collections{1}.Y(i,1) and
% collections{2}.Y(i,1)
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%

if isempty(collections)
    error('median_spectrum:empty','The list of spectral collections passed to median_spectrum must be non-empty');
end

if length(collections) ~= length(use_spectrum)
    error('median_spectrum:length_mismatch',['The collections parameter '...
        'must be the same length as the use_spectrum parameter to ' ...
        'median_spectrum']);
end

if ~only_one_x_in(collections)
    error('median_spectrum:one_x',['All elements of the collections '...
        'parameter to median_spectrum must have identical x vectors']);    
end

med_spec.x = collections{1}.x;

% Count the number of used spectra
num_used = sum(cellfun(@sum, use_spectrum));
med_spec.Y = zeros(length(med_spec.x), num_used);

% Fill med_spec.Y with copies of all used spectra
spec_idx = 1;
for c=1:length(collections)
    num_samples = size(collections{c}.Y,2);
    for s=1:num_samples
        if use_spectrum{c}(s)
            med_spec.Y(:,spec_idx) = collections{c}.Y(:,s);
            spec_idx = spec_idx + 1;
        end
    end
end

% Set med_spec.Y to the median
med_spec.Y = median(med_spec.Y, 2);

end