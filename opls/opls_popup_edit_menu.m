function opls_popup_edit_menu(hObject, eventdata, handles)
str = {'Toggle points/error elipses','Edit colors','Edit markers','Edit marker size'};
[sel,v] = listdlg('Name','Edit opls graph','PromptString','Select an action', ...
              'SelectionMode','single','ListString',str);
          
if sel == 1    
    opls_scores = getappdata(gca, 'opls_scores');
    unique_class_labels = getappdata(gca, 'unique_class_labels');
    class_inxs = getappdata(gca, 'class_inxs');
    point_handles = getappdata(gca,'point_handles');
    markers = getappdata(gca, 'markers');
    colors = getappdata(gca, 'colors');
    metadata = getappdata(gca, 'metadata');
    metadata_headers = getappdata(gca, 'metadata_headers');
    elipses = getappdata(gca, 'elipses');
    markersize = getappdata(gca, 'markersize');  
    
    stdErr = {};
    meanPt = {};
    plot_hs = [];
    legend_strs = {};

    prompt = {['Enter ellipse type:',sprintf('\n'),'0 - Display points', ...
    sprintf('\n'),'1 - 1*SE ellipse', sprintf('\n'),'2 - 2*SE ellipse', ...
    sprintf('\n'),'3 - 95% CI ellipse', sprintf('\n'),'4 - 99% CI ellipse',]};
    edit = inputdlg(prompt, 'Edit points/ellipses', 1);
    if isempty(edit)
        return
    end
    
    if ~elipses %switch from 2D points to elipses
       for c = 1:length(unique_class_labels)
            inxs = class_inxs.get(unique_class_labels{c});
            if strcmp(edit,'1')
                stdErr{end+1} = std(opls_scores(inxs,1:2))/sqrt(length(inxs));
                meanPt{end+1} = mean(opls_scores(inxs,1:2));
            elseif strcmp(edit,'2')
                stdErr{end+1} = 2*(std(opls_scores(inxs,1:2))/sqrt(length(inxs)));
                meanPt{end+1} = mean(opls_scores(inxs,1:2));
            elseif strcmp(edit,'3')
                stdErr{end+1} = 1.96*(std(opls_scores(inxs,1:2))/sqrt(length(inxs)));
                meanPt{end+1} = mean(opls_scores(inxs,1:2));
            elseif strcmp(edit,'4')
                stdErr{end+1} = 2.58*(std(opls_scores(inxs,1:2))/sqrt(length(inxs)));
                meanPt{end+1} = mean(opls_scores(inxs,1:2));
            else
                break;
            end
        end
% 
%         %calc std err
%         for c = 1:length(unique_class_labels)
%             inxs = class_inxs.get(unique_class_labels{c});
%             stdErr{end+1} = std(opls_scores(inxs,1:2))/sqrt(length(inxs));
%             meanPt{end+1} = mean(opls_scores(inxs,1:2));
%         end

        %delete previous points
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
            try
                hs = plot(meanPt{c}(1),meanPt{c}(2),markers{mod(c-1,length(markers))+1},'Color',colors{mod(c-1,length(colors))+1},'Markersize',markersize);
                point_handles(c,1) = hs;
                hf = rectangle('Position',[meanPt{c}(1)-stdErr{c}(1),meanPt{c}(2)-stdErr{c}(2),2*stdErr{c}(1),2*stdErr{c}(2)],'Curvature',[1,1],'EdgeColor',colors{mod(c-1,length(colors))+1});
                point_handles(c,2) = hf;           
            catch ME
                disp('blah');
            end
            plot_hs(end+1) = hs;
            hold on

            myfunc2 = @(hObject, eventdata, handles) (opls_popup_edit_menu);
            set(gca,'ButtonDownFcn', myfunc2);
        end
        setappdata(gca, 'elipses', 1);
    else        %else switch from elipses to points
        %delete previous elipses
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
            for i = 1:length(inxs)
                s = inxs(i);
                try
                    hs = plot(opls_scores(s,1),opls_scores(s,2),markers{mod(c-1,length(markers))+1},'Color',colors{mod(c-1,length(colors))+1},'Markersize',markersize);
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
                myfunc = @(hObject, eventdata, handles) (msgbox(message));
                myfunc2 = @(hObject, eventdata, handles) (opls_popup_edit_menu);
                set(hs,'ButtonDownFcn', myfunc);
                set(gca,'ButtonDownFcn', myfunc2);
            end       
        end
        setappdata(gca, 'elipses', 0);
    end
    setappdata(gca,'point_handles',point_handles);
    axis equal
    hold off
    ylabel('T-orthogonal');
    xlabel('T');
    legend(plot_hs,legend_strs);    
