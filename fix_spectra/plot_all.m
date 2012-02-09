function plot_all
clear_all_except_regions

collections = getappdata(gcf,'collections');
c = getappdata(gcf,'collection_inx');
s = getappdata(gcf,'spectrum_inx');

add = 0;
if sum(abs(collections{c}.Y_fixed(:,s))) > 0 % Fixed answer available
    add = 0.7;
end
legend_cell = {'Original'};
hs = [];
yh = line(collections{c}.x,collections{c}.Y(:,s),'Color',[0.1,0.1,0.1]+add);
hs(end+1) = yh;
myfunc = @(hObject, eventdata, handles) (line_click_info(collections{c},s));
set(yh,'ButtonDownFcn',myfunc);
setappdata(gcf,'yh',yh);

if sum(abs(collections{c}.Y_fixed(:,s))) > 0 % Fixed answer available
    legend_cell{end+1} = getappdata(gcf,'add_processing_log');
    yh_fixed = line(collections{c}.x,collections{c}.Y_fixed(:,s),'Color','k');
    hs(end+1) = yh_fixed;
    inxs = find(collections{c}.Y_fixed(:,s) < 0);
    if ~isempty(inxs)
        legend_cell{end+1} = 'Less than 0';
        yh_fixed(end+1) = line(collections{c}.x(inxs),collections{c}.Y_fixed(inxs,s),'Color','r');
        hs(end+1) = yh_fixed(end);
    end
    setappdata(gcf,'yh_fixed',yh_fixed);
    myfunc = @(hObject, eventdata, handles) (line_click_info(collections{c},s));
    set(yh_fixed,'ButtonDownFcn',myfunc);
    if sum(abs(collections{c}.Y_baseline(:,s))) > 0 % Baseline available
        legend_cell{end+1} = 'Baseline';
        yh_baseline = line(collections{c}.x,collections{c}.Y_baseline(:,s),'Color','b');
        hs(end+1) = yh_baseline;
        setappdata(gcf,'yh_baseline',yh_baseline);
    end
    if isfield(collections{c},'handles')
        for i = 1:length(collections{c}.handles{s})
            set(collections{c}.handles{s}(i),'Visible','on');
        end
    end
end
lh = legend(hs,legend_cell);
setappdata(gcf,'lh',lh);