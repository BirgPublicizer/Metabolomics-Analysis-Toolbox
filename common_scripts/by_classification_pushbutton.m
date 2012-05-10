function [sorted_classifications_str,group_by_inxs,inxs] = by_classification_pushbutton(handles)
try
    collection = handles.collection;
catch ME
    msgbox('Load a collection');
    return;
end
classifications = [];
group_by_inxs = {};
if iscell(collection.classification)
    classifications = {};
end
for i = 1:length(collection.classification)
    if iscell(collection.classification)
        classification = collection.classification{i};
        found = false;
        for j = 1:length(classifications)
            if strcmp(classifications{j},classification)
                found = true;
                group_by_inxs{j}(end+1) = i;
                break;
            end
        end
        if ~found
            group_by_inxs{end+1} = i;
            classifications{end+1} = classification;
        end
    else
        classification = collection.classification(i);
        found = false;
        for j = 1:length(classifications)
            if classifications(j) == classification
                found = true;
                group_by_inxs{j}(end+1) = i;
                break;
            end
        end
        if ~found
            classifications(end+1) = classification;
            group_by_inxs{end+1} = i;
        end
    end
end

if iscell(classifications)
    [sorted_classifications_str,inxs] = sort(classifications);
else
    [sorted_classifications,inxs] = sort(classifications);
    sorted_classifications_str = {};
    for i = 1:length(sorted_classifications)
        sorted_classifications_str{i} = num2str(sorted_classifications(i));
    end
end

