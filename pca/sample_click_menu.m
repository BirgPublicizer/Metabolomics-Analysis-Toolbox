function sample_click_menu(message, label_clicked)

ellipse_strings = {'1 standard error','2 standard errors', ...
                '95% confidence interval','99% confidence interval'};

if strcmp(get(gcf,'SelectionType'),'alt')
    pca_scores = getappdata(gca, 'pca_scores');
    colors = getappdata(gca, 'colors');
    markers = getappdata(gca, 'markers');
    unique_class_labels = getappdata(gca, 'unique_class_labels');
    class_inxs = getappdata(gca, 'class_inxs');
    point_handles = getappdata(gca,'point_handles');
    metadata = getappdata(gca, 'metadata');
    metadata_headers = getappdata(gca, 'metadata_headers');
    ellipses = getappdata(gca, 'ellipses');
    markersize = getappdata(gca, 'markersize');  
    PC1 = getappdata(gca, 'PC1');
    PC2 = getappdata(gca, 'PC2');
    PC3 = getappdata(gca, 'PC3');
    
    edit_colors = {};
    stdErr = {};
    meanPt = {};
    plot_hs = [];
    legend_strs = {};
    
    for j=1:length(unique_class_labels)
        if j==label_clicked
            edit_colors{end+1} = uisetcolor(colors{mod(j-1,length(colors))+1},strcat('Select a color for ',unique_class_labels{j}));
        else
            edit_colors{end+1} = colors{mod(j-1,length(colors))+1};
        end
    end
    
    if ellipses == 0
        for c = 1:length(unique_class_labels)
            inxs = class_inxs.get(unique_class_labels{c});
            for i = 1:length(inxs)
                delete(point_handles(c,i));
                point_handles(c,i) = 0;
            end
        end

        for c = 1:length(unique_class_labels)
            inxs = class_inxs.get(unique_class_labels{c});
            legend_strs{end+1} = unique_class_labels{c};
            for i = 1:length(inxs)
                s = inxs(i);
                try
                    if isempty(PC3)
                        hs = plot(pca_scores(s,PC1),pca_scores(s,PC2),markers{mod(c-1,length(markers))+1},'Color',edit_colors{c},'MarkerSize',markersize);
                    else
                        hs = plot3(pca_scores(s,PC1),pca_scores(s,PC2),pca_scores(s,PC3),markers{mod(c-1,length(markers))+1},'Color',edit_colors{c},'MarkerSize',markersize);
                    end
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
                myfunc = @(hObject, eventdata, handles) (sample_click_menu(message,c));
                myfunc2 = @(hObject, eventdata, handles) (popup_edit_menu);
                set(hs,'ButtonDownFcn', myfunc);
                set(gca,'ButtonDownFcn', myfunc2);
            end       
        end
    elseif isempty(PC3)
        %calc std err
        for c = 1:length(unique_class_labels)
            inxs = class_inxs.get(unique_class_labels{c});
            if ellipses == 1
                stdErr{end+1} = std(pca_scores(inxs,:))/sqrt(length(inxs));
                meanPt{end+1} = mean(pca_scores(inxs,:));
            elseif ellipses == 2
                stdErr{end+1} = 2*(std(pca_scores(inxs,:))/sqrt(length(inxs)));
                meanPt{end+1} = mean(pca_scores(inxs,:));
            elseif ellipses == 3
                stdErr{end+1} = 1.96*(std(pca_scores(inxs,:))/sqrt(length(inxs)));
                meanPt{end+1} = mean(pca_scores(inxs,:));
            elseif ellipses == 4
                stdErr{end+1} = 2.58*(std(pca_scores(inxs,:))/sqrt(length(inxs)));
                meanPt{end+1} = mean(pca_scores(inxs,:));
            else
                ellipses = oldellipses;
                break;
            end
              
        end

        %delete previous points
        for c = 1:length(unique_class_labels)
            inxs = class_inxs.get(unique_class_labels{c});
            for i = 1:2
                delete(point_handles(c,i));
                point_handles(c,i) = 0;
            end
        end

        for c = 1:length(unique_class_labels)
            inxs = class_inxs.get(unique_class_labels{c});
            legend_strs{end+1} = unique_class_labels{c};
            try
                hs = plot(meanPt{c}(PC1),meanPt{c}(PC2),markers{mod(c-1,length(markers))+1},'Color',edit_colors{c},'MarkerSize',markersize);
                point_handles(c,1) = hs;
                message = ['Class label: ', unique_class_labels{c},sprintf('\n'),'Ellipse type: ', ellipse_strings{ellipses}];                
                myfunc = @(hObject, eventdata, handles) (sample_click_menu(message,c));
                set(hs,'ButtonDownFcn', myfunc);
                hf = rectangle('Position',[meanPt{c}(PC1)-stdErr{c}(PC1),meanPt{c}(PC2)-stdErr{c}(PC2),2*stdErr{c}(PC1),2*stdErr{c}(PC2)],'Curvature',[1,1],'EdgeColor',edit_colors{c});
                point_handles(c,2) = hf;           
            catch ME
                disp('blah');
             end
           if i == 1
               plot_hs(end+1) = hs;
           end
            hold on
            %handles.figure = gca;
            %handles.lineseries = hs;
            myfunc2 = @(hObject, eventdata, handles) (popup_edit_menu);
            set(gca,'ButtonDownFcn', myfunc2);
        end
    else
        for c = 1:length(unique_class_labels)
            inxs = class_inxs.get(unique_class_labels{c});
            if ellipses == 1
                stdErr{end+1} = std(pca_scores(inxs,:))/sqrt(length(inxs));
                meanPt{end+1} = mean(pca_scores(inxs,:));
            elseif ellipses == 2
                stdErr{end+1} = 2*(std(pca_scores(inxs,:))/sqrt(length(inxs)));
                meanPt{end+1} = mean(pca_scores(inxs,:));
            elseif ellipses == 3
                stdErr{end+1} = 1.96*(std(pca_scores(inxs,:))/sqrt(length(inxs)));
                meanPt{end+1} = mean(pca_scores(inxs,:));
            elseif ellipses == 4
                stdErr{end+1} = 2.58*(std(pca_scores(inxs,:))/sqrt(length(inxs)));
                meanPt{end+1} = mean(pca_scores(inxs,:));
            else
                ellipses = oldellipses;
                break;
            end
              
        end

        %delete previous points
        for c = 1:length(unique_class_labels)
            inxs = class_inxs.get(unique_class_labels{c});
            for i = 1:2
                delete(point_handles(c,i));
                point_handles(c,i) = 0;
            end
        end        
        for c = 1:length(unique_class_labels)
            inxs = class_inxs.get(unique_class_labels{c});
            legend_strs{end+1} = unique_class_labels{c};
            try
                [x, y, z] = ellipsoid(meanPt{c}(PC1),meanPt{c}(PC2),meanPt{c}(PC3),stdErr{c}(PC1),stdErr{c}(PC2),stdErr{c}(PC3),30);
                hf = surf(x, y, z, 'FaceColor',edit_colors{c});
                %colormap(colors{mod(c-1,length(colors))+1});
                point_handles(c,2) = hf;
                alpha(.2);
            catch ME
                disp('blah');
            end
            hold on
            myfunc2 = @(hObject, eventdata, handles) (popup_edit_menu);
            set(gca,'ButtonDownFcn', myfunc2);
        end
        for c = 1:length(unique_class_labels)
                hs = plot3(meanPt{c}(PC1),meanPt{c}(PC2),meanPt{c}(PC3),markers{mod(c-1,length(markers))+1},'Color',edit_colors{c},'MarkerSize',markersize);
                point_handles(c,1) = hs;
                plot_hs(end+1) = hs;
                message = ['Class label: ', unique_class_labels{c},sprintf('\n'),'Ellipse type: ', ellipse_strings{ellipses}];                
                myfunc = @(hObject, eventdata, handles) (sample_click_menu(message,c));
                set(hs,'ButtonDownFcn', myfunc);
                
        end
    end
    setappdata(gca,'point_handles',point_handles);
    setappdata(gca,'colors',edit_colors);
    axis equal
    hold off
    zlabel(strcat('PC', num2str(PC3)));
    ylabel(strcat('PC', num2str(PC2)));
    xlabel(strcat('PC', num2str(PC1)));
    legend(plot_hs,legend_strs);
else
    msgbox(message);
end

