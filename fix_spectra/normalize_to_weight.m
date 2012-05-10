function normalize_to_weight    
collections = getappdata(gcf,'collections');

for c = 1:length(collections)
    [ix,v] = listdlg('PromptString','Select weight field:',...
        'SelectionMode','single',...
        'ListString',collections{c}.input_names);

    pretty_field_name = collections{c}.input_names{ix};
    field_name = collections{c}.formatted_input_names{ix};
    
    collections{c}.Y_fixed = collections{c}.Y;
    for s = 1:collections{c}.num_samples
        weight = collections{c}.(field_name)(s);
        collections{c}.Y_fixed(:,s) = collections{c}.Y(:,s)/weight;
    end
end
setappdata(gcf,'collections',collections);
setappdata(gcf,'add_processing_log',sprintf('Normalized to weight (%s).',pretty_field_name));
setappdata(gcf,'temp_suffix','_normalize_to_weight');
plot_all
