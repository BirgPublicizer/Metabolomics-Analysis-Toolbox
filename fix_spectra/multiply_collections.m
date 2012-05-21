function multiplied = multiply_collections( collections, multipliers )
% Multiply the spectra in each collection by their corresponding multiplier
%
% multiplied{i}.Y{:,j}=collections{i}.Y{:,j} * multipliers(i,j)
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
% multipliers - a matrix of dimensions (c,s) where c is the number of
%               collections and s is the maximum number of spectra in any
%               collection. multipliers(i,j) is the scalar by which to
%               multiply spectrum j in collection i. Values which have no
%               corresponding spectrum are ignored.
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
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer 2012 (eric_moyer@yahoo.com)

% Check preconditions
if size(multipliers,1) ~= length(collections)
    error('multiply_collections:num_multipliers',['The number of rows ' ...
        'in the multipliers array must be the same as the number of ' ...
        'collections.']);
end

% Do the multiplication
multiplied = collections;
for c = 1:length(multiplied)
    for s = 1:multiplied{c}.num_samples
        multiplied{c}.Y(:,s) = multiplied{c}.Y(:,s)*multipliers(c,s);
    end
end

end

