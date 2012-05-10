function create_dendrogram_and_boxplot(group_labels,group_inxs,X)
figure;
subplot1(1,2,'Gap',[0.04 0.04],'Min',[0.15 0.1],'Max',[0.99 0.99],'FontS',8);
subplot1(1);

% Compute the distance matrix
n = length(group_inxs);
c = 1;
dists = NaN*ones(1,(n*(n-1)/2));
labels = {};
for i = 1:length(group_inxs)
    inxs1 = group_inxs{i};
    for j = (i+1):length(group_inxs)        
        inxs2 = group_inxs{j};
        sum_dist = 0;
        num = 0;
        for k = 1:length(inxs1)
            for p = 1:length(inxs2)
                sum_dist = sum_dist + abs(X(inxs1(k))-X(inxs2(p)));
                num = num + 1;
            end
        end
        dists(c) = sum_dist/num;
        labels{c,1} = group_labels{i};
        labels{c,2} = group_labels{j};
        c = c + 1;
    end
end

Z = linkage(dists,'weighted');
[H, T, PERM] = mydendrogram(Z,'ORIENTATION','right');
yticklabels = {group_labels{PERM}};
set(gca,'yticklabel',yticklabels);
set(gca,'fontname','fixedwidth');
xlabel('Distance between clusters');

subplot1(2);
% num_class_labels = zeros(size(class_labels));
% cnt = 1;
order = [];
expanded_yticklabels = {};
for i = 1:length(PERM)
    inxs = group_inxs{PERM(i)};
    order = [order,inxs];
    for j = 1:length(inxs)
        expanded_yticklabels{end+1} = yticklabels{i};
    end
end
%     num_class_labels(inxs1) = i;
%     for j = 1:length(inxs1)
%         order(end+1) = inxs1(j);
%     end
% end
% yticklabels = {class_labels{order}};
% for i = 1:length(yticklabels)
%     yticklabels{i} = regexprep(yticklabels{i},'1-0','d1');
%     yticklabels{i} = regexprep(yticklabels{i},'2-0','d2');
%     yticklabels{i} = regexprep(yticklabels{i},'3-0','d3');
%     yticklabels{i} = regexprep(yticklabels{i},'4-0','d4');
%     fields = split(yticklabels{i},',');
%     yticklabels{i} = sprintf('%2s%10s',fields{1},fields{2});
% end
boxplot(X(order),expanded_yticklabels,'orientation','horizontal');
houtliers=findobj(gca,'tag','Outliers');
for i = 1:length(houtliers)
    set(houtliers(i),'Visible','off');
end
set(gca,'yticklabel',yticklabels);
set(gca,'fontname','fixedwidth');
subplot1(1);
yl = ylim;
subplot1(2);
ylim(yl);
xlabel('T');
% delete(h);

% view(90,90)
% saveas(gcf,'test.png');