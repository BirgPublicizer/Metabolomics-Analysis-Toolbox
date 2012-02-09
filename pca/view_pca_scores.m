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
     class_labels{i} = metadata{i,desc_inx};
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

%% Create the plot
if ~exist('no_new_figure') || no_new_figure == false
    figure
end
%% Create list of markers and colors to cycle through
% Make sure black
%colors = get(gca,'colororder');
colors = {[0 0 0],[1 0 0],[0 0 1],[0 1 0],[0 1 1],[1 0 1],[0.8706 0.4902 0],[0.7490 0 0.7490],[0.8471 0.1608 0],[1.0000 0.6000 0.7843],[0 0.4980 0],[0.8314 0.8157 0.7843]};
markers = {'o','x','+','*','s','d','v','^','<','>','p','h','.'};
markersize = 3;
% Actually plot
if ~exist('PC1','var')
    PC1 = 1;
    PC2 = 2;
    PC3 = [];
end
plot_hs = [];
legend_strs = {};
setappdata(gca, 'pca_scores',pca_scores);
setappdata(gca, 'unique_class_labels', unique_class_labels);
setappdata(gca, 'class_inxs', class_inxs);
setappdata(gca, 'markers', markers); 
setappdata(gca, 'markersize', markersize);  
setappdata(gca, 'colors', colors);
%setappdata(gca, 'offset', offset);
setappdata(gca, 'class_labels', class_labels);
setappdata(gca, 'metadata', metadata);
setappdata(gca, 'metadata_headers', metadata_headers);
setappdata(gca, 'ellipses', 0);
setappdata(gca, 'PC1', PC1);
setappdata(gca, 'PC2', PC2);
setappdata(gca, 'PC3', PC3);

for c = 1:length(unique_class_labels)
    inxs = class_inxs.get(unique_class_labels{c});
    legend_strs{end+1} = unique_class_labels{c};
    for i = 1:length(inxs)
        s = inxs(i);
        try
                hs = plot(pca_scores(s,PC1),pca_scores(s,PC2),markers{mod(c-1,length(markers))+1},'Color',colors{mod(c-1,length(colors))+1},'MarkerSize',markersize);
                point_handles(c,i) = hs;
        catch ME
            disp('blah');
        end
        if i == 1
            plot_hs(end+1) = hs;
        end
        hold on
        message = '';
        for h = 1:length(metadata_headers)
            if h > 1
                sh = sprintf('\n');
                message = [message,sh];
            end            
            message = [message,metadata_headers{h},': ',metadata{s,h}];
        end
        handles.figure = gca;
        handles.lineseries = hs;
        myfunc = @(hObject, eventdata, handles) (sample_click_menu(message,c));
        myfunc2 = @(hObject, eventdata, handles) (popup_edit_menu);
        set(hs,'ButtonDownFcn', myfunc);
        set(gca,'ButtonDownFcn', myfunc2);
    end
end
setappdata(gca,'point_handles',point_handles);
axis equal
hold off
ylabel(strcat('PC', num2str(PC2)));
xlabel(strcat('PC', num2str(PC1)));
legend(plot_hs,legend_strs);