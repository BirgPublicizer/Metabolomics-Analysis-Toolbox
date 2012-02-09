ellipse_strings = {'1 standard error','2 standard errors', ...
                '95% confidence interval','99% confidence interval'};
pca_scores = getappdata(gca, 'pca_scores');
unique_class_labels = getappdata(gca, 'unique_class_labels');
class_inxs = getappdata(gca, 'class_inxs');
point_handles = getappdata(gca,'point_handles');
markers = getappdata(gca, 'markers');
colors = getappdata(gca, 'colors');
%class_labels = getappdata(gca, 'class_labels');
metadata = getappdata(gca, 'metadata');
metadata_headers = getappdata(gca, 'metadata_headers');
ellipses = getappdata(gca, 'ellipses');
markersize = getappdata(gca, 'markersize');  
PC1 = getappdata(gca, 'PC1');
PC2 = getappdata(gca, 'PC2');
PC3 = getappdata(gca, 'PC3');

stdErr = {};
meanPt = {};
plot_hs = [];
legend_strs = {};

edit = {'1'};
if ~isempty(edit)              %see if user hit cancel
    old_ellipses = ellipses;
    ellipses = str2num(edit{1});  

    if (ellipses ~= 0) && (~isempty(PC3))  % to 3D ellipses
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
        if old_ellipses == 0
            for c = 1:length(unique_class_labels)
                inxs = class_inxs.get(unique_class_labels{c});
                for i = 1:length(inxs)
                    delete(point_handles(c,i));
                    point_handles(c,i) = 0;
                end
            end
        else
            for c = 1:length(unique_class_labels)
                inxs = class_inxs.get(unique_class_labels{c});
                for i = 1:2
                    delete(point_handles(c,i));
                    point_handles(c,i) = 0;
                end
            end
        end

        for c = 1:length(unique_class_labels)
            inxs = class_inxs.get(unique_class_labels{c});
            legend_strs{end+1} = unique_class_labels{c};
            try
                [x, y, z] = ellipsoid(meanPt{c}(PC1),meanPt{c}(PC2),meanPt{c}(PC3),stdErr{c}(PC1),stdErr{c}(PC2),stdErr{c}(PC3),30);
                hf = surf(x, y, z, 'FaceColor',colors{mod(c-1,length(colors))+1});
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
                hs = plot3(meanPt{c}(PC1),meanPt{c}(PC2),meanPt{c}(PC3),markers{mod(c-1,length(markers))+1},'Color',colors{mod(c-1,length(colors))+1},'MarkerSize',markersize);
                point_handles(c,1) = hs;
                plot_hs(end+1) = hs;
                message = ['Class label: ', unique_class_labels{c},sprintf('\n'),'Ellipse type: ', ellipse_strings{ellipses}];                
                myfunc = @(hObject, eventdata, handles) (sample_click_menu(message,c));
                set(hs,'ButtonDownFcn', myfunc);

        end

    elseif ellipses~=0     %to 2D ellipses
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
        if old_ellipses == 0
            for c = 1:length(unique_class_labels)
                inxs = class_inxs.get(unique_class_labels{c});
                for i = 1:length(inxs)
                    delete(point_handles(c,i));
                    point_handles(c,i) = 0;
                end
            end
        else
            for c = 1:length(unique_class_labels)
                inxs = class_inxs.get(unique_class_labels{c});
                for i = 1:2
                    delete(point_handles(c,i));
                    point_handles(c,i) = 0;
                end
            end
        end

        for c = 1:length(unique_class_labels)
            inxs = class_inxs.get(unique_class_labels{c});
            legend_strs{end+1} = unique_class_labels{c};
            try
                hs = plot(meanPt{c}(PC1),meanPt{c}(PC2),markers{mod(c-1,length(markers))+1},'Color',colors{mod(c-1,length(colors))+1},'MarkerSize',markersize);
                point_handles(c,1) = hs;
                message = ['Class label: ', unique_class_labels{c},sprintf('\n'),'Ellipse type: ', ellipse_strings{ellipses}];                
                myfunc = @(hObject, eventdata, handles) (sample_click_menu(message,c));
                set(hs,'ButtonDownFcn', myfunc);
                hf = rectangle('Position',[meanPt{c}(PC1)-stdErr{c}(PC1),meanPt{c}(PC2)-stdErr{c}(PC2),2*stdErr{c}(PC1),2*stdErr{c}(PC2)],'Curvature',[1,1],'EdgeColor',colors{mod(c-1,length(colors))+1});
                point_handles(c,2) = hf;           
            catch ME
                disp('blah');
            end
            plot_hs(end+1) = hs;
            hold on
            myfunc2 = @(hObject, eventdata, handles) (popup_edit_menu);
            set(gca,'ButtonDownFcn', myfunc2);
        end

    else        %else switch from ellipses to points
        %delete previous ellipses
        if old_ellipses == 0
            for c = 1:length(unique_class_labels)
                inxs = class_inxs.get(unique_class_labels{c});
                for i = 1:length(inxs)
                    delete(point_handles(c,i));
                    point_handles(c,i) = 0;
                end
            end
        else
            for c = 1:length(unique_class_labels)
                inxs = class_inxs.get(unique_class_labels{c});
                for i = 1:2
                    delete(point_handles(c,i));
                    point_handles(c,i) = 0;
                end
            end
        end

        for c = 1:length(unique_class_labels)
            inxs = class_inxs.get(unique_class_labels{c});
            legend_strs{end+1} = unique_class_labels{c};
            for i = 1:length(inxs)
                s = inxs(i);
                try
                    if isempty(PC3)
                        hs = plot(pca_scores(s,PC1),pca_scores(s,PC2),markers{mod(c-1,length(markers))+1},'Color',colors{mod(c-1,length(colors))+1},'MarkerSize',markersize);
                    else
                        hs = plot3(pca_scores(s,PC1),pca_scores(s,PC2),pca_scores(s,PC3),markers{mod(c-1,length(markers))+1},'Color',colors{mod(c-1,length(colors))+1},'MarkerSize',markersize);
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
    end
    setappdata(gca, 'ellipses', ellipses);
    setappdata(gca,'point_handles',point_handles);
    axis equal
    hold off
    zlabel(strcat('PC', num2str(PC3)));
    ylabel(strcat('PC', num2str(PC2)));
    xlabel(strcat('PC', num2str(PC1)));
    legend(plot_hs,legend_strs);   
end
