function fix_paired_bea_plot(varargin)
% Parameter value pairs:
%   'delete_legend', true/false
%   'show_treatment_arrows',true/false
delete_legend = false;
show_treatment_arrows = false;
for i = 1 : 2 : length(varargin)
    name = varargin{i};
    value = varargin{i+1};
    switch name
        case 'show_treatment_arrows'
            show_treatment_arrows = value;
        case 'delete_legend'
            delete_legend = value;
        otherwise
    end
end
% colors = {'k','r','b','m','g','c',[rand rand rand],[rand rand rand]};
% save('colors');
load('colors');
markers = {'o','s','d','v','^','<','>'};
[legh,objh,outh,outm]=legend;
Children = get(gca,'Children');
times = {};
doses = {};
sort_by_doses = [];
for i = 1:length(outm)
    fields = split(outm{i},',');
    ind_times = split(fields{1},'-');
    times{end+1} = ind_times{1};
    doses{end+1} = fields{2};
    ind_doses = split(fields{2},' ');
    if strcmp('0',ind_doses{2})
        sort_by_doses(end+1) = -Inf;
    else
        sort_by_doses(end+1) = str2num(ind_doses{2});
    end
end

% First sort them based on the dose
[sorted_doses,sorted_inxs] = sort(sort_by_doses);
% sorted_inxs = sorted_inxs(end:-1:1);
sorted_doses = {doses{sorted_inxs}};
current_dose = sorted_doses{1};
specific_times = [];
ginxs = [];
current_inx = 1;
subset_inxs = [];
for i = 1:length(sorted_doses)    
    if ~strcmp(current_dose,sorted_doses{i})
        [sorted_times,sorted_times_inxs] = sort(specific_times);
        sorted_inxs(ginxs) = sorted_inxs(ginxs(sorted_times_inxs));
        for j = 1:length(ginxs)
            h = outh(sorted_inxs(ginxs(j)));
            set(h,'Color',colors{current_inx});
            set(h,'Marker',markers{j});
            if current_inx ~= 1
                set(h,'MarkerFaceColor',colors{current_inx});
            end
            % Color ellipse
            ix = find(Children == h);
            ix = ix - 1;
            set(Children(ix),'EdgeColor',colors{current_inx});
        end
        
        current_dose = sorted_doses{i};
        specific_times = [];
        ginxs = [];
        current_inx = current_inx + 1;
    end
    if current_inx == 1 || isempty(ginxs)
        subset_inxs(end+1) = i;
    end
    ginxs(end+1) = i;
    specific_times(end+1) = str2num(times{sorted_inxs(i)});
end
[sorted_times,sorted_times_inxs] = sort(specific_times);
sorted_inxs(ginxs) = sorted_inxs(ginxs(sorted_times_inxs));
for j = 1:length(ginxs)
    h = outh(sorted_inxs(ginxs(j)));
    set(h,'Color',colors{current_inx});
    set(h,'Marker',markers{j});
    if current_inx ~= 1
        set(h,'MarkerFaceColor',colors{current_inx});
    end
    % Color ellipse
    ix = find(Children == h);
    ix = ix - 1;
    set(Children(ix),'EdgeColor',colors{current_inx});
end

% Adjust the order
for i = 1:length(outm)
    if strcmp(outm{i},'24-0,BE 0')
        outm{i} = 'd1 minus d0';
    elseif strcmp(outm{i},'48-0,BE 0')
        outm{i} = 'd2 minus d0';
    elseif strcmp(outm{i},'72-0,BE 0')
        outm{i} = 'd3 minus d0';
    elseif strcmp(outm{i},'96-0,BE 0')
        outm{i} = 'd4 minus d0';
    end
end
control_inxs = 1:4;
treatment_inxs = 5:8;
h_legend = legend(outh(sorted_inxs(control_inxs)),{outm{sorted_inxs(control_inxs)}},'location','best');
set(h_legend,'FontSize',6);
if exist('delete_legend') && delete_legend == true
    delete(h_legend);
end
if show_treatment_arrows
    treatment_handles = outh(sorted_inxs(treatment_inxs));
    for i = 1:length(treatment_handles)-1
        h_start = treatment_handles(i);
        h_stop = treatment_handles(i+1);
        x_start = get(h_start,'XData');
        y_start = get(h_start,'YData');
        x_stop = get(h_stop,'XData');
        y_stop = get(h_stop,'YData');
        arrow([x_start,y_start],[x_stop,y_stop],'BaseAngle',30);
    end
end

fprintf('Finished\n');

function fields = split(header_string,dlm)
fields = {};
tab = sprintf('\t');
[T,R] = strtok(header_string,dlm);
fields{end+1} = T;
while ~isempty(R)
    [T,R] = strtok(R,dlm);
    fields{end+1} = T;
end