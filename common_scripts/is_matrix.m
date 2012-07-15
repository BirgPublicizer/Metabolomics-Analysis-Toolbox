function retval = is_matrix( in )
% IS_MATRIX drop-in replacement for ismatrix for backward compatibility
%
% Versions of matlab before R2010b do not have ismatrix. This implements
% it from the specification. Note that I cannot come up with a way to get
% size to return an array with either negative or nonintegral values, so
% this code just does checks whether the size has 2 entries.
%
% ------------------------------------------------------------------------
% Below is a copy of the documentation for ismatrix in Matlab 2010b
% ------------------------------------------------------------------------
% 
% Determine whether input is matrix 
%
% **********
% * Syntax *
% **********
% 
% ismatrix(V)
% 
% ***************
% * Description *
% ***************
% 
% ismatrix(V) returns logical 1 (true) if size(V) returns [m n] with nonnegative integer values m and n, and logical 0 (false) otherwise.
%
% ************
% * Examples *
% ************
% 
% Create three vectors:
% V1 = rand(5,1);
% V2 = rand(5,1);
% V3 = rand(5,1);
% 
% 
% Concatenate the vectors and check that the result is a matrix. ismatrix returns 1:
% M = cat(2,V1,V2,V3);
% ismatrix(M)
% ans =
%      1
% 
% ------------------------------------------------------------------------
% Examples
% ------------------------------------------------------------------------
% 
% >> is_matrix(cell(1))
%
% ans = 1
% 
% >> is_matrix(cell(2,3))
%
% ans = 1
% 
% >> is_matrix(cell(2,3,5))
%
% ans = 0
% 
% >> is_matrix(ones(5))
%
% ans = 1
% 
% >> is_matrix(ones(4,2))
%
% ans = 1
% 
% >> is_matrix(ones(5,3,1))
%
% ans = 1
% 
% >> is_matrix(ones(5,3,3))
%
% ans = 0

retval = length(size(in)) == 2;

end

