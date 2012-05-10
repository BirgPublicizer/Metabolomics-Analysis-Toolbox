function fix_click_menu(hObject, eventdata, handles) %#ok<INUSD>
% Display main menu for fix_spectra and dispatch resulting calls
%
% This is a call-back for the left-click action on the main figure for
% fix_spectra.  It displays the menu of potential actions, does the set-up,
% and calls the requisite other functions to execute the actions.
%
% The menu options and their actions are linked by the menu option text, so
% a maintenance programmer should be sure to change the appropriate strcmp
% calls when he changes the menu text.
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% All inputs are ignored
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% None
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% Because this is a callback no examples are needed.

str = {'Get collection(s)','Load collections', ...
...%'','Set noise regions', ...
	'','Load regions','Create signal map','Create new region', ...
       'Edit region','Delete region','Clear regions','Fix baseline', ...
    '','Set reference','Normalize to reference','Zero regions', 'Sum normalize','Normalize to weight',...
    '','Save regions','Finalize','Save collections', ...
       'Post collections','Save figures','Save images', ...
    '', 'Calc Area', 'Calc Norm Constant',...
	'','Set zoom x distance','Set zoom y distance'};

[s,unused] = listdlg('PromptString','Select an action',...
              'SelectionMode','single',...
              'ListString',str); %#ok<NASGU>

if isempty(s)
    return
end

if strcmp(str{s},'Load collections')
    loaded_collections = getappdata(gcf,'collections'); 
    
    collections = load_collections;
    if isempty(collections)
        return
    end
    if ~isempty(loaded_collections)
        collections = [loaded_collections, collections];
    end
    setappdata(gcf,'spectrum_inx',0);
    setappdata(gcf,'collection_inx',1);
    %save_collections(collections);
    for c = 1:length(collections)
        collections{c}.Y_fixed = zeros(size(collections{c}.Y));
        collections{c}.Y_baseline = zeros(size(collections{c}.Y));
    end
    setappdata(gcf,'collections',collections);
    plot_next_spectrum;
    setappdata(gcf,'orig_ylim',get(gca,'ylim'));
elseif strcmp(str{s},'Create signal map')
    create_global_regions
elseif strcmp(str{s},'Get collection(s)')
    loaded_collections = getappdata(gcf,'collections'); 
    
    % Set pointer to wait cursor
    old_pointer=get(gcf, 'Pointer');
    set(gcf, 'Pointer', 'watch');

    collections = get_collections;
    
    % Set the pointer back to what it was
    set(gcf, 'Pointer', old_pointer);
 
    % Check for error
    if isempty(collections)
        return
    end
 
    % Add the newly loaded collections onto the end of the current list
    if ~isempty(loaded_collections)
        collections = [loaded_collections,collections];
    end
    
    setappdata(gcf,'spectrum_inx',0);
    setappdata(gcf,'collection_inx',1);
    for c = 1:length(collections)
        collections{c}.Y_fixed = zeros(size(collections{c}.Y));
        collections{c}.Y_baseline = zeros(size(collections{c}.Y));
    end
    setappdata(gcf,'collections',collections);
    plot_next_spectrum;
    setappdata(gcf,'orig_ylim',get(gca,'ylim'));    
elseif strcmp(str{s},'Set baseline')
    set_baseline_regions
elseif strcmp(str{s},'Set noise regions')
    set_noise_regions;
elseif strcmp(str{s},'Fix baseline')
    fix_baseline
elseif strcmp(str{s},'Edit region')
    set_edit
elseif strcmp(str{s},'Create new region')
    create_new
elseif strcmp(str{s},'Clear regions')
    clear_regions_cursors
    plot_all
elseif strcmp(str{s},'Delete region')
    delete_region
elseif strcmp(str{s},'Save regions')
    save_regions
elseif strcmp(str{s},'Load regions')
    load_regions
elseif strcmp(str{s},'Normalize to reference')
    normalize_to_reference;
elseif strcmp(str{s},'Zero regions')
    zero_regions;
