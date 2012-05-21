function temp_bins = create_temp_bins(grouped_maxs,align_directions)
bins = [];
j = rows(grouped_maxs)+1;
while j > 1
    if align_directions(j) ~= -1 % Match
        match_j = align_directions(j);
        bins(end+1,:) = [match_j-1,j-1];
        j = match_j-1;
    elseif align_directions(j) == -1 % Left
        bins(end+1,:) = [0,j-1];
        j = j - 1;
    end
end
temp_bins = bins;

function n = rows(mt)
nm = size(mt);
n = nm(1);