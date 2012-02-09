 % Find the index to the description
 desc_inx = -1;
 for i = 1:length(metadata_headers)
     if strcmp(metadata_headers{i},'description')
         desc_inx = i;
         break;
     end
 end
 old_class_labels = class_labels;
 class_labels = {};
 for i = 1:length(old_class_labels);
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
