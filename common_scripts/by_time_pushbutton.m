function [sorted_times_str,group_by_inxs,inxs] = by_time_pushbutton(handles)
try
    collection = handles.collection;
catch ME
    msgbox('Load a collection');
    return;
end
times = [];
if iscell(collection.time)
    times = {};
end
group_by_inxs = {};
for i = 1:length(collection.time)
    if iscell(collection.time)
        time = collection.time{i};
        found = false;
        for j = 1:length(times)
            if strcmp(times{j},time)
                found = true;
                group_by_inxs{j}(end+1) = i;
                break;
            end
        end
        if ~found
            group_by_inxs{end+1} = i;
            times{end+1} = time;
        end
    else
        time = collection.time(i);
        found = false;
        for j = 1:length(times)
            if times(j) == time
                found = true;
                group_by_inxs{j}(end+1) = i;
                break;
            end
        end
        if ~found
            times(end+1) = time;
            group_by_inxs{end+1} = i;
        end
    end
end

if iscell(times)
    [sorted_times_str,inxs] = sort(times);
else
    [sorted_times,inxs] = sort(times);
    sorted_times_str = {};
    for i = 1:length(sorted_times)
        sorted_times_str{i} = num2str(sorted_times(i));
    end
end