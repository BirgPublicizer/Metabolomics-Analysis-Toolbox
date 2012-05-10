function save_regions
[regions,left_handles,right_handles] = get_regions;
lefts = regions(:,1);
rights = regions(:,2);
[filename,pathname] = uiputfile('*.txt', 'Save regions');
file = fopen([pathname,filename],'w');
if file > 0
    for b = 1:length(lefts)
        if b > 1
            fprintf(file,';');
        end
        fprintf(file,'%f,%f',lefts(b),rights(b));
    end
    fclose(file);
end