elseif sel == 2
    opls_scores = getappdata(gca, 'opls_scores');
    colors = getappdata(gca, 'colors');
    markers = getappdata(gca, 'markers');
    unique_class_labels = getappdata(gca, 'unique_class_labels');
    class_inxs = getappdata(gca, 'class_inxs');
    point_handles = getappdata(gca,'point_handles');
    metadata = getappdata(gca, 'metadata');
    metadata_headers = getappdata(gca, 'metadata_headers');
    elipses = getappdata(gca, 'elipses');
    markersize = getappdata(gca, 'markersize');  
    
    edit_colors = {};
    stdErr = {};
    meanPt = {};
    plot_hs = [];
    legend_strs = {};
    
    for j=1:length(unique_class_labels)
        edit_colors{end+1} = uisetcolor(colors{mod(j-1,length(colors))+1},strcat('Select a color for ',unique_class_labels{j}));
    end
    
    if ~elipses
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
                    hs = plot(opls_scores(s,1),opls_scores(s,2),markers{mod(c-1,length(markers))+1},'Color',edit_colors{c},'Markersize',markersize);
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
                myfunc = @(hObject, eventdata, handles) (msgbox(message));
                myfunc2 = @(hObject, eventdata, handles) (opls_popup_edit_menu);
                set(hs,'ButtonDownFcn', myfunc);
                set(gca,'ButtonDownFcn', myfunc2);
            end       
        end
    else
        %calc std err
        for c = 1:length(unique_class_labels)
            inxs = class_inxs.get(unique_class_labels{c});
            stdErr{end+1} = std(opls_scores(inxs,:))/sqrt(length(inxs));
            meanPt{end+1} = mean(opls_scores(inxs,:));
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
                hs = plot(meanPt{c}(1),meanPt{c}(2),markers{mod(c-1,length(markers))+1},'Color',edit_colors{c},'Markersize',markersize);
                point_handles(c,1) = hs;
                hs = rectangle('Position',[meanPt{c}(1)-stdErr{c}(1),meanPt{c}(2)-stdErr{c}(2),2*stdErr{c}(1),2*stdErr{c}(2)],'Curvature',[1,1],'EdgeColor',edit_colors{c});
                point_handles(c,2) = hs;           
            catch ME
                disp('blah');
             end
           if i == 1
               plot_hs(end+1) = hs;
           end
            hold on
            %handles.figure = gca;
            %handles.lineseries = hs;
            myfunc2 = @(hObject, eventdata, handles) (opls_popup_edit_menu);
            set(gca,'ButtonDownFcn', myfunc2);
        end
    end
    setappdata(gca,'point_handles',point_handles);
    setappdata(gca,'colors',edit_colors);
    axis equal
    hold off
    ylabel('T-orthogonal');
    xlabel('T');
    legend(plot_hs,legend_strs);
    
