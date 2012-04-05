function y_without_zeros = interpolate_zeros(x,y)
% Construct a special y where the zero regions are linearly interpolated.  
% If there are no non-zero y's in the original, the returned array will be
% unchanged.
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
%
% x   The x values for the input (1 x n array of double)
%
% y   The y values for the input (1 x n array of double)
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
%
% y_without_zeros  Identical to y except that all regions with zeros have
%                  been replaced by a line drawn between the non-zeros at
%                  the end-points.  And any regions that include the first
%                  or last elements of the array have been interpolated
%                  by repeating the non-zero value on their other end.  If
%                  the input y was all zeros, then it is returned
%                  unchanged.  (1 x n array of double)
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
%
% >>interpolate_zeros(1:10, [1:7 0 0 0])
% 
% ans =
% 
%      1     2     3     4     5     6     7     7     7     7
% 
%
% >>interpolate_zeros(1:10, [0 0 0 1:7])
% 
% ans =
% 
%      1     1     1     1     2     3     4     5     6     7
%
%
% >>interpolate_zeros(1:10, [1:3 0 0 0 7:10])
% 
% ans =
% 
%      1     2     3     4     5     6     7     8     9    10
%
%
% >>interpolate_zeros(1:10, zeros(1,10))
% Warning: Interpolate zeros was passed an array consisting of only 10 zeros.  No interpolation was
% possible.  It was returned unchanged. 
% > In interpolate_zeros at 70
% 
% ans =
% 
%      0     0     0     0     0     0     0     0     0     0


% Remove zeros on the ends by extrapolating the last point as a constant 
% function (just repeating the first non-zero value encountered as you go
% in from the ends)
y_without_zeros = y;

%Remove zeros at begining
first_nonzero = find(y, 1, 'first');
if isempty(first_nonzero) %No non-zero elements
    warning(['Interpolate zeros was passed an array consisting of only '...
        '%d zeros.  No interpolation was possible.  It was returned ' ...
        'unchanged.'], length(y));
    return;
end
y_without_zeros(1:first_nonzero)=y(first_nonzero)*ones(1,first_nonzero);

%Remove zeros at end - no need to check for empty since we already know
%there is at least one non-zero element
last_nonzero = find(y, 1, 'last');
y_without_zeros(last_nonzero:length(y))= ...
    y(last_nonzero)*ones(1,length(y)-last_nonzero+1);

% Interpolate interior zeros
xs = [];
ys = [];
xi = [];
inxs = [];
y = y_without_zeros; % Base interpolation off of the fixed input
for i = 2:length(y) % We know the first is not zero
    %If a value is zero, add it to the list of zero indices
    if y(i) == 0  
        xi(end+1) = x(i); %#ok<AGROW>
        inxs(end+1) = i; %#ok<AGROW>
        if isempty(xs)
            xs(end+1) = x(i-1); %#ok<AGROW>
            ys(end+1) = y(i-1); %#ok<AGROW>
        end
    %If we have a non-zero value and undealt-with zero indices, 
    %interpolate from the last nonzero value to this one
    elseif ~isempty(xi) 
        xs(end+1) = x(i); %#ok<AGROW>
        ys(end+1) = y(i); %#ok<AGROW>
        y_without_zeros(inxs) = interp1(xs,ys,xi,'linear');
        xi = [];
        inxs = [];
        ys = [];
        xs = [];
    end
end
