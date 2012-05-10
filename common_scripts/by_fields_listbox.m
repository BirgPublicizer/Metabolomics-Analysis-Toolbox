function [sorted_fields_str,group_by_inxs,inxs,collection] = by_fields_listbox(collection,selected_fields)
collection.value = {};
for k = 1:length(selected_fields)
    field = selected_fields{k};
    for i = 1:length(collection.(field))
        if k == 1
            collection.value{i} = '';
        else
            collection.value{i} = [collection.value{i},', '];
        end
        
        if iscell(collection.(field))
            if ischar(collection.(field){i})
                collection.value{i} = [collection.value{i},collection.(field){i}];
            else
                collection.value{i} = [collection.value{i},num2str(collection.(field){i})];
            end
        else
            collection.value{i} = [collection.value{i},num2str(collection.(field)(i))];
        end
    end
end

values = {};
group_by_inxs = {};
for i = 1:length(collection.value)
    v = collection.value{i};
    found = false;
    for j = 1:length(values)
        if strcmp(values{j},v)
            found = true;
            group_by_inxs{j}(end+1) = i;
            break;
        end
    end
    if ~found
        values{end+1} = v;
        group_by_inxs{end+1} = i;
    end
end
[sorted_fields_str,inxs] = sort(values);
