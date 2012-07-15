function collections = sum_normalize(collections, target_sum)
% Multiplies every spectrum so its area is target_sum
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% collections - the output of a call to loadcollections.m. a cell array of 
%               spectral collections structs.
%
% target_sum  - a scalar giving the sum to which the returned collections'
%               y-values must sum
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
%
% collections - the input collection with ' Sum normalized to target_sum'
%               appended to the processing log and with all the spectral Y
%               values summing to target_sum. And having an updated
%               original_multiplied_by field indicating the normalization
%               constant the sum was multiplied by.
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> colns{1}.Y=[1,2,3;9,18,47]; normed = sum_normalize(colns, 100)
% 
% normed{1}.Y =
%
%     10    10     6
%     90    90    94
%
% sum(normed{1}.Y) == [100,100,100]
%
% normed{1}.processing_log == 'Sum normalized to 100.'
%
%
%
% >> colns{1}.Y=[5,2,3;5,18,47]; colns{1}.processing_log='Foo.'; 
% >> colns{2}.Y=[1]; colns{2}.processing_log='Bar.';
% >> colns{2}.original_multiplied_by = [0.2];
% >> normed = sum_normalize(colns, 500)
% 
% normed{1}.Y =
%
%     250    50     30
%     250    450    470
%
% sum(normed{1}.Y) == [500,500,500]
%
% normed{1}.processing_log == 'Foo. Sum normalized to 500.'
% 
% normed{1}.original_multiplied_by == [25, 25, 10]
%
% normed{2}.Y =
%
%     500
%
% sum(normed{2}.Y) == [500]
%
% normed{2}.processing_log == 'Bar. Sum normalized to 500.'
%
% normed{2}.original_multiplied_by == [100]
%
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Paul Anderson (May 2012) pauleanderson@gmail.com
%
% Eric Moyer (May 2012) eric_moyer@yahoo.com
%

collections = ensure_original_multiplied_by_field(collections);
for c = 1:length(collections)
    collections{c}.processing_log = strtrim(sprintf('%s Sum normalized to %g.', ...
        collections{c}.processing_log, target_sum));
    for s = 1:size(collections{c}.Y,2)
        sm = sum(collections{c}.Y(:,s));
        mul = target_sum/sm;
        collections{c}.Y(:,s) = collections{c}.Y(:,s) * mul;
        collections{c}.original_multiplied_by(s) = ...
            collections{c}.original_multiplied_by(s) * mul;
    end
end
