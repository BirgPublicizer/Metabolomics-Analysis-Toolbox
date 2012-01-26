function collection = adjust_y_deconvolution(collection,bins,deconvolve)
x = collection.x;
[num_dp,num_spectra] = size(collection.Y);
for s = 1:num_spectra
    if ~isfield(collection,'regions')
        continue;
    end
    try
        for b = 1:length(deconvolve)
            y = collection.Y(:,s);
            if deconvolve(b) && isfield(collection.regions{s}{b},'BETA0')
                yinxs = collection.regions{s}{b}.inxs;
                BETA = collection.regions{s}{b}.BETA0;
                collection.regions{s}{b}.y_individual_peaks = {};
                for i = 1:length(BETA)/4
                    collection.regions{s}{b}.y_individual_peaks{i} = global_model(BETA(4*(i-1) + (1:4)),collection.x(yinxs),1,{});
                end
                enabled_xinxs = [];
                for m = 1:length(collection.regions{s}{b}.maxs)
                    minx = find(collection.regions{s}{b}.maxs(m) == collection.maxs{s});
                    if collection.regions{s}{b}.include_mask(minx) == 1
                        enabled_xinxs(end+1) = m;
                    end
                end
                xinxs = enabled_xinxs;
                if ~isempty(xinxs)
                    y_bin = global_model(BETA((4*(xinxs(1) - 1)+1):(4*(xinxs(1) - 1)+4)),collection.x(yinxs),1,{});
                    for i = 2:length(xinxs)
                        y_bin = y_bin + global_model(BETA((4*(xinxs(i) - 1)+1):(4*(xinxs(i) - 1)+4)),collection.x(yinxs),1,{});
                    end
                    y(yinxs) = y(yinxs) - collection.regions{s}{b}.y_peaks - collection.regions{s}{b}.y_baseline + y_bin';
                else
                    y(yinxs) = y(yinxs) - collection.regions{s}{b}.y_peaks - collection.regions{s}{b}.y_baseline;
                end                
                collection.regions{s}{b}.y_adjusted = y(yinxs);
            else
                left = bins(b,1);
                right = bins(b,2);
                inxs = find(left >= x & x >= right);
                collection.regions{s}{b}.inxs = inxs;
                collection.regions{s}{b}.y_adjusted = y(inxs);                
            end
        end
    catch ME % there was an error, which probably means that the deconvolution was not completed
        msgbox('Invalid deconvolution state. Try restarting the deconvolution.');
        throw(ME);
    end
end