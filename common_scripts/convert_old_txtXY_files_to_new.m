% Convert one of Oleg's files to individual sample files
indir = uigetdir;
if indir == 0
    msgbox(['Invalid directory ',indir]);
    return
end
[filenames,pathnames] = list(indir,[indir,'\*.txtXY']);
answer = inputdlg('Enter the frequency in Hz');
frequency = str2num(answer{1});
if frequency < 1e6
    msgbox('Please enter the frequency in Hz');
    return
end
for i = 1:length(filenames)
    pathname = pathnames{i};
    filename = filenames{i};
    ifid = fopen([pathname,filename]);
    if strcmp(ifid,'"stdin"') == 1 || ifid < 0
        msgbox(['Cannot open file ',pathname,filename]);
        return
    end
    fid = fopen([pathname,'new_',filename],'w');
    fprintf(fid,'$frequency: %f\n',frequency);
    fprintf(fid,'$units_chemical_shift: Hz\n');
    line = fgetl(ifid);
    while line ~= -1
        if line(1) ~= '$'
            fields = split(line,' ');
            if length(fields) == 2
                fprintf(fid,'%s\t%s\n',fields{1},fields{2});
            end
        else
            fprintf(fid,'%s\n',line);
        end
        line = fgetl(ifid);
    end

    fclose(ifid);
    fclose(fid);
end
