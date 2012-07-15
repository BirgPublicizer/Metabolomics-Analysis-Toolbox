function normalize_to_reference
% Normalizes by dividing by the area under peaks selected by the user
%
% This is useful if there is an internal standard etc.
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Paul Anderson (before Summer 2011) pauleanderson@gmail.com
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%

prompt={'Left:','Right:','Reference Peaks:','Non-reference Peaks:'};
name='Normalize to reference';
numlines=1;
defaultanswer={'0.2','-0.2','0.1,0.0,-0.1',''};
answer=inputdlg(prompt,name,numlines,defaultanswer);
if isempty(answer)
    return; %Was cancelled
end
left = str2num(answer{1});
right = str2num(answer{2});
reference_peaks = str2num(answer{3}); %#ok<ST2NM>
non_reference_peaks = str2num(answer{4}); %#ok<ST2NM>

X_temp = [reference_peaks,non_reference_peaks];
[all_X,X_inxs] = sort(X_temp,'descend');
reference_X_inxs = X_inxs(1:length(reference_peaks));
non_reference_X_inxs = X_inxs(end-length(non_reference_peaks):end);

collections = ensure_original_multiplied_by_field( getappdata(gcf,'collections') );
old_collections = collections;
for c = 1:length(collections)
    fit_inxs = find(left >= collections{c}.x & collections{c}.x >= right);
    
    proc_l = collections{c}.processing_log;
    proc_l = sprintf('%s Normalized to reference [%f,%f].', proc_l,left,right);
    collections{c}.processing_log = proc_l;
    
    for s = 1:collections{c}.num_samples
        [y_fit,MGPX,baseline_BETA,x_baseline_BETA,converged] = curve_fit(collections{c}.x,collections{c}.Y(:,s),fit_inxs,all_X,all_X,left,right);
        if ~converged
            error('normalize_to_reference','Curve fit did not converge');
        end
        X = MGPX(4:4:end);
        y_residual = collections{c}.Y(:,s) - y_fit;
        
        handles = line(collections{c}.x(fit_inxs),y_residual(fit_inxs),'Color','r');
        set(handles(end),'Visible','off');

        % Individual peaks
        peaks = {};
        for k = 1:length(X)
            MGPX_o = MGPX(4*(k-1)+(1:4));
            model = @(PARAMS,x_) (global_model(PARAMS,x_,1,x_baseline_BETA)); 
            peaks{k} = model([MGPX_o,0*x_baseline_BETA],collections{c}.x(fit_inxs)');
            handles(end+1) = line(collections{c}.x(fit_inxs),peaks{k},'Color',[0.5,0.5,0.5]);
            set(handles(end),'Visible','off');            
        end       

        % Just the baseline
        model = @(PARAMS,x_) (global_model(PARAMS,x_,0,x_baseline_BETA));
        y_baseline = model(baseline_BETA,collections{c}.x(fit_inxs)');
        handles(end+1) = line(collections{c}.x(fit_inxs),y_baseline,'Color','b');
        set(handles(end),'Visible','off');
       
        sum_all_reference_peaks = 0;
        for i = 1:length(reference_X_inxs)
            sum_all_reference_peaks = sum_all_reference_peaks + sum(peaks{reference_X_inxs(i)});
        end
        collections{c}.Y(:,s) = collections{c}.Y(:,s)/sum_all_reference_peaks;
        collections{c}.original_multiplied_by(s) = ...
            collections{c}.original_multiplied_by(s) * (1/sum_all_reference_peaks);
        try
            delete(collections{c}.handles{s}); % Get rid of old handles
        catch
        end
        collections{c}.handles{s} = handles;
    end
end
old_collections = copy_y_to_y_fixed(collections, old_collections);
setappdata(gcf,'collections', old_collections);
setappdata(gcf,'fixed_collections', collections);
setappdata(gcf,'add_processing_log',sprintf('Normalized to reference [%f,%f].',left,right));
setappdata(gcf,'temp_suffix','_normalize_to_reference');
plot_all
