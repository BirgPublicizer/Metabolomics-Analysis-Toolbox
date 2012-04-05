function output = output_regions(regions,deconvolve_mask)
outputs = {};
for r = 1:length(regions)
    if isempty(regions{r}.BETA0) || (exist('deconvolve_mask') && deconvolve_mask(r) == 0) % Nothing in this region
        continue;
    end
    eval_str = serialize(regions{r});
    if ~isempty(outputs)
        outputs{end+1} = sprintf(['\n',eval_str]);
    else
        outputs{end+1} = eval_str;
    end
end
try
    output = strcat(outputs{:});
catch ME
    error('There are no regions available/selected for deconvolution');
end
