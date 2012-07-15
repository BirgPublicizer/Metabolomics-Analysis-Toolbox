function multiplied = multiply_collections( collections, multipliers )
% Multiply the spectra in each collection by their corresponding multiplier
%
% If multipliers is a cell array:
%   multiplied{i}.Y{:,j}=collections{i}.Y{:,j} * multipliers{i}(j)
% otherwise
%   multiplied{i}.Y{:,j}=collections{i}.Y{:,j} * multipliers(i,j)
% endif
%
% The result has an original_multiplied_by field added (or updated, if one
% was already present)
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% collections - a cell array of spectral collections. Each spectral
%               collection is a struct of spectra. This is the format
%               of the return value of load_collections.m in
%               common_scripts.
%
% multipliers - Either a cell array of double arrays such that
%               multipliers{i}(j) is valid for all spectra indices j in
%               collection i
%
%               or
%
%               a matrix where multipliers(i,j) is valid for all spectra 
%               indices j in collection i
%
%               Values which have no corresponding spectrum are ignored.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% multiplied - the spectra in collections after their y values have been
%              multiplied by the appropriate constants.
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> multiplied = multiply_collections (collections, [1,2;3,4])
%
% returns two collections identical to those in collections except that the
% two spectra in multiplied{1} have been multiplied by 1 and 2 respectively
% and the two spectra in multiplied{2} have been multiplied by 3 and 4
% respectively.
%
% additionally multiplied{1}.original_multiplied_by == [1,2] and 
% multiplied{2}.original_multiplied_by == [3,4] (if they had no such values
% beforehand) or multiplied{1}.original_multiplied_by ==
% collections{1}.original_multiplied_by .* [1,2] and similarly for index 
% 2 (if they already posessed that field).
%
% >> multiplied = multiply_collections (collections, {[1,2],[3,4]}
%
% same as above
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer 2012 (eric_moyer@yahoo.com)

% Check preconditions
if ~iscell(multipliers) &&  size(multipliers,1) < length(collections)
    error('multiply_collections:num_multipliers',['The number of rows ' ...
        'in the multipliers matrix must be at least as large as the number of ' ...
        'collections.']);
elseif ~is_matrix(multipliers) && ~iscell(multipliers)
    error('multiply_collections:cell_or_matrix',['The multipliers input to ' ...
        'multiply_collections must be either a cell array or a matrix']);
elseif iscell(multipliers) && length(multipliers) < length(collections)
    error('multiply_collections:num_multipliers',['The multipliers input to ' ...
        'multiply_collections must have at least as many cells ' ...
        'as the number of collections']);
end


% Reformat matrix as cells
if ~iscell(multipliers)
    newmult = cell(length(collections), 1);
    for c = 1:length(collections)
        newmult{c}=multipliers(c,1:collections{c}.num_samples);
    end
    multipliers = newmult;
end


% Do the multiplication
multiplied = ensure_original_multiplied_by_field( collections );
for c = 1:length(multiplied)
    num_spectra = size(multiplied{c}.Y, 2);
    for s = 1:num_spectra
        multiplied{c}.Y(:,s) = multiplied{c}.Y(:,s)*multipliers{c}(s);
        multiplied{c}.original_multiplied_by(s)=...
            multiplied{c}.original_multiplied_by(s)*multipliers{c}(s);
    end
end

end

