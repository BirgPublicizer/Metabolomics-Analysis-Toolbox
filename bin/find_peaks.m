function handles = find_peaks(handles,min_width)
if isfield(handles,'summary_text')
    add_line_to_summary_text(handles.summary_text,'Finding peaks');
end

%min_width = 30;
collection = handles.collection;
[num_variables,num_spectra] = size(collection.Y);
collection.maxs = {};
collection.mins = {};
for s = 1:num_spectra
    for b = 1:length(collection.regions{s})
        collection.regions{s}{b}.include_mask = {};
    end
end
% collection.BETA = {};
collection.Y_smooth = [];
for s = 1:num_spectra
    noise_std = std(collection.Y(1:min_width,s));
    % Find the minimums so we can divide the spectra appropriately
    [maxs,mins,y_smooth] = find_maxs_mins(collection.x,collection.Y(:,s),noise_std); % Find the peak locations
    collection.maxs{s} = maxs;
    collection.mins{s} = mins;
    for b = 1:length(collection.regions{s})
        collection.regions{s}{b}.include_mask = 0*maxs+1; % Include all by default
    end    
%     collection.BETA{s} = zeros(4*length(maxs),1);
%     collection.BETA{s}(4:4:end) = collection.x(maxs);
    collection.Y_smooth(:,s) = y_smooth;
    if isfield(handles,'summary_text')
        add_line_to_summary_text(handles.summary_text,sprintf('Finished spectrum %d/%d',s,num_spectra));
    end
end
handles.collection = collection;

if isfield(handles,'summary_text')
    add_line_to_summary_text(handles.summary_text,'Finished finding peaks');
end
