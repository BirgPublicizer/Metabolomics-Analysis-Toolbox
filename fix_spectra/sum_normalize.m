function sum_normalize    
prompt={'Sum:'};
name='Normalize to reference';
numlines=1;
defaultanswer={'1000'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
target_sum = str2num(answer{1});

collections = getappdata(gcf,'collections');
for c = 1:length(collections)
    collections{c}.Y_fixed = collections{c}.Y;
    for s = 1:collections{c}.num_samples
        sm = sum(collections{c}.Y(:,s));
        collections{c}.Y_fixed(:,s) = collections{c}.Y(:,s)/sm*target_sum;
    end
end
setappdata(gcf,'collections',collections);
setappdata(gcf,'add_processing_log',sprintf('Sum normalized to %f.',target_sum));
setappdata(gcf,'temp_suffix','_sum_normalize');
plot_all
