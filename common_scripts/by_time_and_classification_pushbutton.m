function [sorted_time_and_classifications_str,group_by_inxs,inxs] = by_time_and_classification_pushbutton(handles)
try
    collection = handles.collection;
catch ME
    msgbox('Load a collection');
    return;
end
collection.time_and_classification = {};
for i = 1:length(collection.classification)
    if iscell(collection.time) && iscell(collection.classification)
        collection.time_and_classification{i} = sprintf('%s, %s',collection.classification{i},collection.time{i});
    elseif ~iscell(collection.time) && iscell(collection.classification)
        collection.time_and_classification{i} = sprintf('%s, %d',collection.classification{i},collection.time(i));
    elseif iscell(collection.time) && ~iscell(collection.classification)
        collection.time_and_classification{i} = sprintf('%d, %s',collection.classification(i),collection.time{i});
    elseif ~iscell(collection.time) && ~iscell(collection.classification)
        collection.time_and_classification{i} = sprintf('%d, %d',collection.classification(i),collection.time(i));
    end
end
time_and_classifications = {};
group_by_inxs = {};
for i = 1:length(collection.time_and_classification)
    time_and_classification = collection.time_and_classification{i};
    found = false;
    for j = 1:length(time_and_classifications)
        if strcmp(time_and_classifications{j},time_and_classification)
            found = true;
            group_by_inxs{j}(end+1) = i;
            break;
        end
    end
    if ~found
        time_and_classifications{end+1} = time_and_classification;
        group_by_inxs{end+1} = i;
    end
end
[sorted_time_and_classifications_str,inxs] = sort(time_and_classifications);
