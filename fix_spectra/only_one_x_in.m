function only_one = only_one_x_in( collections )
% True iff the x vectors for all collections are identical
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
% 
% collections - a cell array of spectral collections. Each spectral
%               collection is a struct of spectra. This is the format
%               of the return value of load_collections.m in
%               common_scripts.
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
% 
% only_one - logical scalar: true iff all the x vectors for all of the
%            collections are identical. Note that this is true if the
%            collections cell array is empty or if there is only one
%            collection.
%
% -------------------------------------------------------------------------
% Examples
% -------------------------------------------------------------------------
%
% >> if only_one_x_in(collections); fprintf('There can only be one\n'); end
%
% if collections{1}.x is the same as collections{i}.x for all i, prints
% 'There can only be one' to the console.
%
% -------------------------------------------------------------------------
% Authors
% -------------------------------------------------------------------------
%
% Eric Moyer 2012 (eric_moyer@yahoo.com)

    function differ = matrices_differ(m1, m2)
        % This function takes care of checking dimensions to determine if
        % two multidimensional arrays differ
        s1 = size(m1);
        s2 = size(m2);
        differ = false;
        if length(s1) ~= length(s2)
            differ = true;
        elseif any(s1 ~= s2)
            differ = true;
        elseif any(m1 ~= m2)
            differ = true;
        end
    end

only_one = true;
if length(collections) < 2
    return;
end

x = collections{1}.x;
for i = 2:length(collections)
    if matrices_differ(collections{i}.x, x)
        only_one = false;
        return;
    end
end

end

