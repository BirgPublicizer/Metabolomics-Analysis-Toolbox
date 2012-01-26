function width=calc_width(inxs,cs,I)
[mx,loc] = max(I(inxs));
% Find the location of the half height
temp = abs(I(inxs)-mx/2);
[v,loc2]=sort(temp);
a_loc = inxs(loc);
a_loc2 = inxs(loc2(1));
inx1 = a_loc-abs(a_loc-a_loc2);
if inx1 <= 0
    inx1 = 1;
end
inx2 = a_loc+abs(a_loc-a_loc2);
if inx2 > length(cs)
    inx2 = length(cs);
end
width = abs(cs(inx1)-cs(inx2));