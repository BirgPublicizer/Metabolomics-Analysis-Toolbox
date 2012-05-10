function [X,Y,available_X,available_Y,G,available_G] = get_run_data(hObject,handles)
try
    collection = handles.collection;
catch ME
    msgbox('Load a collection');
    return;
end

try
    are_groups = get(handles.groups_checkbox,'Value');
catch ME
    are_groups = true;
end

try
    group_by_inxs = handles.group_by_inxs;
catch ME
    group_by_inxs = [];
end

try
    model_by_inxs = handles.model_by_inxs;
    selected = get(handles.model_by_listbox,'Value');
    model_by_inxs = {model_by_inxs{selected}};
catch ME
    model_by_inxs = [];
end

try
    ignore_by_inxs = handles.ignore_by_inxs;
    selected = get(handles.ignore_by_listbox,'Value');
    ignore_by_inxs = {ignore_by_inxs{selected}};
catch ME
    ignore_by_inxs = [];
end

new_model_by_inxs = {};
for g = 1:length(model_by_inxs)    
    new_model_by_inxs{g} = [];
    for i = 1:length(model_by_inxs{g})
        ignore = false;
        inx_unpaired = model_by_inxs{g}(i);
        for ig = 1:length(ignore_by_inxs)
            for ii = 1:length(ignore_by_inxs{ig})
                iinx_unpaired = ignore_by_inxs{ig}(ii);
                if iinx_unpaired == inx_unpaired
                    ignore = true;
                    break;
                end
            end
        end
        if ~ignore
            new_model_by_inxs{g}(end+1) = inx_unpaired;
        end
    end
end
model_by_inxs = new_model_by_inxs;

paired = false;
try
    paired_by_inxs = handles.paired_by_inxs;
    selected = get(handles.paired_by_listbox,'Value');
    paired_by_inxs = {paired_by_inxs{selected}};
    paired = true;
catch ME
end

num_samples = 0;
for i = 1:length(model_by_inxs)
    num_samples = num_samples + length(model_by_inxs{i});
end
[num_variables,total_num_samples] = size(collection.Y);
   
% For OPLS (X and Y are switched, Y is now the labels)
if ~iscell(collection.Y)
    available_X = NaN*ones(num_variables,total_num_samples);
    X = [];%NaN*ones(num_variables,num_samples);
else
    available_X = cell(1,total_num_samples);
    X = {};
end
available_Y = NaN*ones(1,total_num_samples);
Y = [];%NaN*ones(1,num_samples);
available_G = NaN*ones(1,total_num_samples);
G = [];

s = 0;
if paired % Pair up the data
    fprintf('Starting pairing...\n');
    % Grap only those selected
    for g = 1:length(model_by_inxs)    
        for i = 1:length(model_by_inxs{g})
            inx_unpaired = model_by_inxs{g}(i);
            s = s + 1;
            % Now find matching subject ID
            found = false;
            for p = 1:length(paired_by_inxs)
                for j = 1:length(paired_by_inxs{p})
                    inx_paired = paired_by_inxs{p}(j);
                    if collection.subject_id(inx_paired) == collection.subject_id(inx_unpaired) && inx_paired ~= inx_unpaired
                        if ~iscell(X)
                            X(:,end+1) = collection.Y(:,inx_unpaired) - collection.Y(:,inx_paired);
                        else
                            X{end+1} = collection.Y{inx_unpaired} - collection.Y{inx_paired};
                        end
                        G(end+1) = g;                            
                        if are_groups
                            Y(end+1) = g;
                        else
                            Y(end+1) = str2num(collection.value{inx_unpaired}) - str2num(collection.value{inx_paired});
                        end
                        found = true;
                        break;
                    end
                end
            end
            if ~found
                fprintf('Could not match sample %d at time %d with classification %s\n',collection.subject_id(inx_unpaired),collection.time(inx_unpaired),collection.classification(inx_unpaired));
            end
        end
    end
    % Now grab all that is available
    for g = 1:length(group_by_inxs)
        for i = 1:length(group_by_inxs{g})
            inx_unpaired = group_by_inxs{g}(i);
            found = false;
            % Now find matching subject ID
            for p = 1:length(paired_by_inxs)
                for j = 1:length(paired_by_inxs{p})
                    inx_paired = paired_by_inxs{p}(j);
                    if collection.subject_id(inx_paired) == collection.subject_id(inx_unpaired) && inx_paired ~= inx_unpaired
                        if ~iscell(X)                        
                            available_X(:,inx_unpaired) = collection.Y(:,inx_unpaired) - collection.Y(:,inx_paired);
                        else
                            available_X{inx_unpaired} = collection.Y{inx_unpaired} - collection.Y{inx_paired};
                        end
                        available_G(inx_unpaired) = g;
                        if are_groups
                            available_Y(inx_unpaired) = g;
                        else
                            available_Y(inx_unpaired) = str2num(collection.value{inx_unpaired}) - str2num(collection.value{inx_paired});
                        end
                        found = true;
                        break;
                    end    
                end
                if found
                    break;
                end
            end
        end
    end
else
    for g = 1:length(model_by_inxs)    
        for i = 1:length(model_by_inxs{g})
            inx_unpaired = model_by_inxs{g}(i);
            s = s + 1;
            if ~iscell(X)                        
                X(:,s) = collection.Y(:,inx_unpaired);
            else
                X{s} = collection.Y{inx_unpaired};
            end
            G(s) = g;
            if are_groups
                Y(s) = g;
            else
                Y(s) = str2num(collection.value{inx_unpaired});
            end
        end
    end
    % Now grab all that is available
    for g = 1:length(group_by_inxs)
        for i = 1:length(group_by_inxs{g})
            inx_unpaired = group_by_inxs{g}(i);
            s = s + 1;            
            if ~iscell(X)                        
                available_X(:,inx_unpaired) = collection.Y(:,inx_unpaired);
            else
                available_X{inx_unpaired} = collection.Y{inx_unpaired};
            end
            available_G(inx_unpaired) = g;
            if are_groups
                available_Y(inx_unpaired) = g;
            else
                available_Y(inx_unpaired) = str2num(collection.value{inx_unpaired});
            end
        end
    end
end