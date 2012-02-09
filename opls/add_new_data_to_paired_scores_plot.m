function [metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection)
orig_opls_scores = opls_scores;

addpath('../common_scripts');

%%%%%%%%%%%%
% Run OPLS again to create w_ortho (OSC), p_ortho, and w
%%%%%%%%%%%%
w_ortho = [];
t_ortho = [];
p_ortho = [];

Xres = bsxfun(@minus,X, mean(X));
Yres = Y - mean(Y);

for iter=1:num_opls_fact
    %find and store these PLS components for later use
    w = (Yres'*Xres / (Yres'*Yres))';
    w = w / norm(w);

    t = Xres*w / (w'*w);
    p = (t'*Xres / (t'*t))';

    %run OSC filter on Xres
    w_ortho(:,iter) = p - (w'*p / (w'*w)) * w;
    w_ortho(:,iter) = w_ortho(:,iter) / norm(w_ortho(:,iter));
    t_ortho(:,iter) = Xres*w_ortho(:,iter) / (w_ortho(:,iter)'*w_ortho(:,iter));
    p_ortho(:,iter) = (t_ortho(:,iter)'*Xres / (t_ortho(:,iter)'*t_ortho(:,iter)))';
    Xres = Xres - t_ortho(:,iter)*p_ortho(:,iter)';
end

%find final PLS component
w = (Yres'*Xres / (Yres'*Yres))';
w = w / norm(w);
% For comparison only
t_old = Xres*w/(w'*w);
t_ortho_old = t_ortho;

if isempty(all_Xres) % First time
    all_Xres = Xres;
end

%%%%%%%%%%
% Now apply to new data
%%%%%%%%%%

if ~exist('collection') % Optional argument
    collection = get_collection;
end

fprintf('Leave blank to finish adding new data\n');
if exist('input_data')
    [num_input,cols] = size(input_data);
end
input_cnt = 1;
while true
    if exist('input_data') && input_cnt > num_input
        break;
    end
    if exist('input_data')
        classification = input_data{input_cnt,1};
        time_unpaired = input_data{input_cnt,2};
        time_paired = input_data{input_cnt,3};
    else
        classification = input('Enter classification: ','s');
        if isempty(classification)
            break;
        end
        time_unpaired = input('Enter time (unpaired): ');
        if isempty(time_unpaired)
            break;
        end
        time_paired = input('Enter time (paired): ');
        if isempty(time_paired)
            break;
        end
    end

    % Group the data
    inxs_unpaired = [];
    data_unpaired = [];
    inxs_paired = [];
    data_paired = [];
    for i = 1:collection.num_samples
        if strcmp(collection.classification{i},classification) && collection.time(i) == time_unpaired
            inxs_unpaired(end+1) = i;
            data_unpaired(:,end+1) = collection.Y(:,i);
        end
        if strcmp(collection.classification{i},classification) && collection.time(i) == time_paired
            inxs_paired(end+1) = i;
            data_paired(:,end+1) = collection.Y(:,i);
        end
    end

    % Pair up the data
    inxs_pairing = [];
    data_pairing = [];
    for i = 1:length(inxs_unpaired)
        inx_unpaired = inxs_unpaired(i);
        % Now find matching subject ID
        found = false;
        for j = 1:length(inxs_paired)
            inx_paired = inxs_paired(j);
            if collection.subject_id(inx_paired) == collection.subject_id(inx_unpaired) && inx_paired ~= inx_unpaired
                inxs_pairing(end+1,:) = [inx_unpaired,inx_paired];
                data_pairing(:,end+1) = collection.Y(:,inx_unpaired) - collection.Y(:,inx_paired);
                found = true;
            end
        end
        if ~found
            fprintf('Could not match sample %d for classification: %s\n',collection.subject_id(inx_unpaired),classification);
        end
    end

    t_ortho = [];

    Xres = bsxfun(@minus,data_pairing',mean(X));
    for iter = 1:num_opls_fact
        %run OSC filter on Xres
        t_ortho(:,iter) = Xres*w_ortho(:,iter) / (w_ortho(:,iter)'*w_ortho(:,iter));
        Xres = Xres - t_ortho(:,iter)*p_ortho(:,iter)';
    end
    all_Xres = [all_Xres;Xres];

    t = Xres*w/(w'*w);
    % Now we have t_ortho and t to use for the plot

    [rows,cols] = size(metadata);
    [num_new_samples,ignore] = size(inxs_pairing);
    for i = 1:num_new_samples
        metadata{rows+i,1} = sprintf('%d-%d,%s',time_unpaired,time_paired,classification);
        opls_scores(end+1,:) = [t(i),t_ortho(i,:)];
    end

    % Find the index to the description
    desc_inx = -1;
    for i = 1:length(metadata_headers)
     if strcmp(metadata_headers{i},'description')
         desc_inx = i;
         break;
     end
    end
    class_labels = {};
    [rows,cols] = size(metadata);
    for i = 1:rows
     class_labels{i} = [metadata{i,desc_inx}];
    end

    class_inxs = java.util.Hashtable();
    unique_class_labels = {};
    for i = 1:length(class_labels)
        if ~class_inxs.containsKey(class_labels{i})
            unique_class_labels{end+1} = class_labels{i};
            class_inxs.put(class_labels{i},[i]);
        else
            old = class_inxs.get(class_labels{i});
            old(end+1) = i;
            class_inxs.put(class_labels{i},old);
        end
    end
    
    input_cnt = input_cnt + 1;
end

[rows,cols] = size(opls_scores);
[orig_rows,orig_cols] = size(orig_opls_scores);
if orig_rows ~= rows % New data was added
    create_opls_scores_plot(unique_class_labels,class_inxs,class_labels,opls_scores,metadata,metadata_headers);
    %create_pca_plot(unique_class_labels,class_inxs,class_labels,all_Xres,metadata,metadata_headers);
end
