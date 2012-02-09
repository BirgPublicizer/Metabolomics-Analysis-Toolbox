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
reference = getappdata(gcf,'reference');
if ~isempty(reference)
    yhs(end+1) = line(reference.x,reference.y,'Color','r','LineWidth',2);
    legend_cell{end+1} = 'Reference';
end
is_bar = getappdata(gcf,'is_bar');
is_paired = getappdata(gcf,'is_paired');
if isempty(is_bar) || ~is_bar
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
    setappdata(gcf,'yhs',yhs);
    setappdata(gcf,'lh',lh);
elseif is_bar && (isempty(is_paired) || ~is_paired)
    x = getappdata(gcf,'x');
    Y = getappdata(gcf,'Y');
    collections = getappdata(gcf,'collections');
    legend_cell = {};
    % Now correct the order of the graph to put all of the subjects next to
    % each other
    hold on
    yhs = bar(x,Y);
    hold off
    legend_hs = [];
    inx = 1;
    for i = 1:length(collections)
        for j = 1:collections{i}.num_samples
            if j == 1
                legend_hs(end+1) = yhs(inx);
                legend_cell{end+1} = collections{i}.description;
            end
            set(yhs(inx),'FaceColor',colors(mod(i+offset-2,length(colors))+1,:));
            set(yhs(inx),'EdgeColor',colors(mod(i+offset-2,length(colors))+1,:));
            inx = inx + 1;
        end
    end
    lh = legend(legend_hs(end:-1:1),legend_cell{end:-1:1});
    setappdata(gcf,'yhs',yhs);
    setappdata(gcf,'lh',lh);    
elseif is_bar && ~isempty(is_paired) && is_paired
    x = getappdata(gcf,'x');
    Y = getappdata(gcf,'Y');
    collections = getappdata(gcf,'collections');
    subject_id = [];
    time = [];
    legend_cell = {};
    for c = 1:length(collections)
        for s = 1:collections{c}.num_samples
            subject_id(end+1) = collections{c}.subject_id(s);
            time(end+1) = collections{c}.time(s);
            legend_cell{end+1} = [num2str(subject_id(end)),' ',collections{c}.description];
        end
    end
    % Reroder the samples
    inxs = {};
    mask = zeros(1,length(subject_id));
    for i = 1:length(subject_id)
        inxs{i} = [];
        if mask(i) % Already marked
            continue;
        end
        for j = 1:length(subject_id)
            if mask(j)
                continue;
            end
            if subject_id(i) == subject_id(j)
                inxs{i}(end+1) = j;
                mask(j) = 1;
            end
        end
    end
    reorder_inxs = [];
    for i = 1:length(inxs)
        if ~isempty(inxs)
            temp = time(inxs{i});
            [vs,tinxs] = sort(temp,'descend');
            inxs{i} = inxs{i}(tinxs);
            reorder_inxs = [reorder_inxs,inxs{i}];
        end
    end
    % Now correct the order of the graph to put all of the subjects next to
    % each other
    hold on
    yhs = bar(x,Y(:,reorder_inxs));
    hold off
    legend_hs = [];
    inx = 1;
    for i = 1:length(inxs)
        for j = 1:length(inxs{i})
            if ~isempty(inxs{i})
                set(yhs(inx),'FaceColor',colors(mod(j+offset-2,length(colors))+1,:));
                set(yhs(inx),'EdgeColor',colors(mod(j+offset-2,length(colors))+1,:));
                legend_hs(inx) = yhs(inx);
                inx = inx + 1;
            end
        end
    end
    lh = legend(legend_hs(end:-1:1),legend_cell{reorder_inxs(end:-1:1)});
    setappdata(gcf,'yhs',yhs);
    setappdata(gcf,'lh',lh);
end