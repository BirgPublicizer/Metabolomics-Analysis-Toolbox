function plot_previous_spectrum
collections = getappdata(gcf,'collections');
c = getappdata(gcf,'collection_inx');
s = getappdata(gcf,'spectrum_inx')-1;
if s == 0
    if c > 1
        c = c - 1;
        s = collections{c}.num_samples;
    else % Can't go further
        s = s + 1;
    end
end

setappdata(gcf,'collection_inx',c);
setappdata(gcf,'spectrum_inx',s);

plot_all