function [opls_scores,add_new_data] = get_opls_model(id)
url = sprintf('http://birg.cs.wright.edu/services/opls_models/%d.xml',id);
xml = urlread(url,'get',{});
file = tempname;
fid = fopen(file,'w');
fwrite(fid,xml);
fclose(fid);
collection_xml = xml2struct(file);
inx = 0;
for i = 1:length(collection_xml.Children)
    if strcmp(collection_xml.Children(i).Name,'opls-scores')
        inx = i;
        break;
    end
end
opls_scores = collection_xml.Children(inx).Children.Data;
inx = 0;
for i = 1:length(collection_xml.Children)
    if strcmp(collection_xml.Children(i).Name,'add-new-data')
        inx = i;
        break;
    end
end
add_new_data = collection_xml.Children(inx).Children.Data;