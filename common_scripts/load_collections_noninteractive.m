function collections = load_collections_noninteractive(filenames, pathnames)
%Pass a cell array of filenames and a cell array of pathnames and to get an
%array of collections.  Unlike load_collection, which handles only text
%files, this handles zip files as well.

txt_filenames = {};
txt_pathnames = {};
for k = 1:length(filenames)
    if strcmp(filenames{k}(end-2:end),'zip');
        mydir = tempname;
        mkdir(mydir);
        unzip([pathnames{k},filenames{k}],mydir);
        [tfilenames,tpathnames] = list(mydir,[mydir,'\*.txt']);
        txt_filenames = {txt_filenames{:},tfilenames{:}};
        txt_pathnames = {txt_pathnames{:},tpathnames{:}};
    else
        txt_filenames{end+1} = filenames{k};
        txt_pathnames{end+1} = pathnames{k};
    end
end

collections{length(txt_filenames)} = [];
for i = 1:length(txt_filenames)
    collections{i} = load_collection(txt_filenames{i},txt_pathnames{i});
end
