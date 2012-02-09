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

% Compute the distance matrix
n = length(unique_class_labels);
c = 1;
dists = NaN*ones(1,(n*(n-1)/2));
labels = {};
for i = 1:length(unique_class_labels)
    inxs1 = find(strcmp(unique_class_labels{i},class_labels) == 1);
    for j = (i+1):length(unique_class_labels)        
        inxs2 = find(strcmp(unique_class_labels{j},class_labels) == 1);
        sum_dist = 0;
        num = 0;
        for k = 1:length(inxs1)
            for p = 1:length(inxs2)
                sum_dist = sum_dist + abs(opls_scores(inxs1(k),1)-opls_scores(inxs2(p),1));
                num = num + 1;
            end
        end
        dists(c) = sum_dist/num;
        labels{c,1} = unique_class_labels{i};
        labels{c,2} = unique_class_labels{j};
        c = c + 1;
    end
end

Z = linkage(dists,'weighted');
I = cluster(Z,'maxclust',7);
new_unique_class_labels = {};
new_class_labels = {};
for i = 1:max(I)
    inxs = find(i == I);
    new_unique_class_labels{end+1} = '';
    for j = 1:length(inxs)
        if j == 1
            new_unique_class_labels{end} = [new_unique_class_labels{end},unique_class_labels{inxs(j)}];
        else
            new_unique_class_labels{end} = [new_unique_class_labels{end},';',unique_class_labels{inxs(j)}];
        end       
    end
    for j = 1:length(inxs)
        inxs2 = find(strcmp(unique_class_labels{inxs(j)},class_labels));
        for z = 1:length(inxs2)
            new_class_labels{inxs2(z)} = new_unique_class_labels{end};
        end
    end
end
% Compute the new distance matrix
n = length(new_unique_class_labels);
c = 1;
dists = NaN*ones(1,(n*(n-1)/2));
labels = {};
for i = 1:length(new_unique_class_labels)
    inxs1 = find(strcmp(new_unique_class_labels{i},new_class_labels) == 1);
    for j = (i+1):length(new_unique_class_labels)        
        inxs2 = find(strcmp(new_unique_class_labels{j},new_class_labels) == 1);
        sum_dist = 0;
        num = 0;
        for k = 1:length(inxs1)
            for p = 1:length(inxs2)
                sum_dist = sum_dist + abs(opls_scores(inxs1(k),1)-opls_scores(inxs2(p),1));
                num = num + 1;
            end
        end
        dists(c) = sum_dist/num;
        labels{c,1} = new_unique_class_labels{i};
        labels{c,2} = new_unique_class_labels{j};
        c = c + 1;
    end
end
Z = linkage(dists,'weighted');
[H, T, PERM] = mydendrogram(Z,'ORIENTATION','right');
% yticklabels = {new_unique_class_labels{PERM}};
% for i = 1:length(yticklabels)
%     yticklabels{i} = regexprep(yticklabels{i},'1-0','d1');
%     yticklabels{i} = regexprep(yticklabels{i},'2-0','d2');
%     yticklabels{i} = regexprep(yticklabels{i},'3-0','d3');
%     yticklabels{i} = regexprep(yticklabels{i},'4-0','d4');
% %     fields = split(yticklabels{i},',');
% %     yticklabels{i} = sprintf('%2s%10s',fields{1},fields{2});
% end
% set(gca,'yticklabel',yticklabels);
set(gca,'yticklabel',split(num2str(length(PERM):-1:1),'  '));
for i = 1:length(PERM)
    fprintf('%d\t%s\n',i,new_unique_class_labels{PERM(length(PERM)-i+1)});
end

% set(gca,'fontname','fixedwidth');

% view(90,90)
% saveas(gcf,'test.png');