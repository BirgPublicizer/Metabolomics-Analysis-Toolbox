function line_click_info(c,j,hObject, eventdata, handles)
collections = getappdata(gcf,'collections');
if isstruct(c)
    collection = c;
else
    collection = collections{c};
end
message = '';
selection_type = get(gcf,'SelectionType');
for i = 1:length(collection.input_names)
    name = regexprep(collection.input_names{i},' ','_');
    field_name = lower(name);
    if strcmp(selection_type,'alt') && strcmp(field_name,'processing_log')
        continue
    end
    if i > 1
        s = sprintf('\n');
        message = [message,s];
    end
    s = sprintf('%s: ',collection.input_names{i});
    message = [message,s];
    if iscell(collection.(field_name))
        if ischar(collection.(field_name){j})
            s = sprintf('%s',collection.(field_name){j});
            message = [message,s];
        elseif int8(collection.(field_name){j}) == collection.(field_name){j} % Integer
            s = sprintf('%d',collection.(field_name){j});
            message = [message,s];
        else
            s = sprintf('%f',collection.(field_name){j});
            message = [message,s];
        end
    elseif ischar(collection.(field_name))
        s = sprintf('%s',collection.(field_name));
        message = [message,s];
    elseif length(collection.(field_name)) > 1 % Array
        if ischar(collection.(field_name)(j))
            s = sprintf('%s',collection.(field_name)(j));
            message = [message,s];
        elseif int32(collection.(field_name)(j)) == collection.(field_name)(j) % Integer
            s = sprintf('%d',collection.(field_name)(j));
            message = [message,s];
        else
            s = sprintf('%f',collection.(field_name)(j));
            message = [message,s];
        end
    elseif int32(collection.(field_name)) == collection.(field_name) % Integer
        s = sprintf('%d',collection.(field_name));
        message = [message,s];
    else
        s = sprintf('%f',collection.(field_name));
        message = [message,s];
    end
end

if strcmp(selection_type,'normal')
    msgbox(message);
else
    calling_gcf = gcf;
    regions = get_regions;
    ax = get(calling_gcf,'CurrentAxes');
    xl = get(ax,'xlim');
    yl = get(ax,'ylim');
    fhs = getappdata(calling_gcf,'fhs');
    fh = figure;
    fhs(end+1) = fh;
    setappdata(calling_gcf,'fhs',fhs);
    yh = line(collection.x,collection.Y(:,j),'Color','k');
    set(gcf,'CloseRequestFcn',@closing_child_window);
    setappdata(gcf,'yh',yh);
    setappdata(gcf,'main_h',calling_gcf);
    legend(message,'Location','Best');
    set(gca,'xdir','reverse')
    set(gca,'xlim',xl);
    set(gca,'ylim',yl);
    xlabel('Chemical shift, ppm')
    ylabel('Intensity')
    nm = size(regions);
    for i = 1:nm(1)
        line([regions(i,1),regions(i,1)],yl,'Color','g');
        line([regions(i,2),regions(i,2)],yl,'Color','r');
    end
    
    if isfield(collection,'spectra')
        % Plot all of the maxs in black
        for m = 1:length(collection.spectra{j}.xmaxs)
            h = line([collection.spectra{j}.xmaxs(m),collection.spectra{j}.xmaxs(m)],yl,'Color','k');
            myfunc = @(hObject, eventdata, handles) (max_click_menu_global(calling_gcf,h,c,j));
            menu = uicontextmenu('Callback',myfunc);
            set(h,'UIContextMenu',menu);
        end
    end

    myfunc = @(hObject,v2,v3) (plot_line_click_menu(calling_gcf,c,j));
    set(gca,'ButtonDownFcn',myfunc)

%     myfunc = @(hObject, eventdata, handles) (set_reference_spectrum(calling_gcf,c,j));
%     set(gca,'ButtonDownFcn',myfunc)

    myfunc = @(hObject, eventdata, handles) (line_click_info_key_press(c,j,calling_gcf));
    set(gcf,'KeyPressFcn',myfunc);

    %% Extras
    extra_hs = [];
    setappdata(fh,'extra_hs',extra_hs);   
end