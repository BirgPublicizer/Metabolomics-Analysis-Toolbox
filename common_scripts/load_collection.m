function collection = load_collection(filename,pathname)
% Returns the collection stored in the given file.  The file must be a text file and [pathname,
% filename] must be the needed path to the file.

%% Read the data once skipping the header information on the first pass
ifid = fopen([pathname,filename]);
if strcmp(ifid,'"stdin"') == 1 || ifid < 0
    msgbox(['Cannot open the file "',pathname,filename,'"'], ...
        'Error','error');
    collection = 0;
    return
end

collection = {};
collection.filename = filename;
collection.input_names = {};
collection.formatted_input_names = {};

line = fgetl(ifid);
data_start = false;
while line ~= -1
    tab = sprintf('\t');
    fields = split(line,tab);
    if strcmp(fields{1},'X') == 1 || strcmp(fields{1},'x') == 1
        data_start = true;
        collection.x = [];
        collection.Y = zeros(0,length(fields)-1);
        collection.num_samples = length(fields)-1;
        str = repmat('%f',1,collection.num_samples+1);
        data = cell2mat(textscan(ifid,str,'delimiter',sprintf('\t')));
        collection.Y = data(:,2:end);
        collection.x = data(:,1);
    end
    line = fgetl(ifid);
end
if ~isfield(collection,'x')
    msgbox(['The file "',fullfile(pathname,filename), ...
        '" is not a spectrum collection'], ...
        'Error','error');
    collection = 0;
    return;
end
collection.x = collection.x';
fclose(ifid);

%% During this second pass we will read the header information
ifid = fopen([pathname,filename]);
if strcmp(ifid,'"stdin"') == 1 || ifid < 0
    msgbox(['Cannot open file ',pathname,filename]);
    collection = 0;
    return
end

line = fgetl(ifid);
while line ~= -1
    tab = sprintf('\t');
    fields = split(line,tab);
    if strcmp(fields{1},'X') == 1 || strcmp(fields{1},'x') == 1
        break; % This has already been done
    else
        input_name = fields{1};
        collection.input_names{end+1} = input_name;
        name = regexprep(input_name,' ','_');
        field_name = lower(name);
        collection.formatted_input_names{end+1} = field_name;
        if length(fields) == 2 || strcmp(field_name,'description') || strcmp(field_name,'processing_log') || strcmp(field_name,'collection_id')
            collection.(field_name) = fields{2};
        else
            % Try to convert to num
            values = NaN*ones(1,collection.num_samples);
            try
                found_str = false;
                all_empty = true;
                for i = 2:length(fields)
                    if ~isempty(fields{i})
                        all_empty = false;
                    end
                    [v, num_read] = sscanf(fields{i},'%f');
                    if ~isempty(v) && num_read == 1
                        values(i-1) = v;
                    elseif ~isempty(fields{i}) % contains string
                        found_str = true;
                    end
                end
                if found_str || all_empty
                    values = [];
                end
            catch ME
                values = [];
            end
            if ~isempty(values)
                collection.(field_name) = values;
            else
                values = cell(1,length(collection.num_samples));
                for i = 2:length(fields)
                    values{i-1} = fields{i};
                end
                collection.(field_name) = values;%{fields{2:end}};
            end
        end
    end
    line = fgetl(ifid);
end
fclose(ifid);

if collection.x(1) < collection.x(2)
    collection.x = collection.x(end:-1:1);
    collection.Y = collection.Y(end:-1:1,:);
end