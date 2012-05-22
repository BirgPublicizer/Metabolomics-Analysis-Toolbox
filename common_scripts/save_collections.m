function save_collections(collections,suffix)
indir = uigetdir;
if indir == 0
    msgbox(['Invalid directory ',indir]);
    return
end

for i = 1:length(collections)
    save_collection(indir,suffix,collections{i});
end