elseif strcmp(str{s},'Set reference')
    prompt={'Left:','Right:','New position'};
    name='Set reference';
    numlines=1  ;
    defaultanswer={'0.03','-0.03','0.0'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    left = str2double(answer{1});
    right = str2double(answer{2});
    new_position = str2double(answer{3});
    collections = getappdata(gcf,'collections');
    for c = 1:length(collections)
        collections{c}.Y_fixed = collections{c}.Y;
        nm = size(collections{c}.Y);
        inxs = find(left >= collections{c}.x & collections{c}.x >= right);
        [unused,temp_inxs] = sort(abs(collections{c}.x - new_position),'ascend'); %#ok<ASGLU>
        zero_inx = temp_inxs(1);
        for s = 1:collections{c}.num_samples
            [unused,tinx] = max(collections{c}.Y(inxs,s)); %#ok<ASGLU>
            inx = inxs(tinx);
            new_inxs = (1:nm(1)) + (zero_inx - inx);
            disp(zero_inx-inx)
            in_range = new_inxs > 0 & new_inxs <= nm(1);
            new_inxs = new_inxs(in_range);
            collections{c}.Y_fixed(new_inxs,s) = collections{c}.Y(new_inxs-(zero_inx - inx),s);
        end
    end
    setappdata(gcf,'collections',collections);
    setappdata(gcf,'add_processing_log',sprintf('Set reference [%f,%f].',left,right));
    setappdata(gcf,'temp_suffix','_set_reference');
    plot_all
elseif strcmp(str{s},'Finalize')
    collections = getappdata(gcf,'collections');
    add_processing_log = getappdata(gcf,'add_processing_log');
    % Finalize
    for c = 1:length(collections)
        collections{c}.Y = collections{c}.Y_fixed;
        collections{c}.Y_fixed = collections{c}.Y_fixed*0;
        collections{c}.Y_baseline = collections{c}.Y_baseline*0;
        try
            for s = 1:collections{c}.num_samples
                delete(collections{c}.handles{s});
            end
        catch unused %#ok<NASGU>
        end
        if ~isempty(add_processing_log)
            collections{c}.processing_log = [collections{c}.processing_log,' ',add_processing_log];
        end
    end
    setappdata(gcf,'collections',collections);
    setappdata(gcf,'add_processing_log',[]);
    suffix = getappdata(gcf,'suffix');
    if isempty(suffix)
        suffix = '';
    end
    temp_suffix = getappdata(gcf,'temp_suffix');
    if ~isempty(temp_suffix)
        setappdata(gcf,'suffix',sprintf('%s%s',suffix,temp_suffix));
        setappdata(gcf,'temp_suffix',[]);
    end
    plot_all
elseif strcmp(str{s},'Save collections')
    collections = getappdata(gcf,'collections');
    suffix = getappdata(gcf,'suffix');
    save_collections(collections,suffix);
elseif strcmp(str{s},'Post collections')
    collections = getappdata(gcf,'collections');
    suffix = getappdata(gcf,'suffix');
    prompt={'Analysis ID:'};
    name='Enter analysis ID from the website';
    numlines=1;
    defaultanswer={''};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    analysis_id = str2double(answer{1});
    post_collections(gcf,collections,suffix,analysis_id);
elseif strcmp(str{s},'Set zoom x distance')
    prompt={'x distance:'};
    name='Set zoom x distance';
    numlines=1  ;
    defaultanswer={'0.005'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    setappdata(gcf,'xdist',str2double(answer{1}));
elseif strcmp(str{s},'Set zoom y distance')
    prompt={'y distance:'};
    name='Set zoom y distance';
    numlines=1;
    collections = getappdata(gcf,'collections');
    [unused,Y,labels] = combine_collections(collections); %#ok<ASGLU>
    max_spectrum = Y(:,1)';jjj
    min_spectrum = Y(:,1)';
    for s = 1:length(labels)
        max_spectrum = max([max_spectrum;Y(:,s)']);
        min_spectrum = min([min_spectrum;Y(:,s)']);
    end
    ydist = max(max_spectrum)*0.005;    
    defaultanswer={num2str(ydist)};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    setappdata(gcf,'ydist',str2double(answer{1}));
elseif strcmp(str{s},'Save figures')
    indir = uigetdir;
    if indir == 0
        msgbox(['Invalid directory ',indir]);
        return
    end
    saveas(gcf,[indir,'/','fix_spectra_saved_',datestr(now,'mm.dd.yyyy HH.MM.SS.fig')]);
elseif strcmp(str{s},'Save images')
    indir = uigetdir;
    if indir == 0
        msgbox(['Invalid directory ',indir]);
        return
    end
    collections = getappdata(gcf,'collections');
    for c = 1:length(collections)
        setappdata(gcf,'collection_inx',c);
        for s = 1:length(collections{c}.base_sample_id)            
            setappdata(gcf,'spectrum_inx',s);
            plot_all;
            saveas(gcf,[indir,'/',sprintf('fix_spectrum_%d_saved_',collections{c}.base_sample_id(s)),datestr(now,'mm.dd.yyyy HH.MM.SS.jpg')]);
        end
    end
elseif strcmp(str{s},'Normalize to weight')
    normalize_to_weight;
elseif strcmp(str{s},'Sum normalize')
    sum_normalize;
elseif strcmp(str{s},'Calc Area')
    area = calc_area;
    msgbox(['The area under the spectrum is: ',sprintf('%g',area)]);
elseif strcmp(str{s},'Calc Norm Constant')
    area = calc_area;
    if(area ~= 0)
        msgbox(['To sum-normalize to an area of 1000, multiply every point by: ', ...
            sprintf('%g',1000/area)]);
    else
        msgbox('This spectrum cannot be normalized because it has 0 area.');
    end
end