% Make sure black
colors = get(gca,'colororder');
nm = size(colors);
offset = -1;
for i = 1:nm(1)
    s = sum(colors(i,:));
    if s == 0
        offset = i;
    end
end
if offset == -1
    colors(end+1,:) = [0,0,0];
    nm = size(colors);
    offset = nm(1);
end
