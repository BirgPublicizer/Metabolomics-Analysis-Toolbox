function [bins,deconvolve,names] = get_bins(handles)
bins = [];
deconvolve = [];
names = {};
data = get(handles.bins_listbox,'String');
for b = 2:size(data,1) % Skip the first blank
    fields = split(data{b},',');    
    bins(end+1,:) = [str2num(fields{1}),str2num(fields{2})];
    if length(fields) == 2
        deconvolve(end+1) = false;
        names{end+1} = '';
    elseif length(fields) == 3
        if strcmp(fields{3},'D')
            deconvolve(end+1) = true;
            names{end+1} = '';
        else
            deconvolve(end+1) = false;
            names{end+1} = fields{3};
        end
    elseif length(fields) == 4
        if strcmp(fields{3},'D')
            deconvolve(end+1) = true;
        else
            deconvolve(end+1) = false;
        end
        names{end+1} = fields{4};
    end
end
