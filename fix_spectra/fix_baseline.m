function fix_baseline
prompt={'Enter the lambda (higher value for smoother baseline):'};
name='Fix baseline';
numlines=1;
defaultanswer={'20'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
if(isempty(answer))
    return
end
lambda = str2num(answer{1});

regions = get_regions;
collections = getappdata(gcf,'collections');
% c = getappdata(gcf,'collection_inx');
% s = getappdata(gcf,'spectrum_inx');
for c = 1:length(collections)
    for s = 1:collections{c}.num_samples
        y = collections{c}.Y(:,s);
        x = collections{c}.x;
        xwidth = abs(x(1)-x(2));
        xmax = max(x);

        % Weights (0 = ignore this intensity)
        w = zeros(size(y));
        nm = size(regions);
        if nm(1) == 0
            error_no_regions_selected
        end
        for i = 1:nm(1)
            inx1 = max([1,round((xmax - regions(i,1))/xwidth) + 1,1]);
            inx2 = min([round((xmax - regions(i,2))/xwidth) + 1,length(w)]);
            w(inx1:inx2) = 1;
        end
        % Matrix version of W
        W = sparse(length(y),length(y));
        for i = 1:length(w)
            W(i,i) = w(i);
        end
        % Difference matrix (they call it derivative matrix, which a little
        % misleading)
        D = sparse(length(y),length(y));
        for i = 1:length(y)-1
            D(i,i) = 1;
            D(i,i+1) = -1;
        end

        A = W + lambda*D'*D;
        b = W*y;

        z = A\b; % Compute the baseline
%         inxs = find(w == 1);
%         z_spline = interp1(x(inxs),z(inxs),x,'spline')';

        collections{c}.Y_baseline(:,s) = z;
        collections{c}.Y_fixed(:,s) = y - z;
        inxs = find(collections{c}.Y(:,s) == 0);
        collections{c}.Y_fixed(inxs,s) = 0;
    end
end
%setappdata(gcf,'add_processing_log','Fixed baseline.');
setappdata(gcf,'add_processing_log',sprintf('Fix baseline (lambda: %f).',lambda));
setappdata(gcf,'temp_suffix','_fixed_baseline');
setappdata(gcf,'collections',collections);

plot_all