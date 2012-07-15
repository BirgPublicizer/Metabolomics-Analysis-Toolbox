function normed_collections = pq_normalize( unbinned_collections, binned_collections, target_sum, use_spectrum, use_bin)
% Applies probabilistic quotient normalization to the binned spectra
%
% The spectra in use_spectra are the ones used for creating the reference
% spectrum. The bins in use_bin are the ones whose quotients with the
% reference spectrum are used to determine the quotient for the spectrum.
%
% If fewer than two spectra are provided, the collections are returned
% unchanged.
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% unbinned_collections- a cell array of spectral collections. Each spectral
%                       collection is a struct. This is the format
%                       of the return value of load_collections.m in
%                       common_scripts. 
%
% binned_collections  - The collections from unbinned_collections, but 
%                       binned appropriately to avoid problems with 
%                       peak-shifts.
%
%                       All these collections must use the same
%                       set of x values. Check with only_one_x_in.m.
%
% target_sum          - the target sum for the sum normalization carried
%                       out before the main pqn
%
% use_spectrum        - a cell array of logical arrays. use_spectrum{i}(j) 
%                       is true iff the j-th spectrum in the i-th 
%                       collection should be used in calculating the 
%                       median.
% 
% use_bin             - array of logical. use_bin(i) is true iff the bin 
%                       at index i is used in calculating quotients for 
%                       determining the normalization coefficient
%
% use_waitbar         - if true then a waitbar is displayed during 
%                       processing. Must be a logical.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% normed_collections - unbinned_collections after normalization. The 
%                      processing log is updated and the spectra are all 
%                      multiplied by their respective dilution factors. 
%                      The original_multiplied_by field is respected.
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> cols{1}.x = 1:7; cols{1}.processing_log = 'Created.';
% >> cols{1}.Y=[2,1,0.4;1,0.5,0.2;10,5,2;20,40,60;10,5,2;1,0.5,0.2;3,1.5,0.6];
% >> cols{2} = cols{1};
% >> cols{2}.Y=[2,5;1,1;10,21;20,39;10,21;1,1;3,5];
% >> cols{2}.original_multiplied_by = [1,2];
% >> use_spectra = {[true, true, true],[true, true]};
% >> use_bins    = [true, true, true, true, true, true, true];
% >> norm = pq_normalize(cols, cols, 47, use_spectra, use_bins);
% 
% norm{1}.Y = 
%    2.0000    1.6846    1.6846
%    1.0000    0.8423    0.8423
%   10.0000    8.4229    8.4229
%   20.0000   67.3835  252.6882
%   10.0000    8.4229    8.4229
%    1.0000    0.8423    0.8423
%    3.0000    2.5269    2.5269
%
% norm{1}.original_multiplied_by =  [1.0000    1.6846    4.2115]
% norm{1}.processing_log = 'Created. Sum normalized to 47. Probablistic quotient normalized using spectra {[1, 1, 1], [1, 1]} to generate a reference spectrum and ignoring bins centered at [] in generating the quotients.
%
% norm{2}.Y = 
%    2.0000    2.5269
%    1.0000    0.5054
%   10.0000   10.6129
%   20.0000   19.7097
%   10.0000   10.6129
%    1.0000    0.5054
%    3.0000    2.5269
%
% norm{2}.original_multiplied_by =  [1.0000    1.0108]
% norm{2}.processing_log = 'Created. Sum normalized to 47. Probablistic quotient normalized using spectra {[1, 1, 1], [1, 1]} to generate a reference spectrum and ignoring bins centered at [] in generating the quotients.
%
%
% >> % This example is the same as above but with the middle bin excluded
% >> cols{1}.x = 1:7; cols{1}.processing_log = 'Created.';
% >> cols{1}.Y=[2,1,0.4;1,0.5,0.2;10,5,2;20,40,60;10,5,2;1,0.5,0.2;3,1.5,0.6];
% >> cols{2} = cols{1};
% >> cols{2}.Y=[2,5;1,1;10,21;20,39;10,21;1,1;3,5];
% >> cols{2}.original_multiplied_by = [1,2];
% >> use_spectra = {[true, true, true],[true, true]};
% >> use_bins    = [true, true, true, false, true, true, true];
% >> norm = pq_normalize(cols, cols, 47, use_spectra, use_bins);
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%

if num_spectra_in(binned_collections) < 2
    normed_collections = collections;
    return;
end

binned_collections = sum_normalize( binned_collections, target_sum );
unbinned_collections = sum_normalize( unbinned_collections, target_sum );

ref_spec = median_spectrum( binned_collections, use_spectrum );

with_quotients = set_quotients_field( binned_collections, ref_spec );

multipliers = pq_multipliers( with_quotients, use_bin );

normed_collections = multiply_collections( unbinned_collections, multipliers );

normed_collections = append_to_processing_log( normed_collections, ...
    sprintf(['Probablistic quotient normalized using spectra %s to ' ...
        'generate a reference spectrum and ignoring bins centered ' ...
        'at %s in generating the quotients.'], to_str(cell_find(use_spectrum)), ...
        to_str(ref_spec.x(~use_bin)) ...
    ));
end

