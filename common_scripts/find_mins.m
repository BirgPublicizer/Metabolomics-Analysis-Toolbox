function [ mins ] = find_mins( I, maxs )
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