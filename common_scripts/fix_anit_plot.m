function fix_anit_plot(varargin)
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
load('colors');
markers = {'o','s','d','v','^','<','>'};
[legh,objh,outh,outm]=legend;
Children = get(gca,'Children');
times = {};
doses = {};
for i = 1:length(outm)
    fields = split(outm{i},',');
    times{end+1} = fields{1};
    doses{end+1} = fields{2};
end

% First sort them based on the dose
[sorted_doses,sorted_inxs] = sort(doses);
sorted_doses = {sorted_doses{end:-1:1}};
sorted_inxs = sorted_inxs(end:-1:1);
current_dose = sorted_doses{1};
specific_times = [];
ginxs = [];
current_inx = 1;
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
    outm{i} = regexprep(outm{i}, ' \(\d\)', '');
    outm{i} = regexprep(outm{i}, ',\d+ mg\/kg',',Treatment');
    if strcmp(outm{i},'0,Control')
        outm{i} = 'd0';
    elseif strcmp(outm{i},'1,Control')
        outm{i} = 'd1';
    elseif strcmp(outm{i},'2,Control')
        outm{i} = 'd2';
    elseif strcmp(outm{i},'3,Control')
        outm{i} = 'd3';
    elseif strcmp(outm{i},'4,Control')
        outm{i} = 'd4';
    end
end
control_inxs = 1:5;
treatment_inxs = 6:10;
h_legend = legend(outh(sorted_inxs(control_inxs)),{outm{sorted_inxs(control_inxs)}},'Location','NorthWest');
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