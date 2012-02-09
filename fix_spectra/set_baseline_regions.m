function set_baseline_regions
left_noise_cursor = getappdata(gcf,'left_noise_cursor');
right_noise_cursor = getappdata(gcf,'right_noise_cursor');
left_noise = GetCursorLocation(gcf,left_noise_cursor);
right_noise = GetCursorLocation(gcf,right_noise_cursor);

clear_regions_cursors
prompt={'Enter the minimum width of a baseline region:','# standard deviations:','Padding:'};
name='Baseline regions';
numlines=1;
defaultanswer={'0.04','5','0.01'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
min_width_ppm = str2num(answer{1});
noise_std_mult = str2num(answer{2});
padding = str2num(answer{3});

collections = getappdata(gcf,'collections');
c = getappdata(gcf,'collection_inx');
s = getappdata(gcf,'spectrum_inx');

% This will be set to the optimal from the previous experiment
options = {};
options.level = 2;
options.tptr = 'heursure';
options.sorh = 's';
options.scal = 'one';
options.wname = 'sym5';


x = collections{c}.x;
xwidth = abs(x(1)-x(2));
min_width = round(min_width_ppm/xwidth);
Y = collections{c}.Y;
inxs = find(left_noise >= x & x >= right_noise);
noise_std = std(Y(inxs,s));
[y_smoothed,maxs,mins] = smooth(Y(:,s),noise_std*noise_std_mult,options);
regions = [];
for i = 1:length(maxs)
    left_inx = mins(i,1);
    right_inx = mins(i,2);
    inxs = [];
    for j = left_inx-1:-1:1
        if abs(Y(left_inx,s)-Y(j,s)) <= noise_std*noise_std_mult
            inxs(end+1) = j;
        else
            break;
        end
    end
    inxs = inxs(end:-1:1);
    inxs(end+1) = left_inx;
    for j = left_inx+1:length(x)
        if abs(Y(left_inx,s)-Y(j,s)) <= noise_std*noise_std_mult
            inxs(end+1) = j;
        else
            break;
        end
    end
    if length(inxs) >= min_width
        regions(end+1,:) = [inxs(1),inxs(end)];
    end

    inxs = [];
    for j = right_inx-1:-1:1
        if abs(Y(right_inx,s)-Y(j,s)) <= noise_std*noise_std_mult
            inxs(end+1) = j;
        else
            break;
        end
    end
    inxs = inxs(end:-1:1);
    inxs(end+1) = right_inx;
    for j = right_inx+1:length(x)
        if abs(Y(right_inx,s)-Y(j,s)) <= noise_std*noise_std_mult
            inxs(end+1) = j;
        else
            break;
        end
    end
    if length(inxs) >= min_width
        regions(end+1,:) = [inxs(1),inxs(end)];
    end
end
mask = zeros(size(x));
nm = size(regions);
for i = 1:nm(1)
    mask(regions(i,1):regions(i,2)) = 1;
end
regions = [];
i = 1;
while i <= length(x)
    if mask(i) % Start
        regions(end+1,:) = [NaN, NaN];
        regions(end,1) = i;
        i = i + 1;
        while i <= length(x) && mask(i)
            i = i + 1;
        end
        regions(end,2) = i - 1;
    end
    i = i + 1;
end

nm = size(regions);
regions_cursors = zeros(size(regions));
for i = 1:nm(1)
    regions_cursors(i,1) = line([x(regions(i,1))-padding,x(regions(i,1))-padding],[min(Y(:,s)),max(Y(:,s))],'Color','g');
    regions_cursors(i,2) = line([x(regions(i,2))+padding,x(regions(i,2))+padding],[min(Y(:,s)),max(Y(:,s))],'Color','r');
end
setappdata(gcf,'regions_cursors',regions_cursors);
setappdata(gcf,'region_inx',1);