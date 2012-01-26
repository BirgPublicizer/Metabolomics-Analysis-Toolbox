function update_bin_list(handles,bins,deconvolve,names)
data = cell(size(bins,1)+1,1);
data{1} = '';
for b = 1:size(bins,1)
    if exist('deconvolve') == 1 && deconvolve(b)
        data{b+1} = sprintf('%f,%f,D',bins(b,1),bins(b,2));
    else
        data{b+1} = sprintf('%f,%f',bins(b,1),bins(b,2));
    end    
    if exist('names') == 1 && ~isempty(names{b}) && ~strcmp(deblank(names{b}),'')
        data{b+1} = [data{b+1},',',names{b}];
    end
end
set(handles.bins_listbox,'String',data);