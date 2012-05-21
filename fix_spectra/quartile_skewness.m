function q_skew = quartile_skewness( data )
% Returns the quartile skewness of the given data
%
% For 1-dimensional data, the quartile smoothness is a number between -1
% and 1 that is calculated from: (q75-q50)-(q50-q25)/(q75-q25) where q75,
% q50, and q25 are the 75th, 50th (median), and 25th percentiles 
% respectively.
%
% Note: NaN's are treated as missing values and ignored
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% data - Data values.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% q_skew - if data is one dimensional, a scalar giving the quartile
%          smoothness of the data. Otherwise, collapses each column into a
%          skewness measure.
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> q_skew = quartile_skewness([1,1,2,2,3,3,3,3,3,3,6])
% 
% q_skew = -1 = ((3-3)-(3-2))/(3-2)
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%

q = prctile(data,[75,50,25]);
if isvector(data); q = q'; end
i_q_r = q(1,:)-q(3,:);
i_q_r(i_q_r==0) = 1; %Avoid NaN if upper and lower quartiles are identical - will give 0 skewness, which is correct
q_skew = (q(1,:)-2*q(2,:)+q(3,:))./i_q_r;

end

