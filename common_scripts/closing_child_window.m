function closing_child_window(src,evnt)
fh = gcf;
try
    main_h = getappdata(fh,'main_h');
    fhs = getappdata(main_h,'fhs');
    new_fhs = [];
    for i = 1:length(fhs)
        if fhs(i) ~= fh
            new_fhs(end+1) = fhs(i);
        end
    end
    setappdata(main_h,'fhs',new_fhs);
catch ME
end
delete(fh);