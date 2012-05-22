% Convert one of Oleg's files to individual sample files
[filename, pathname] = uigetfile( ...
       {'*.txt', 'Tab delimited files (*.txt))'; ...
        '*.*', 'All Files (*.*)'}, ...
        'Pick a file');
fid = fopen([pathname,filename]);
if strcmp(fid,'"stdin"') == 1 || fid < 0
    msgbox(['Cannot open file ',pathname,filename]);
    return
end
header_string = fgetl(fid); % reads header data into a string
tab = sprintf('\t');
header_fields = split(header_string,tab);
% Output file directory
dir = uigetdir;
if dir == 0
    msgbox(['Invalid directory ',dir]);
    return
end
fids = [];
for i = 1:length(header_fields)-1
    fids(i) = fopen([dir,'\sample_',num2str(i),'.txtXY'],'w');
    original = header_fields{i+1};
%     fprintf(fids(i),'$%s: %s\n',header_fields{1},original);
    split_inx = length(original);
    while ~isempty(str2num(original(split_inx)))
        split_inx = split_inx - 1;
    end
    sample_id = original(split_inx+1:end);
    classification = original(1:split_inx);
    fprintf(fids(i),'$sample_id: %s\n',sample_id);
    fprintf(fids(i),'$classification: %s\n',classification);
end
% Now read the rest of the lines
line = fgetl(fid);
while line ~= -1
    fields = split(line,tab);
    for i = 1:length(fids)
        fprintf(fids(i),'%s\t%s\n',fields{1},fields{i+1});
    end
    line = fgetl(fid);
end
fclose(fid);
for i = 1:length(fids)
    fclose(fids(i));
end