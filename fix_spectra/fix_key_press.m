function fix_key_press
collections = getappdata(gcf,'collections');
if isempty(collections)
    return
end

k = get(gcf,'CurrentKey');

if strcmp(k,'uparrow')
    plot_next_spectrum
elseif strcmp(k,'downarrow')
    plot_previous_spectrum
elseif strcmp(k,'rightarrow')
    next_segment
elseif strcmp(k,'leftarrow')
    previous_segment
elseif strcmp(k,'pageup')
    xlim1 = get(gca,'xlim');
    xdist = getappdata(gcf,'xdist');
    if isempty(xdist)
        xdist = 0.005;
    end
    set(gca,'xlim',[xlim1(1)-xdist,xlim1(2)+xdist]);
elseif strcmp(k,'pagedown')
    xlim1 = get(gca,'xlim');
    xdist = getappdata(gcf,'xdist');
    if isempty(xdist)
        xdist = 0.005;
    end
    set(gca,'xlim',[xlim1(1)+xdist,xlim1(2)-xdist]);
elseif strcmp(k,'home')
    ylim1 = get(gca,'ylim');
    ydist = getappdata(gcf,'ydist');
    if isempty(ydist)
        collections = getappdata(gcf,'collections');
        [x,Y,labels] = combine_collections(collections);
        max_spectrum = Y(:,1)';
        min_spectrum = Y(:,1)';
        for s = 1:length(labels)
            max_spectrum = max([max_spectrum;Y(:,s)']);
            min_spectrum = min([min_spectrum;Y(:,s)']);
        end
        ydist = max(max_spectrum)*0.005;
    end
    set(gca,'ylim',[ylim1(1)-ydist,ylim1(2)+ydist]);
elseif strcmp(k,'end')
    ylim1 = get(gca,'ylim');
    ydist = getappdata(gcf,'ydist');
    if isempty(ydist)
        collections = getappdata(gcf,'collections');
        [x,Y,labels] = combine_collections(collections);
        max_spectrum = Y(:,1)';
        min_spectrum = Y(:,1)';
        for s = 1:length(labels)
            max_spectrum = max([max_spectrum;Y(:,s)']);
            min_spectrum = min([min_spectrum;Y(:,s)']);
        end
        ydist = max(max_spectrum)*0.005;
    end
    set(gca,'ylim',[ylim1(1)+ydist,ylim1(2)-ydist]);
elseif strcmp(k,'r')
    xlim auto
    ylim auto
end
%     if isempty(getappdata(gcf,'bin_inx'))
%         setappdata(gcf,'bin_inx',0);        
%     end
%     bin_inx = getappdata(gcf,'bin_inx');
%     bin_inx = bin_inx + 1;
%     if bin_inx > num_bins
%         bin_inx = bin_inx - 1;
%     else
%         left = get(bins_cursors(bin_inx,1),'xdata');%GetCursorLocation(gcf,bins_cursors(bin_inx,1));
%         left = left(1);
%         right = get(bins_cursors(bin_inx,2),'xdata');%GetCursorLocation(gcf,bins_cursors(bin_inx,2));
%         right = right(1);
%         set(gca,'xlim',[right,left]);
%         ymax = -Inf;
%         ymin = Inf;
%         for c = 1:length(collections)
%             inxs = find(left >= collections{c}.x & collections{c}.x >= right);
%             for s = 1:collections{c}.num_samples
%                 mx = max(collections{c}.Y(inxs,s));
%                 if mx > ymax
%                     ymax = mx;
%                 end
%                 mn = min(collections{c}.Y(inxs,s));
%                 if mn < ymin
%                     ymin = mn;
%                 end
%             end
%         end
%         set(gca,'ylim',[ymin,ymax]);
%     end
%     setappdata(gcf,'bin_inx',bin_inx);
% elseif strcmp(k,'leftarrow')
%     if isempty(getappdata(gcf,'bin_inx'))
%         setappdata(gcf,'bin_inx',0);        
%     end
%     bin_inx = getappdata(gcf,'bin_inx');
%     bin_inx = bin_inx - 1;
%     if bin_inx < 1
%         bin_inx = bin_inx + 1;
%     else
%         left = get(bins_cursors(bin_inx,1),'xdata');%GetCursorLocation(gcf,bins_cursors(bin_inx,1));
%         left = left(1);
%         right = get(bins_cursors(bin_inx,2),'xdata');%GetCursorLocation(gcf,bins_cursors(bin_inx,2));
%         right = right(1);
%         set(gca,'xlim',[right,left]);
%         ymax = -Inf;
%         ymin = Inf;
%         for c = 1:length(collections)
%             inxs = find(left >= collections{c}.x & collections{c}.x >= right);
%             for s = 1:collections{c}.num_samples
%                 mx = max(collections{c}.Y(inxs,s));
%                 if mx > ymax
%                     ymax = mx;
%                 end
%                 mn = min(collections{c}.Y(inxs,s));
%                 if mn < ymin
%                     ymin = mn;
%                 end
%             end
%         end
%         set(gca,'ylim',[ymin,ymax]);
%     end
%     setappdata(gcf,'bin_inx',bin_inx);
% end