elseif sel == 3
    %get saved parameters
    opls_scores = getappdata(gca, 'opls_scores');
    unique_class_labels = getappdata(gca, 'unique_class_labels');
    class_inxs = getappdata(gca, 'class_inxs');
    point_handles = getappdata(gca,'point_handles');
    markers = getappdata(gca, 'markers');
    colors = getappdata(gca, 'colors');
    %class_labels = getappdata(gca, 'class_labels');
    metadata = getappdata(gca, 'metadata');
    metadata_headers = getappdata(gca, 'metadata_headers');
    elipses = getappdata(gca, 'elipses');
    markersize = getappdata(gca, 'markersize');  
    
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

       if ~elipses
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
                        hs = plot(opls_scores(s,1),opls_scores(s,2),edit_marker{c},'Color',colors{mod(c-1,length(colors))+1},'Markersize',markersize);
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
                    myfunc = @(hObject, eventdata, handles) (msgbox(message));
                    myfunc2 = @(hObject, eventdata, handles) (opls_popup_edit_menu);
                    set(hs,'ButtonDownFcn', myfunc);
                    set(gca,'ButtonDownFcn', myfunc2);
                end       
            end
       else
            %calc std err
            for c = 1:length(unique_class_labels)
                inxs = class_inxs.get(unique_class_labels{c});
                stdErr{end+1} = std(opls_scores(inxs,:))/sqrt(length(inxs));
                meanPt{end+1} = mean(opls_scores(inxs,:));
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
                    hs = plot(meanPt{c}(1),meanPt{c}(2),edit_marker{c},'Color',colors{mod(c-1,length(colors))+1},'Markersize',markersize);
                    point_handles(c,1) = hs;
                    hs = rectangle('Position',[meanPt{c}(1)-stdErr{c}(1),meanPt{c}(2)-stdErr{c}(2),2*stdErr{c}(1),2*stdErr{c}(2)],'Curvature',[1,1],'EdgeColor',colors{mod(c-1,length(colors))+1});
                    point_handles(c,2) = hs;           
                catch ME
                    disp('blah');
                 end
               if i == 1
                   plot_hs(end+1) = hs;
               end
                hold on
                myfunc2 = @(hObject, eventdata, handles) (opls_popup_edit_menu);
                set(gca,'ButtonDownFcn', myfunc2);
            end
        end
        setappdata(gca,'point_handles',point_handles);
        setappdata(gca,'markers',edit_marker);
        axis equal
        hold off
        ylabel('T-orthogonal');
        xlabel('T');
        legend(plot_hs,legend_strs);
        clear('edit');       
    end
elseif sel == 4
    %get saved parameters
    opls_scores = getappdata(gca, 'opls_scores');
    unique_class_labels = getappdata(gca, 'unique_class_labels');
    class_inxs = getappdata(gca, 'class_inxs');
    point_handles = getappdata(gca,'point_handles');
    markers = getappdata(gca, 'markers');
    colors = getappdata(gca, 'colors');
    %class_labels = getappdata(gca, 'class_labels');
    metadata = getappdata(gca, 'metadata');
    metadata_headers = getappdata(gca, 'metadata_headers');
    elipses = getappdata(gca, 'elipses');
    markersize = getappdata(gca, 'markersize');  
    
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

       if ~elipses
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
                        hs = plot(opls_scores(s,1),opls_scores(s,2),markers{mod(c-1,length(markers))+1},'Color',colors{mod(c-1,length(colors))+1},'Markersize',markersize);
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
                    myfunc = @(hObject, eventdata, handles) (msgbox(message));
                    myfunc2 = @(hObject, eventdata, handles) (opls_popup_edit_menu);
                    set(hs,'ButtonDownFcn', myfunc);
                    set(gca,'ButtonDownFcn', myfunc2);
                end       
            end
       else
            %calc std err
            for c = 1:length(unique_class_labels)
                inxs = class_inxs.get(unique_class_labels{c});
                stdErr{end+1} = std(opls_scores(inxs,:))/sqrt(length(inxs));
                meanPt{end+1} = mean(opls_scores(inxs,:));
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
                    hs = plot(meanPt{c}(1),meanPt{c}(2),markers{mod(c-1,length(markers))+1},'Color',colors{mod(c-1,length(colors))+1},'Markersize',markersize);
                    point_handles(c,1) = hs;
                    hs = rectangle('Position',[meanPt{c}(1)-stdErr{c}(1),meanPt{c}(2)-stdErr{c}(2),2*stdErr{c}(1),2*stdErr{c}(2)],'Curvature',[1,1],'EdgeColor',colors{mod(c-1,length(colors))+1});
                    point_handles(c,2) = hs;           
                catch ME
                    disp('blah');
                 end
               if i == 1
                   plot_hs(end+1) = hs;
               end
                hold on
                myfunc2 = @(hObject, eventdata, handles) (opls_popup_edit_menu);
                set(gca,'ButtonDownFcn', myfunc2);
            end
        end
        setappdata(gca,'point_handles',point_handles);
        setappdata(gca,'markersize',markersize);
        axis equal
        hold off
        ylabel('T-orthogonal');
        xlabel('T');
        legend(plot_hs,legend_strs);
        clear('edit');       
    end
end
