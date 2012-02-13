function closing_main_window(src,evnt)
fh = gcf;
fhs = getappdata(fh,'fhs');
for i = 1:length(fhs)
    try
        delete(fhs(i));
    catch ME
    end
end
h_options = getappdata(fh,'h_options');
try
    delete(h_options);
catch
end

delete(fh);