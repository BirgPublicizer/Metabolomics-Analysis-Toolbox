function [ mins ] = find_bracketing_minima( I, maxs )
%find_bracketing_minima - Returns the indices of the minima that bracket each maximum in maxs
%
% I    the function values
% maxs the indices of the internal local maxima in i
%
% mins mins(i) one is the local minim to the left of maxs(i) and the other
%      is to the right
mins = [];
for i=1:length(maxs)
    inx = maxs(i);
    left_inx = inx - 1;
    while left_inx > 1
        if (I(left_inx-1)-I(left_inx) > 0 && I(left_inx+1)-I(left_inx) > 0)
            break;
        end
        left_inx = left_inx - 1;
    end
    if left_inx <= 1
        left_inx = 1;
    end
    right_inx = inx + 1;
    while right_inx < length(I)
        if (I(right_inx-1)-I(right_inx) > 0 && I(right_inx+1)-I(right_inx) > 0)
            break;
        end
        right_inx = right_inx + 1;
    end
    if right_inx >= length(I)
        right_inx = length(I);
    end
    mins(end+1,1) = left_inx;
    mins(end,2) = right_inx;
end