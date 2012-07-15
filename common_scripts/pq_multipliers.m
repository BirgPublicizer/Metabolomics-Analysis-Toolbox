function multipliers = pq_multipliers( collections_with_quotients, use_bin )
% Calculates the probabilistic quotient multipliers for the input spectra
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% collections_with_quotients - The output of a call to set_quotients_field.
% 
%                              a cell array of spectral collections. Each 
%                              spectral collection is a struct. This is 
%                              the format of the return value of 
%                              load_collections.m in common_scripts. 
%
%                              As the result of set_quotients, this
%                              must have the field 'quotients'.
% 
% use_bin                    - array of logical. use_bin(i) is true iff the
%                              bin at index i (the i'th x value) is used 
%                              in calculating quotients for determining 
%                              the normalization coefficient.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% multipliers - a cell array in which each entry is a double row vector.
%               multipliers{c}(1,s) is the multiplier that will normalize
%               collections_with_quotients{c}.Y(:,s)
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> cols{1}.quotients = [1,2,3;1,3,10;1,2,10;1,2,10];
% >> cols{2}.quotients = [1;10;0;10]
% >> muls = pq_multipliers( cols, [true, true, true, true] )
% 
% muls{1} == [1,2.5,10];
% muls{2} == [5.5];
%
%
% >> cols{1}.quotients = [1,2,3;1,3,10;1,2,10;1,2,10];
% >> cols{2}.quotients = [1;10;0;10]
% >> muls = pq_multipliers( cols, [true, true, false, true] )
% 
% muls{1} == [1,2,10];
% muls{2} == [10];
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%

multipliers = cellfun(...
    @(in) prctile(in.quotients(use_bin,:), 50, 1), ...
    collections_with_quotients, 'UniformOutput', false);

end