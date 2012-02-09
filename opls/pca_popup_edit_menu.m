function pca_popup_edit_menu(hObject, eventdata, handles)
str = {'Edit axes','Edit points/ellipses','Edit colors','Edit markers','Edit marker size'};
[sel,v] = listdlg('Name','Edit PCA graph','PromptString','Select an action', ...
                'SelectionMode','single','ListString',str);
ellipse_strings = {'1 standard error','2 standard errors', ...
                '95% confidence interval','99% confidence interval'};

          
if sel == 1
    %get saved parameters
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
    PC1 = getappdata(gca,'PC1');
    PC2 = getappdata(gca,'PC2');
    PC3 = getappdata(gca,'PC3');
    
    plot_hs = [];
    legend_strs = {};
    defans = {};
    stdErr = {};
    meanPt = {};
    
    for k=1:3
        defans{end+1} = num2str(eval(strcat('PC',num2str(k)))); 
    end    
    prompt={'X-axis (PC column number)', 'Y-axis (PC column number)', 'Z-axis (blank for 2-D)'};
    fields = {'PC1','PC2', 'PC3'};
    edit = inputdlg(prompt, 'Edit axes', 1, defans);
    if ~isempty(edit)              %see if user hit cancel
        edit = cell2struct(edit,fields);
        PC1 = str2num(edit.PC1);   %convert string to number
        PC2 = str2num(edit.PC2);
        PC3 = str2num(edit.PC3);

        if ~ellipses   
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
                    handles.figure = gca;
                    handles.lineseries = hs;
                    myfunc = @(hObject, eventdata, handles) (sample_click_menu(message,c));
                    myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
                    set(hs,'ButtonDownFcn', myfunc);
                    set(gca,'ButtonDownFcn', myfunc2);
                end       
            end
        elseif (ellipses) && (~isempty(PC3))
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
                    hf = surf(x, y, z, 'FaceColor',colors{mod(c-1,length(colors))+1});
                    %colormap(colors{mod(c-1,length(colors))+1});
                    point_handles(c,2) = hf;
                    alpha(.2);
                catch ME
                    disp('blah');
                end
                hold on
                myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
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
        else
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

            %delete previous ellipses
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
               if i == 1
                   plot_hs(end+1) = hs;
               end
                hold on
                handles.figure = gca;
                handles.lineseries = hs;
                myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
                set(gca,'ButtonDownFcn', myfunc2);
            end
            
        end
        setappdata(gca,'point_handles',point_handles);
        setappdata(gca,'PC1',PC1);
        setappdata(gca,'PC2',PC2);
        setappdata(gca,'PC3',PC3);
        axis equal
        hold off
        zlabel(strcat('PC', num2str(PC3)));
        ylabel(strcat('PC', num2str(PC2)));
        xlabel(strcat('PC', num2str(PC1)));
        legend(plot_hs,legend_strs);
        clear('edit');
    end
    
elseif sel == 2
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
    
   prompt = {['Enter ellipse type:',sprintf('\n'),'0 - Display points', ...
       sprintf('\n'),'1 - 1*SE ellipse', sprintf('\n'),'2 - 2*SE ellipse', ...
       sprintf('\n'),'3 - 95% CI ellipse', sprintf('\n'),'4 - 99% CI ellipse',]};    
   defans = {num2str(ellipses)};
    edit = inputdlg(prompt, 'Edit points/ellipses', 1, defans);
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
                myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
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
                        try
                            delete(point_handles(c,i));
                        catch ME
                        end
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
                myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
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
                        try
                            delete(point_handles(c,i));
                        catch ME
                        end
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
                    myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
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
elseif sel == 3
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
        edit_colors{end+1} = uisetcolor(colors{mod(j-1,length(colors))+1},strcat('Select a color for ',unique_class_labels{j}));
    end
    
    if ~ellipses
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
                myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
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
            myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
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
            myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
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
    
