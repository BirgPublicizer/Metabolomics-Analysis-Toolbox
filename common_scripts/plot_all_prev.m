function plot_all

clear_all_except_regions

collections = getappdata(gcf,'collections');

yhs = [];
% Make sure black
colors = get(gca,'colororder');
nm = size(colors);
offset = -1;
for i = 1:nm(1)
    s = sum(colors(i,:));
    if s == 0
        offset = i;
    end
end
if offset == -1
    colors(end+1,:) = [0,0,0];
    nm = size(colors);
    offset = nm(1);
end
legend_cell = {};
for i = 1:length(collections)
    hl = line(collections{i}.x,collections{i}.Y(:,1),'Color',colors(mod(i+offset-2,length(colors))+1,:));
    myfunc = @(hObject, eventdata, handles) (line_click_info(i,1));
    set(hl,'ButtonDownFcn',myfunc);
    yhs(end+1) = hl;
    % Change the following line if you want to change the legend for
    % each collection
    legend_cell{end+1} = num2str(collections{i}.description);        
end
lh = legend(yhs,legend_cell);
for i = 1:length(collections)
    for j = 2:collections{i}.num_samples
        hl = line(collections{i}.x,collections{i}.Y(:,j),'Color',colors(mod(i+offset-2,length(colors))+1,:));
        myfunc = @(hObject, eventdata, handles) (line_click_info(i,j));
        set(hl,'ButtonDownFcn',myfunc);
        yhs(end+1) = hl;
    end
end
reference = getappdata(gcf,'reference');
if ~isempty(reference)
    yhs(end+1) = line(reference.x,reference.y,'Color','r','LineWidth',2);
end
setappdata(gcf,'yhs',yhs);
setappdata(gcf,'lh',lh);