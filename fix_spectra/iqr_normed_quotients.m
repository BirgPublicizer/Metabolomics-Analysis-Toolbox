function scaled_quotients = iqr_normed_quotients( quotients, only_subtract_ok, use_row)
% Returns the quotients scaled by their ratio with a quotient-appropriate iqr and shifted so median is 0
% 
% Quotients differ on a logarithmic scale when doing dilution
% normalization. Otherwise, the midpoint between 1/10, 10/1 is near 5. A
% logarithmic transformation would turn these into -1, 1 and their midpoint
% be 1.
%
% This routine first takes the absolute values of the quotients member of
% collection, then the logarithm. Then it takes the iqr of each column 
% then divides everything by that iqr. Finally, it subtracts the median.
% Only the rows selected by use_row are used in calculating the median and
% iqr.
%
% This procedure is similar to the typical normalization of subtracting 
% the mean and dividing by the standard deviation. Except I use median 
% and iqr and linearize the space by using the logarithm before I start
% normalizing.
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% quotients        - a real matrix - if empty, then an empty matrix is
%                    returned
%
% only_subtract_ok - (optional) scalar logical. If true then when there is
%                    only one selected row, then the iqr is not calculated
%                    and the median is subtracted. If false then having
%                    only one selected row is an error. If absent, then the
%                    same as being false.
%
% use_row          - (optional) a logical row vector. If true then the row 
%                    is used in calculating the iqr and the median. If 
%                    false, the row is still normalized but not used in 
%                    the calculation.  If absent, all rows are used. If 
%                    present, must have he same number of rows as 
%                    quotients. Must have at least 1 true entry if
%                    only_subtract_ok is true. Must have at least 2 true
%                    entries if only_subtract_ok is false.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% scaled_quotients - the quotients array scaled as defined in the main
%                    description
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> sc = iqr_normed_quotients( [0.1,1;0.2,3;4,0.25] )
%
% sc =
%
%   -0.2505         0
%         0    0.5895
%    1.0828   -0.7438
%
% >> sc = iqr_normed_quotients( [0.1,1;0.2,3;4,0.25], false, [true,false,true] )
%
% sc =
%
%   -0.5000    0.5000
%   -0.3121    1.2925
%    0.5000   -0.5000
%
% >> sc = iqr_normed_quotients( [0.1,1;0.2,3;4,0.25], true, [false,false,true] )
%
% sc =
%
%   -3.6889    1.3863
%   -2.9957    2.4849
%         0         0
%
% >> sc = iqr_normed_quotients( [], true, [false,false,true] )
%
% sc =
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%

% Return quotients unchanged if it is empty
if numel(quotients) == 0
    scaled_quotients = quotients;
    return;
end


% Set default values for optional inputs
if ~exist('only_subtract_ok', 'var')
    only_subtract_ok = false;
end

if ~exist('use_row', 'var')
    use_row = true(size(quotients,1),1);
end


% Take care of error conditions
num_rows = sum(use_row);

if num_rows == 0
    error('iqr_normed_quotients:at_lest_one_row', ...
        'The use_row parameter must have at least one true value.');
elseif num_rows == 1 && ~only_subtract_ok
    error('iqr_normed_quotients:at_least_two_rows', ...
        ['The use_row parameter must have at least two true values '...
        'unless the only_subtract_ok parameter is true']);
end

if length(use_row) ~= size(quotients, 1)
    error('iqr_normed_quotients:same_num_rows', ...
        'The use_row parameter must have the same number of entries as the quotients array.');
end    


% Take the log of the absolute value of the quotients. The log makes it
% so 1/10 and 10/1 are equidistant from 1.
abs_quotients = log(abs(quotients));

% Measure the iqr - or set it to 1 if there is only one row and we are only
% subtracting
if num_rows > 1
    i_q_r = iqr(abs_quotients(use_row,:), 1);
else
    assert(only_subtract_ok && num_rows == 1);
    i_q_r = ones(1, size(quotients,2));
end
rep_iqr = repmat(i_q_r, size(quotients,1), 1);

% Measure the median
med = prctile(abs_quotients(use_row,:), 50, 1);
rep_median = repmat(med, size(quotients,1), 1);

% Scale the quotients by the IQR
scaled_quotients = (abs_quotients - rep_median) ./ rep_iqr ;


end

