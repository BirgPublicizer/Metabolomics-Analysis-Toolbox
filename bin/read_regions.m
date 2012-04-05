function regions = read_regions(stdin)
region_strs = split(stdin,sprintf('\n'));

regions = {};
for i = 1:length(region_strs)
    if regexpi(region_strs{i}, '^struct')
        region = eval(region_strs{i});
        regions{region.region_inx} = region;
    end
end