function [ with_quotients ] = set_quotients_field( collections, ref_spec )
% Set (or add) quotients field to each element of collections giving the quotient of the reference spectrum with each of the collection's y values.
%
% This code is intended for use with the probabilistic quotient
% normalization routines to update the quotients used in calculating the
% normalization factors.
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% collections - a cell array of spectral collections. Each spectral
%               collection is a struct. This is the format
%               of the return value of load_collections.m in
%               common_scripts. All collections must use the same set of x
%               values. Check with only_one_x_in.m
%
% ref_spec    - a struct with two fields, x and Y. x has the x values for
%               the reference spectrum and Y(i) has the y values
%               corresponding to x(i) in the reference spectrum.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% with_quotients - identical to collections except with_quotients{i} has a
%                  field "quotients" where
%                  with_quotients{i}.quotients(k,l) =
%                  ref_spec.Y(k)/collections{i}.Y(k,l)
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> with_quotients = set_quotients( collections, ref_spec )
%
% with_quotients{i}.quotients(k,l) = ref_spec.Y(k)/collections{i}.Y(k,l)
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%

with_quotients = collections;
for c = 1:length(collections)
    num_samples = size(collections{c}.Y,2);
    repeated = repmat(ref_spec.Y, 1, num_samples);
    with_quotients{c}.quotients = repeated ./ collections{c}.Y;
end

end

