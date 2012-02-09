function save_figure(collections,h,suffix)
indir = uigetdir;
if indir == 0
    msgbox(['Invalid directory ',indir]);
    return
end

collection_ids = '';
for i = 1:length(collections)
    collection_ids = [collection_ids,'_',num2str(collections{i}.collection_id)];
end
file = [indir,'\figure',collection_ids,suffix,'.fig'];

% Make sure the original handles are all saved, so they can be reset
handles = findobj;
for i = 1:length(handles)
    setappdata(handles(i),'saved_handle',handles(i));
end
            
saveas(h,file,'fig');