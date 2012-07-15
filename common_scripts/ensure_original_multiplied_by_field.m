function collections = ensure_original_multiplied_by_field( collections )
% The returned collections now have an original_multiplied_by field if they lacked it
% 
% Checks every collection for an "Original multiplied by" field, and if it
% lacks it, adds one that is 1 for every spectrum in that collection (that
% is, it assumes that the spectra have the original, unnormalized values).
% This field allows tracking the normalization constants.
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% collections - a cell array of spectral collections. Each spectral
%               collection is a struct array of spectra. This is the format
%               of the return value of load_collections.m in
%               common_scripts.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% collections - the collections parameter with the potentially added field
%               "Original multiplied by"
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% modified = ensure_original_multiplied_by_field( collections )
%
% All collections will have an original_multiplied_by field. That is,
% all(cellfun(@(in) isfield(in,'original_multiplied_by'), modified)) == true
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com

for c=1:length(collections)
    if ~isfield(collections{c},'original_multiplied_by')
        collections{c}.original_multiplied_by = ones(1,size(collections{c}.Y,2));
        if ~isfield(collections{c}, 'input_names')
            collections{c}.input_names = cell(0);
        end
        if ~isfield(collections{c}, 'formatted_input_names')
            collections{c}.formatted_input_names = cell(0);
        end
        collections{c}.input_names{end+1}='Original multiplied by';
        collections{c}.formatted_input_names{end+1}='original_multiplied_by';
    end
end


end

