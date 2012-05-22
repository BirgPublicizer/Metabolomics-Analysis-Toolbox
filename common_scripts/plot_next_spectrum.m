function plot_next_spectrum
collections = getappdata(gcf,'collections');
c = getappdata(gcf,'collection_inx');
s = getappdata(gcf,'spectrum_inx')+1;
if s > collections{c}.num_samples
    c = c + 1;    
    s = 1;
end
if c > length(collections) % Can't go any further
    c = c - 1;
    s = collections{c}.num_samples;
end

setappdata(gcf,'collection_inx',c);
setappdata(gcf,'spectrum_inx',s);

plot_all