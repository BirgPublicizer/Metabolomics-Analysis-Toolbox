function names = spectrum_attributes( spectra )
% Return a cell array of all of the spectrum attributes in any collection
%
% A spectrum attribute is a field in a spectral collection struct that is 
% an attribute of the spectrum rather than the collection. Right now this 
% is detected by returning fields that have the same number of elements as 
% the number of spectra in the collection.
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% spectra - a cell array of spectral collections. Each spectral
%           collection is a struct. This is the format
%           of the return value of load_collections.m in
%           common_scripts.
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% names - a cell array of strings. Each string is the name of a field in 
%         some spectral collection and was identified by this routine's
%         heuristic as a spectrum attribute
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> names = spectrum_attributes(collections)
%
% names will be the list of all field names that are attributes of some
% spectrum in collections
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%

num_names = 0;
for i=1:length(spectra)
    num_names = num_names + length(fieldnames(spectra{i}));
end
names = cell(num_names, 1);
first_empty = 1;
for i=1:length(spectra)
    num_spec = spectra{i}.num_samples;
    fn = fieldnames(spectra{i});
    nelt = cellfun(@(name) numel(spectra{i}.(name)), fn);
    per_spec_names=fn(nelt == num_spec);
    last_to_fill = first_empty+length(per_spec_names)-1;
    names(first_empty:last_to_fill)= per_spec_names;
    first_empty = last_to_fill + 1;
end
names = unique(names(1:first_empty-1));

end

