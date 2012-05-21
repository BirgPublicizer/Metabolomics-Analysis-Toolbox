function values = values_for_spectrum_attribute( field_name, spectra )
% Return a cell array of the values used for a given field in spectra
%
% The value for the field in the individual spectrum is used as the return
% value. So, if spectra{1}.my_field={'able','was','I'} and
% spectra{2}.my_field={'one','was','too','many'}. Then,assuming the 
% correct number of spectra in each collection, values would be {'I', 
% 'able', 'many', 'one', 'too', 'was'}
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% spectra    - a cell array of spectral collections. Each spectral
%              collection is a struct. This is the format
%              of the return value of load_collections.m in
%              common_scripts.
%
% field_name - the name of the field whose values are to be returned.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% values - a cell array of field values
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
%
% >> spectra{1}.my_field={'able','was','I'}; 
% >> spectra{2}.my_field={'one','was','too','many'}
% >> vals = values_for_spectrum_attributes('my_field', spectra)
% 
% vals = {'I', 'able', 'many', 'one', 'too', 'was'}
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%

values = cell(num_spectra_in(spectra), 1);
first_empty = 1;
for i=1:length(spectra)
    if isfield(spectra{i}, field_name)
        spec_values = spectra{i}.(field_name);
        if ~iscell(spec_values)
            spec_values = num2cell(spec_values);
        end
        last_to_fill = first_empty+length(spec_values)-1;
        values(first_empty:last_to_fill) = spec_values;    
        first_empty = last_to_fill + 1;
    end
end

values = values(1:first_empty-1);
if isempty(values)
    return
end

% Unique only works on cell arrays if they contain strings. This code does
% the conversion if necessary.
if ischar(values{1})
    values = unique(values);
else
    values = num2cell(unique(cell2mat(values)));
end

end

