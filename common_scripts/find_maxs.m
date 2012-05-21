function [ maxs ] = find_maxs( coeffs )
%find_mins - returns an array of index of each maximum
maxs = [];
for i=2:length(coeffs)-1
    if (coeffs(i-1) < coeffs(i) && coeffs(i+1) < coeffs(i))
        maxs(end+1) = i;
    end
end

