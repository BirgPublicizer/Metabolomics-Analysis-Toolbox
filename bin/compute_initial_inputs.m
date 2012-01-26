function [BETA0,lb,ub] = compute_initial_inputs(x,y,maxs,mins,inxs)
min_M = 0.00001;
min_G = 0.00001;
% Compute the initial values for the width/height and offset
BETA0 = [];
lb = [];
ub = [];

[sorted_maxs,sorted_maxs_inxs] = sort(maxs);

for inx = 1:length(maxs)
    g_M = calc_height(max(mins(inx,1),1):min(mins(inx,2),length(y)),y);
    g_G = calc_width(max(mins(inx,1),1):min(mins(inx,2),length(y)),x,y);
    % Peaks are not wider than they are tall (initially)
    if g_G > g_M
        g_G = g_M;
    end
    g_P = 0.5;
    lb_x0 = x(min(mins(inx,2),length(y)));
    inx_into_sorted = find(sorted_maxs_inxs == inx);
    % Make sure the peaks cannot switch order
    if inx_into_sorted < length(sorted_maxs)
        mid = (x(sorted_maxs(inx_into_sorted)) + x(sorted_maxs(inx_into_sorted+1)))/2;
        if mid > lb_x0
            lb_x0 = mid;
        end
    end
    ub_x0 = x(max(mins(inx,1),1));
    if inx_into_sorted > 1
        mid = (x(sorted_maxs(inx_into_sorted)) + x(sorted_maxs(inx_into_sorted-1)))/2;
        if mid < ub_x0
            ub_x0 = mid;
        end
    end
    BETA0 = [BETA0;max([g_M,min_M]);max([g_G,min_G]);g_P;x(maxs(inx))];
    lb = [lb;min_M;min_G;0;lb_x0];
    ub = [ub;max(y(inxs));...
        2*abs(x(inxs(1))-x(inxs(end)));1;ub_x0];
end