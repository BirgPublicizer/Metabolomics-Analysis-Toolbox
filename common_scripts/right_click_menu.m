function right_click_menu(hObject, eventdata, handles)
str = {'Load collection'};
[s,v] = listdlg('PromptString','Select an action',...
              'SelectionMode','single',...
              'ListString',str);
          
if s == 1
    collections = load_collections
    %save_collections(collections);
    colors = get(gca,'colororder')
    legend_cell = {};
    for i = 1:length(collections)
        hl = line(collections{i}.x,collections{i}.Y(:,1),'Color',colors(mod(i,length(colors)),:));
        myfunc = @(hObject, eventdata, handles) (line_click_info(collections{i},1));
        set(hl,'ButtonDownFcn',myfunc)
        % Change the following line if you want to change the legend for
        % each collection
        legend_cell{end+1} = num2str(collections{i}.description);
    end
    legend(legend_cell);
    for i = 1:length(collections)
        for j = 2:collections{i}.num_samples
            hl = line(collections{i}.x,collections{i}.Y(:,j),'Color',colors(mod(i,length(colors)),:));
            myfunc = @(hObject, eventdata, handles) (line_click_info(collections{i},j));
            set(hl,'ButtonDownFcn',myfunc)
        end
    end
end