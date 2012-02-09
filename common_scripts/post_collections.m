function post_collections(main_h,collections,suffix,analysis_id)
tmpdir = tempname;
mkdir(tmpdir);
[username,password] = logindlg;
for i = 1:length(collections)
    file = save_collection(tmpdir,suffix,collections{i});    
    url = sprintf('http://birg.cs.wright.edu/omics_analysis/spectra_collections.xml');
    xml = urlread(url,'post',{'name',username,'password',password,'analysis_id',num2str(analysis_id),'collection[data]',fileread(file)});
    file = tempname;
    fid = fopen(file,'w');
    fprintf(fid,xml);
    fclose(fid);
    collection_xml = xml2struct(file);
    id = collection_xml.Children.Data;
    fprintf('Collection %d: %s\n',i,id);
end