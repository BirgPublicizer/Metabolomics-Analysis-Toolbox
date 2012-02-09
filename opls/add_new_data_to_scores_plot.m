function [metadata,metadata_headers,opls_scores] = add_new_data_to_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores)
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

%%%%%%%%%%
% Now apply to new data
%%%%%%%%%%

collection = get_collection;

t_ortho = [];

Xres = bsxfun(@minus,collection.Y',mean(X));
for iter = 1:num_opls_fact
    %run OSC filter on Xres
    t_ortho(:,iter) = Xres*w_ortho(:,iter) / (w_ortho(:,iter)'*w_ortho(:,iter));
    Xres = Xres - t_ortho(:,iter)*p_ortho(:,iter)';
end    

t = Xres*w/(w'*w);
% Now we have t_ortho and t to use for the plot

try
[rows,cols] = size(metadata);
for i = 1:collection.num_samples
    for j = 1:length(metadata_headers)
        if isfield(collection,metadata_headers{j})
            metadata{rows+i,j} = collection.(metadata_headers{j});
        elseif strcmp(metadata_headers{j},'unit_weights')
            if iscell(collection.units_of_weight)
                metadata{rows+i,j} = collection.units_of_weight{i};
            elseif length(collection.units_of_weight) == collection.num_samples
                metadata{rows+i,j} = collection.units_of_weight(i);
            else
                metadata{rows+i,j} = collection.units_of_weight;
            end            
        else % The s was removed
            if iscell(collection.(metadata_headers{j}(1:end-1)))
                metadata{rows+i,j} = collection.(metadata_headers{j}(1:end-1)){i};
            elseif length(collection.(metadata_headers{j}(1:end-1))) == collection.num_samples
                metadata{rows+i,j} = collection.(metadata_headers{j}(1:end-1))(i);
            else
                metadata{rows+i,j} = collection.(metadata_headers{j}(1:end-1));
            end
        end
    end
    opls_scores(end+1,:) = [t(i),t_ortho(i,:)];
end
catch ME
    disp('here');
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

create_opls_scores_plot(unique_class_labels,class_inxs,class_labels,opls_scores,metadata,metadata_headers);
