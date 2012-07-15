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
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Dan Homer ????
%
% Paul Anderson ????
%
% Eric Moyer 2011-2012 (eric_moyer@yahoo.com)

str = {'Get collection(s)','Load collections', ...
...%'','Set noise regions', ...
	'','Load regions','Create signal map','Create new region', ...
       'Edit region','Delete region','Clear regions','Fix baseline', ...
    '','Set reference','Normalize to reference','Zero regions', 'Sum normalize','Normalize to weight',...     
    '','Save regions','Finalize','Save collections', ...
       'Post collections','Save figures','Save images', ...
    '', 'Prob Quot Norm''n', 'Hist Norm''n', ...
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
elseif strcmp(str{s},'Normalize to weight')
     normalize_to_weight;
elseif strcmp(str{s},'Sum normalize')
    % Prompt for the sum
    prompt={'Sum:'};
    name='Normalize to what sum';
    numlines=1;
    defaultanswer={'1000'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    target_sum = str2double(answer{1});

    % Get the collections
    collections = getappdata(gcf,'collections');
    
    % Sum-normalize and set the application state variables
    fixed_collections = sum_normalize(collections, target_sum);
    
    setappdata(gcf, 'fixed_collections', fixed_collections);
    setappdata(gcf, 'collections', copy_y_to_y_fixed(fixed_collections, collections));
    setappdata(gcf, 'add_processing_log', 'Sum normalized'); % This is just the legend
    setappdata(gcf, 'temp_suffix','_sum_normalize');
    plot_all;
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
        if ~any(inxs)
            msgbox(sprintf(['There are no samples in the region from' ...
                ' %f to %f in collection %s. Please choose a ' ...
                'different region for the location of the standard ' ...
                'peak. Cannot set reference.'], ...
                left, right, collections{c}.collection_id), ...
                'Error: No samples', 'Error');
            % No setappdata calls were made so everything is still
            % unchanged, thus we can return to abort the process
            return; 
        end
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
    
    if ~iscell(collections)
        msgbox('Nothing to finalize','Nothing to finalize');
        return;
    end
    
    has_fixed_data = any(cellfun(@(in) (isfield(in,'Y_fixed') && any(in.Y_fixed(:) > 0)), collections));
    if ~has_fixed_data
        msgbox('Nothing to finalize','Nothing to finalize');
        return;
    end
    
    % Finalize
    if isappdata(gcf, 'fixed_collections')
        collections = getappdata(gcf, 'fixed_collections');
        rmappdata(gcf, 'fixed_collections');
    else
        for c = 1:length(collections)
            collections{c}.Y = collections{c}.Y_fixed;
            if ~isempty(add_processing_log)
                collections{c}.processing_log = [collections{c}.processing_log,' ',add_processing_log];
            end
        end
    end
    for c = 1:length(collections)
        collections{c}.Y_fixed = collections{c}.Y_fixed*0;
        collections{c}.Y_baseline = collections{c}.Y_baseline*0;
        try
            for s = 1:collections{c}.num_samples
                delete(collections{c}.handles{s});
            end
        catch unused %#ok<NASGU>
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
elseif strcmp(str{s},'Prob Quot Norm''n')
    collections = getappdata(gcf,'collections');
    if isempty(collections); return; end
    
    % Prepare the data for quotient normalization
    bin_width = inputdlg('Bin width (0 for no binning)', ...
        'Probabilistic Quotient Normalization', 1, {'0.04'});
    if isempty(bin_width); return; end
    bin_width = str2double(bin_width);
    if isnan(bin_width); return; end
    if bin_width ~= 0
        binned = bin_collections(collections, bin_width, true);
    end
    
    regions = get_regions;
    use_bin = ~bins_overlapping_regions(binned{1}.x, regions);
    
    % Interactively generate the normalization multipliers
    retvals = prob_quotient_norm_dialog({binned, use_bin});

    % Parse return values (including aborting if cancel was clicked in the
    % dialog box)
    was_canceled = retvals{2};
    if was_canceled; return; end
    
    multipliers = retvals{3};
    proc_log = retvals{4};
    
    % perform the normalization
    multiplied = multiply_collections(collections, multipliers);
    multiplied = append_to_processing_log(multiplied, proc_log);
    
    % Set the y_fixed for proper display and enabling of finalization
    collections = copy_y_to_y_fixed(multiplied, collections);
    
    % set the result as the current app data
    setappdata(gcf, 'collections', collections);
    setappdata(gcf, 'fixed_collections', multiplied);
    setappdata(gcf, 'add_processing_log', 'Prob. quot. normalized'); % This is just the legend
    setappdata(gcf,'temp_suffix', '_pq_normalized');
    plot_all;
elseif strcmp(str{s}, 'Hist Norm''n')
    collections = getappdata(gcf,'collections');
    
    % Validate collections
    if isempty(collections); return; end
    
    if ~only_one_x_in(collections)
        msgbox(['The spectral collections use different sampling ' ...
            'locations. Cannot normalize. Consider binning first.'], ...
            'Error: different sample locations', 'Error');
        return;
    end
        
    % Get the parameters
    answer = inputdlg({...
            'Points to use for baseline noise estimate', ...
            'Number of bins for the histogram', ...
            'Standard deviations from baseline mean to call noise.', ...
        }, ...
        'Enter Histogram Normalization Parameters', 1, ...
        {'35','60','5'});
    
	if isempty(answer)
        return;
	end
        
    baseline_pts = str2double(answer{1});
    num_bins = str2double(answer{2});
    std_dev = str2double(answer{3});
    
    % Do the Normalization
    normed = histogram_normalize(collections, baseline_pts, std_dev, num_bins, true);
    
    % Set the y_fixed for proper display and enabling of finalization
    collections = copy_y_to_y_fixed(normed, collections);

    % set the result as the current app data
    setappdata(gcf, 'collections', collections);
    setappdata(gcf, 'fixed_collections', normed);
    setappdata(gcf, 'add_processing_log', 'Histogram normalized'); % This is just the legend
    setappdata(gcf,'temp_suffix', '_histogram_normalized');
    plot_all;
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