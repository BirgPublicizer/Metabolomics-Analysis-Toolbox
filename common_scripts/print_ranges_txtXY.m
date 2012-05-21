% Convert one of Oleg's files to individual sample files
indir = uigetdir;
if indir == 0
    msgbox(['Invalid directory ',indir]);
    return
end
[filenames,pathnames] = list(indir,[indir,'\*.txtXY']);
answer = inputdlg('Enter the frequency in Hz');
frequency = str2num(answer{1});
x = [];
for i = 1:length(filenames)
    pathname = pathnames{i};
    filename = filenames{i};
    ifid = fopen([pathname,filename]);
    if strcmp(ifid,'"stdin"') == 1 || ifid < 0
        msgbox(['Cannot open file ',pathname,filename]);
        return
    end
    line = fgetl(ifid);
    while line ~= -1
        if line(1) ~= '$'
            lines = textscan(ifid,'%f%f');
            x = lines{1};
            break;
%             fields = split(line,' ');
%             if length(fields) == 2
%                 x(end+1) = str2num(fields{1});
%             end
        end
        line = fgetl(ifid);
    end
    mx = max(x);
    step = x(1)-x(2);
    mn = min(x);
    fprintf('%f:%f:%f\n',mx/frequency*10^6,step/frequency*10^6,mn/frequency*10^6);

    fclose(ifid);
end
