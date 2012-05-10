function collection = merge_collections_cell(collections)
collection = {};
for c = 1:length(collections)
    flds = fields(collections{c});
    for f = 1:length(flds)
        field = flds{f};
        if c == 1
            collection.(field) = {};
        end
        if strcmp(field,'num_samples')
            if c == 1
                collection.num_samples = 0;
            end
            collection.num_samples = collections{c}.num_samples + collection.num_samples;
        elseif strcmp(field,'x')
            if c == 1
                collection = rmfield(collection,'x');
                collection.X = {};
            end
            for s = 1:collections{c}.num_samples
                collection.X{end+1} = collections{c}.x';
            end
        elseif strcmp(field,'Y')
            for s = 1:collections{c}.num_samples
                collection.Y{end+1} = collections{c}.Y(:,s);
            end
        elseif ischar(collections{c}.(field)) || length(collections{c}.(field)) == 1
            collection.(field) = {collection.(field){:},collections{c}.(field)};
        elseif iscell(collections{c}.(field))
            for i = 1:length(collections{c}.(field))
                collection.(field){end+1} = collections{c}.(field){i};
            end
        elseif ismatrix(collections{c}.(field))
            for i = 1:length(collections{c}.(field))
                collection.(field){end+1} = collections{c}.(field)(i);
            end
        end
    end
end