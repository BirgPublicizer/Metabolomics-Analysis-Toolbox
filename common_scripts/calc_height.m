function height=calc_height(inxs,I)
mn = min(I(inxs));
mx = max(I(inxs));
height = mx-mn;