function normalize_to_weight
% Divides spectra by a the value stored in a user-specified field
%
% Helper function to fix_spectra. Not intended to be called from elsewhere.
%
% For each collection in getappdata(gcf,'collections'), the user is asked 
% to pick a field. Then the spectra in that collection are divided by that
% field value. 
%
% At the end the result is stored in fixed_collections, and collections,
% temp_suffix, and add_proecessing_log are modified so that 'Finalize' will
% function and the proposed changes are displayed.
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% getappdata(gcf, collections) - the output of a call to loadcollections.m
%                                a cell array of spectra
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
%
% sets appdata fields to reflect the results of sum-normalization and the
% metadata to be added.
%
% setappdata(gcf,'collections',...)
%    - sets collections to one with Y_fixed being the weight-normalized
%      values, other things are left the same
%
% setappdata(gcf,'fixed_collections', ...)
%    - sets fixed_collections to a collection with updated processing log,
%      normalized y-values, and updated original_multiplied_by fields
%
% setappdata(gcf,'add_processing_log', ...)
%    - sets add_processing_log to contain text describing the weight
%      normalization - this will only be used for plot legend display
%
% setappdata(gcf,'temp_suffix','_normalize_to_weight') 
%    - sets the temp_suffix appdata so that the suffixes of the saved files
%      will reflect the operations performed on them
%
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> normalize_to_weight
% 
% this should only be called from within the fixed_spectra program
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Paul Anderson (May 2012) pauleanderson@gmail.com
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%

collections = ensure_original_multiplied_by_field(getappdata(gcf,'collections'));

old_collections = collections;
ix = 1;
was_changed = false;
for c = 1:length(collections)
    [ix,ok] = listdlg('PromptString','Select weight field:',...
        'SelectionMode','single',...
        'ListString',collections{c}.input_names, 'InitialValue', ix);
    if ok
        was_changed = true;
        pretty_field_name = collections{c}.input_names{ix};
        field_name = collections{c}.formatted_input_names{ix};

        collections{c}.processing_log = sprintf('%s Normalized to weight (%s).',...
            collections{c}.processing_log, pretty_field_name);
        for s = 1:collections{c}.num_samples
            weight = collections{c}.(field_name)(s);
            collections{c}.Y(:,s) = collections{c}.Y(:,s)/weight;
            collections{c}.original_multiplied_by(s) = ...
                collections{c}.original_multiplied_by(s) * (1/weight);
        end
    end
end

if was_changed
    old_collections = copy_y_to_y_fixed(collections, old_collections);
    setappdata(gcf,'collections',old_collections);
    setappdata(gcf,'fixed_collections', collections);
    setappdata(gcf,'add_processing_log',sprintf('Normalized to weight (%s).',pretty_field_name));
    setappdata(gcf,'temp_suffix','_normalize_to_weight');
end
plot_all
