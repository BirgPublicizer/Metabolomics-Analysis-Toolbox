function matching = spectra_matching( spectra, field_name, field_value )
% matching{c}(s) is true iff spectra{c}.field_name(i) is field_value
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% spectra     - a cell array of spectral collections. Each spectral
%               collection is a struct. This is the format
%               of the return value of load_collections.m in
%               common_scripts. 
%
% field_name  - the name of the field in each spectrum whose value is to be
%               examined. If field_value is a string, it must be a cell
%               array otherise, it must be a vector.  The length in each
%               collection must be the same as the number of spectra in
%               that collection.
%
% field_value - the value of the field which counts as a match. Either a
%               string or a number.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% matching - matching{c}(s) is true iff spectra{c}.field_name(i) is 
%            field_value. If matching{c} does not have that field name,
%            then matching{c}(s) is false for all s. matching{c} is a row
%            vector.
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> matching = spectra_matching( spectra, 'base_sample_id', 5551 )
%
% If spectra{1}.base_sample_id = [5551 5552 5553] then
% matching{1} = [1 0 0]
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%

matching=cell(size(spectra));
for c=1:length(spectra)
    if isfield(spectra{c}, field_name) 
        vals = spectra{c}.(field_name);
        if length(vals) ~= spectra{c}.num_samples
            error('spectra_matching:field_length', ...
                ['The field ''%s'' in spectrum %d has %d values ', ...
                'but should have %d.'], field_name, length(vals), ...
                spectra{c}.num_samples);
        end

        if ischar(field_value)
            matching{c}=strcmp(field_value, vals);
        else
            matching{c}=vals == field_value;
        end
    else
        matching{c}=false(1,spectra{c}.num_samples);
    end
    %Ensure that the match vector is a row vector
    if size(matching{c},1) ~= 1
        matching{c} = matching{c}';
    end
end


end

