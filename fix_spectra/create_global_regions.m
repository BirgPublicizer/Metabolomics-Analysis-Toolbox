function create_global_regions
collections = getappdata(gcf,'collections');
num_collections = numel(collections);
[x,Y] = combine_collections(collections);
x = x';
[num_variables,total_samples] = size(Y);
global_signal_map = zeros(num_variables,1);

% Should ultimately prompt user for packet size (DONE 12/09/2010 DCHomer) 
    prompt={'Enter Packet Size:'};
    name='Packet Size';
    numlines=1;
    defaultanswer={'15'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    packet_size = str2num(answer{1});
    %packet_size = 15;
    %Initialize counter for spectrum index in combined_collections
spectrum_idx = 1;    
for i = 1:num_collections
    for j = 1:collections{i}.num_samples
        fprintf('Starting SM creation on %s\n',char(collections{i}.sample_id(j)))
        signal_map = generate_signal_map(x,Y(:,spectrum_idx),packet_size,collections,i,j);
        global_signal_map = global_signal_map + signal_map;
        total_baseline_homog = length(find(global_signal_map == spectrum_idx))/length(find(global_signal_map ~= 0));
        fprintf('Total group baseline homogeneity is %s\n', num2str(total_baseline_homog*100))
        spectrum_idx = spectrum_idx+1;
    end
end

% Need to bring fix_spectra window to front then open "are you happy"
% window
figure(gcf)
are_you_happy = 'n';

while are_you_happy ~= 'y'
    prompt = ('Enter baseline Homogeneity');
    name = 'percent homogeneity';
    numlines = 1;
    defaultanswer={'100'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    perc_homog = str2num(answer{1})/100;
    inclusion_threshold = total_samples*perc_homog;
    SMtemp = zeros(length(x),1);
    for j = 1:length(x)
        if global_signal_map(j) >= inclusion_threshold
            SMtemp(j) = 1;
        else
            SMtemp(j) = 0;
        end
    end
    
    regions = [];
    start = 1;
    
    while start <= length(x)
        stop = start;
        while stop <= length(x) && SMtemp(stop) == 1
            stop = stop + 1;
        end
        if stop ~= start
            regions(end+1,:) = [x(start),x(min([stop,length(x)]))];
        end
        start = stop + 1;
    end

    clear_plot
    [rows,cols] = size(regions);
    regions_cursors = zeros(rows,2);
    s = 1;
    for i = 1:rows
        regions_cursors(i,1) = line([regions(i,1),regions(i,1)],[min(Y(:,s)),max(Y(:,s))],'Color','g');
        regions_cursors(i,2) = line([regions(i,2),regions(i,2)],[min(Y(:,s)),max(Y(:,s))],'Color','r');
        setappdata(gcf,'regions_cursors',regions_cursors);
        [region_inx,left,right,left_handle,right_handle,extra_left_handle,extra_right_handle] = get_region(i);
        myfunc = @(hObject, eventdata, handles) (region_click_menu(left_handle));
        menu = uicontextmenu('Callback',myfunc);
        set(left_handle,'UIContextMenu',menu);
        set(extra_left_handle,'UIContextMenu',menu);
        myfunc = @(hObject, eventdata, handles) (region_click_menu(right_handle));
        menu = uicontextmenu('Callback',myfunc);
        set(right_handle,'UIContextMenu',menu);
        set(extra_right_handle,'UIContextMenu',menu);
    end

    setappdata(gcf,'regions_cursors',regions_cursors);

    plot_all

    prompt = ('Are you Happy With Baseline Regions? (y or n)');
    name = 'FinalMapHappy';
    numlines = 1;
    defaultanswer={'y'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    are_you_happy = answer{1};
end
%global_signal_map = SMtemp;
setappdata(gcf,'add_processing_log',[getappdata(gcf,'add_processing_log'),sprintf('Signal map generated (homogeneity %f).',perc_homog)]);
