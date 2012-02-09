function [ maxs ] = find_internal_local_maxima( coeffs )
%find_internal_local_maxima - Return indices of local maxima in coeffs excluding end points
%
% coeffs The input values
maxs = [];
for i=2:length(coeffs)-1
    if (coeffs(i-1) < coeffs(i) && coeffs(i+1) < coeffs(i))
        maxs(end+1) = i;
    end
end
