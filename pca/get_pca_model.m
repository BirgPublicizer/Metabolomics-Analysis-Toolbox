function [pca_scores] = get_pca_model(id)
url = sprintf('http://birg.cs.wright.edu/services/pca_models/%d.xml',id);
xml = urlread(url,'get',{});
file = tempname;
fid = fopen(file,'w');
fwrite(fid,xml);
fclose(fid);
collection_xml = xml2struct(file);
inx = 0;
for i = 1:length(collection_xml.Children)
    if strcmp(collection_xml.Children(i).Name,'pca-scores')
        inx = i;
        break;
    end
end
pca_scores = collection_xml.Children(inx).Children.Data;