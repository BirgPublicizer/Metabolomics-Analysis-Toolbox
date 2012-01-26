function plot_maxs(handles,disable_subplot_feature)
rows = str2num(get(handles.scores_rows_edit,'String'));
columns = str2num(get(handles.scores_columns_edit,'String'));
if disable_subplot_feature
    rows = 1;
    columns = 1;
end

[bins,deconvolve] = get_bins(handles);
has_deconvolve = ~isempty(find(deconvolve == 1));
if has_deconvolve % Make sure we have found the peaks
    handles = get_peaks(handles);
else
    return;
end
[num_dp,num_spectra] = size(handles.collection.Y);

% handles.collection = adjust_y_deconvolution(handles.collection,bins,deconvolve);
% guidata(handles.figure1, handles);

delete(findobj(gcf,'Tag','hmaxs'));
d = 0;
data = get(handles.scores_uitable,'data');
group_inxs = {};
for g = 1:length(handles.group_by_inxs)
    inxs = find(handles.available_Y == g);
    if isempty(inxs)
        continue;
    end
    d = d + 1;
    group_inxs{end+1} = handles.group_by_inxs{g};
    if ~data{d,7} % Don't include
        continue;
    end
    
    subplot_inxs = split(data{d,2},',');
    for z = 1:length(subplot_inxs)
        if disable_subplot_feature
            subplot_inx = 1;
        else
            subplot_inx = str2num(subplot_inxs{z});
            subplot(rows,columns,subplot_inx);
        end
        hold on

        % Check to see if a bin is selected
        b = get(handles.bins_listbox,'Value')-1;

        % Check to see if a bin is selected
        if b == 0 || deconvolve(b) == 0 % No bin selected
            continue;
        end
        
        for j = 1:length(inxs)
            s = inxs(j);
            if isfield(handles.collection,'regions') && ~isempty(handles.collection.regions{s}) && isfield(handles.collection.regions{s}{b},'y_fit')
                regions = handles.collection.regions;
                if ~data{d,10}
                    plot(regions{s}{b}.x,regions{s}{b}.y_fit,'g-','Tag','hmaxs');
                end
                if ~data{d,11}
                    %plot(handles.collection.x,y_peaks','color',[0.2,0.8,0.8],'Tag','hmaxs');
                    for p = 1:length(regions{s}{b}.y_individual_peaks)
                        plot(regions{s}{b}.x,regions{s}{b}.y_individual_peaks{p},'color',[0.2,0.2,0.8],'Tag','hmaxs');
                    end
                    plot(regions{s}{b}.x,regions{s}{b}.y_baseline,'color',[0.2,0.2,0.8],'Tag','hmaxs');
                end
                if ~data{d,12}
                    y_residual = regions{s}{b}.y - regions{s}{b}.y_fit;
                    plot(regions{s}{b}.x,y_residual,'color',[0.8,0.2,0.2],'Tag','hmaxs');
                end
                if ~data{d,13}
                    if b > 0
                        yinxs = handles.collection.regions{s}{b}.inxs;
                        plot(regions{s}{b}.x,regions{s}{b}.y_adjusted,'color',[0.7,0.3,0.9],'tag','hmaxs');
                    end
                end
            end
        end
        
        for j = 1:length(inxs)
            s = inxs(j);
            maxs = handles.collection.maxs{s};
            x_maxs = handles.collection.x(maxs);
            binxs = find(bins(b,1) >= x_maxs & x_maxs >= bins(b,2));
            x_maxs = x_maxs(binxs);

            for i = 1:length(x_maxs)                    
                color = 'b';                    
                if ~handles.collection.regions{s}{b}.include_mask(binxs(i))
                    color = [0.8,0.8,0.8];
                end
                hmax = plot(x_maxs(i),handles.collection.Y(maxs(binxs(i)),s),'Color',color,'Tag','hmaxs','Visible','on','marker','o','MarkerFaceColor',color);
                set(hmax,'linestyle','none');
                setappdata(hmax,'s',s);
                setappdata(hmax,'max_inx',binxs(i));
                set(hmax,'ButtonDownFcn',@max_click_spectrum);                                        
            end
        end
        
        hold off
    end
end