elseif sel == 4
    %get saved parameters
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
    prompt={};
    defans={};
    fields = {};
    edit_marker = {};
    
    for j=1:length(unique_class_labels)
       prompt{end+1} = strcat(unique_class_labels{j},' marker (o,x,+,*,s,d,v,^,<,>,p,h,.)');
       defans{end+1} = markers{mod(j-1,length(markers))+1};
       fields{end+1} = strcat('marker',num2str(j));
    end
    edit = inputdlg(prompt, 'Edit markers', 1, defans);
    if ~isempty(edit)              %see if user hit cancel
       edit = cell2struct(edit,fields);
       for k=1:length(unique_class_labels)
           edit_marker{end+1} = eval(strcat('edit.',strcat('marker',num2str(k))));
       end    

       if ~ellipses
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
                            hs = plot(pca_scores(s,PC1),pca_scores(s,PC2),edit_marker{c},'Color',colors{mod(c-1,length(colors))+1},'MarkerSize',markersize);
                        else
                            hs = plot3(pca_scores(s,PC1),pca_scores(s,PC2),pca_scores(s,PC3),edit_marker{c},'Color',colors{mod(c-1,length(colors))+1},'MarkerSize',markersize);
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
                    myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
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
                    hs = plot(meanPt{c}(PC1),meanPt{c}(PC2),edit_marker{c},'Color',colors{mod(c-1,length(colors))+1},'MarkerSize',markersize);
                    point_handles(c,1) = hs;
                    message = ['Class label: ', unique_class_labels{c},sprintf('\n'),'Ellipse type: ', ellipse_strings{ellipses}];                
                    myfunc = @(hObject, eventdata, handles) (sample_click_menu(message,c));
                    set(hs,'ButtonDownFcn', myfunc);
                    hf = rectangle('Position',[meanPt{c}(PC1)-stdErr{c}(PC1),meanPt{c}(PC2)-stdErr{c}(PC2),2*stdErr{c}(PC1),2*stdErr{c}(PC2)],'Curvature',[1,1],'EdgeColor',colors{mod(c-1,length(colors))+1});
                    point_handles(c,2) = hf;           
                catch ME
                    disp('blah');
                 end
               if i == 1
                   plot_hs(end+1) = hs;
               end
                hold on
                myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
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
                    hf = surf(x, y, z, 'FaceColor',colors{mod(c-1,length(colors))+1});
                    %colormap(colors{mod(c-1,length(colors))+1});
                    point_handles(c,2) = hf;
                    alpha(.2);
                catch ME
                    disp('blah');
                end
                hold on
                myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
                set(gca,'ButtonDownFcn', myfunc2);
            end
            for c = 1:length(unique_class_labels)
                    hs = plot3(meanPt{c}(PC1),meanPt{c}(PC2),meanPt{c}(PC3),edit_marker{c},'Color',colors{mod(c-1,length(colors))+1},'MarkerSize',markersize);
                    point_handles(c,1) = hs;
                    plot_hs(end+1) = hs;
                    message = ['Class label: ', unique_class_labels{c},sprintf('\n'),'Ellipse type: ', ellipse_strings{ellipses}];                
                    myfunc = @(hObject, eventdata, handles) (sample_click_menu(message,c));
                    set(hs,'ButtonDownFcn', myfunc);
            end
        end
        setappdata(gca,'point_handles',point_handles);
        setappdata(gca,'markers',edit_marker);
        axis equal
        hold off
        zlabel(strcat('PC', num2str(PC3)));
        ylabel(strcat('PC', num2str(PC2)));
        xlabel(strcat('PC', num2str(PC1)));
        legend(plot_hs,legend_strs);
        clear('edit');       
    end
    
elseif sel == 5
     %get saved parameters
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
   prompt = {'Marker size (in pts)'};
   defans = {num2str(markersize)};
   %fields = {'markersize'};
   
    edit = inputdlg(prompt, 'Edit marker size', 1, defans);
    if ~isempty(edit)              %see if user hit cancel
       markersize = str2num(edit{1});

       if ~ellipses
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
                    myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
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
               if i == 1
                   plot_hs(end+1) = hs;
               end
                hold on
                myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
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
                    hf = surf(x, y, z, 'FaceColor',colors{mod(c-1,length(colors))+1});
                    %colormap(colors{mod(c-1,length(colors))+1});
                    point_handles(c,2) = hf;
                    alpha(.2);
                catch ME
                    disp('blah');
                end
                hold on
                myfunc2 = @(hObject, eventdata, handles) (pca_popup_edit_menu);
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
        end
        setappdata(gca,'point_handles',point_handles);
        setappdata(gca,'markersize',markersize);
        axis equal
        hold off
        zlabel(strcat('PC', num2str(PC3)));
        ylabel(strcat('PC', num2str(PC2)));
        xlabel(strcat('PC', num2str(PC1)));
        legend(plot_hs,legend_strs);
        clear('edit');       
    end
    
end
