function new_collection = bin_collection(collection,autoscale,bins,names)
new_collection = collection;
num_regions = size(bins,1);
new_collection.Y = zeros(num_regions,collection.num_samples);
new_collection.x = [];

if autoscale
    means = [];
    stdevs = [];
    for i = 1:num_regions
        bin_values = [];
        for j = 1:size(Y,2)
            bin_values(j) = sum(collection.regions{j}{i}.y_adjusted);
        end
        means(i) = mean(bin_values);
        stdevs(i) = std(bin_values);
    end
end

for i = 1:num_regions
    if isempty(names{i}) || strcmp(deblank(names{i}),'')
        new_collection.x{i} = mean(bins(i,:));
    else
        new_collection.x{i} = deblank(names{i});
    end
    for j = 1:collection.num_samples
        if autoscale
            new_collection.Y(i,j) = (sum(collection.regions{j}{i}.y_adjusted)-means(i))/stdevs(i);
        else
            new_collection.Y(i,j) = sum(collection.regions{j}{i}.y_adjusted);
        end
    end
end
new_collection.processing_log = [new_collection.processing_log,' Binned.'];