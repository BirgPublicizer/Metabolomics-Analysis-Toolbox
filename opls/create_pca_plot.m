function create_pca_plot(unique_class_labels,class_inxs,class_labels,Xres,metadata,metadata_headers)
[COEFF,SCORE,latent,tsquare] = princomp(Xres);
percentages = 100*cumsum(latent)./sum(latent);
fprintf('Cumulative percent variance explained: \n');
fprintf('PC1: %f\n',percentages(1));
fprintf('PC2: %f\n',percentages(2));
fprintf('PC3: %f\n',percentages(3));
%% Create the plot
figure
%% Create list of markers and colors to cycle through
colors = {[0 0 0],[1 0 0],[0 0 1],[0 1 0],[0 1 1],[1 0 1],[0.8706 0.4902 0],[0.7490 0 0.7490],[0.8471 0.1608 0],[1.0000 0.6000 0.7843],[0 0.4980 0],[0.8314 0.8157 0.7843]};
markers = {'o','x','+','*','s','d','v','^','<','>','p','h','.'};
markersize = 6;
% save parameters
setappdata(gca, 'pca_scores',SCORE);
setappdata(gca, 'unique_class_labels', unique_class_labels);
setappdata(gca, 'class_inxs', class_inxs);
setappdata(gca, 'markers', markers);
setappdata(gca, 'colors', colors);
setappdata(gca, 'markersize', markersize);
%setappdata(gca, 'offset', offset);
setappdata(gca, 'class_labels', class_labels);
setappdata(gca, 'metadata', metadata);
setappdata(gca, 'metadata_headers', metadata_headers);
setappdata(gca, 'PC1', 1);
setappdata(gca, 'PC2', 2);
setappdata(gca, 'PC3', 3);

% Actually plot
plot_hs = [];
legend_strs = {};
for c = 1:length(unique_class_labels)
    inxs = class_inxs.get(unique_class_labels{c});
    legend_strs{end+1} = unique_class_labels{c};
    for i = 1:length(inxs)
        s = inxs(i);
        try
            hs = plot(SCORE(s,1),SCORE(s,2),markers{mod(c-1,length(markers))+1},'Color',colors{mod(c-1,length(colors))+1},'MarkerSize',6);
            point_handles(c,i) = hs;
        catch ME
            disp('ERROR inside create_pca_plot');
        end
        if i == 1
            plot_hs(end+1) = hs;
        end
        hold on
        message = '';
        for h = 1:length(metadata_headers)
            if h > 1
                st = sprintf('\n');
                message = [message,st];
            end            
            message = [message,metadata_headers{h},': ',metadata{s,h}];
        end
        myfunc = @(hObject, eventdata, handles) (msgbox(message));
        myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
        set(hs,'ButtonDownFcn', myfunc);
        set(gca,'ButtonDownFcn', myfunc2);
    end
end
setappdata(gca,'point_handles',point_handles);
setappdata(gca, 'elipses', 0);
axis equal;
hold off;
ylabel('PC2');
xlabel('PC1');
legend(plot_hs,legend_strs);