function [smoothed_y,maxs,mins] = wavelet_smooth(y,height_threshold,options)
%WAVELET_SMOOTH Smooths the input and returns its maxima and minima
%
% Smooths the input y values (treating them as evenly-spaced samples of a
% function) using wavelet denoising then triangle smoothing.  Then finds 
% the local maxima and minima of the smoothed function where the maxima 
% have a height greater than height_threshold.
%
% y                 the input function values (evenly spaced)
% height_threshold  the minimum height of a detected maximum
% options           a struct containing values to be passed to wden.  If
%                   fields are not present then they are assigned default
%                   values.
%
%                   Recognized options are: 
%                   tptr, sorh, scal, level, wname
%
%                   Level is equivalent to N in the wden help page.  All
%                   the other options have the same name.
%
%                   The defaults are (in the same order as above):
%                   sqtwolog, s, mln, 3, db3
%
% smoothed_y The y_values after wavelet smoothing
% maxs       The indices of the maxima of the smoothed function
% mins       The indices of the two bracketing minima of the smoothed function for the
%            local maximum at the same index.  mins(i,1) and mins(i,2)
%            bracket maxes(i)


level = 3;
if exist('options','var') && isfield(options,'level')
    level = options.level;
end
tptr = 'sqtwolog';
if exist('options','var') && isfield(options,'tptr')
    tptr = options.tptr;
end
sorh = 's';
if exist('options','var') && isfield(options,'sorh')
    sorh = options.sorh;
end
scal = 'mln';
if exist('options','var') && isfield(options,'scal')
    scal = options.scal;
end
wname = 'db3';
if exist('options','var') && isfield(options,'wname')
    wname = options.wname;
end

% Find first value in order to avoid edge effects. 
deb = y(1);

% De-noise signal using soft fixed form thresholding 
% and unknown noise option. 
if exist('wden','builtin')
    smoothed_y = wden(y-deb,tptr,sorh,scal,level,wname)+deb;
else
    smoothed_y = y;
end

% smoothed_y = max(smoothed_y,y);
% Now apply triangle smoothing
n = 3;
for i = 1:length(smoothed_y)
    inxs = max([1,i-(n-1)/2]):min([length(smoothed_y),i+(n-1)/2]);
    smoothed_y(i) = mean(smoothed_y(inxs));
end

smoothed_maxs = find_internal_local_maxima(smoothed_y);
smoothed_mins = find_bracketing_minima(smoothed_y,smoothed_maxs);
maxs = [];
mins = [];
for i = 1:length(smoothed_maxs)
    mx_inx = smoothed_maxs(i);
    left_inx = smoothed_mins(i,1);
    right_inx = smoothed_mins(i,2);
    max_height = max([abs(smoothed_y(mx_inx)-smoothed_y(left_inx)), ...
                      abs(smoothed_y(mx_inx)-smoothed_y(right_inx))]);
    if max_height >= height_threshold
        mins(end+1,:) = smoothed_mins(i,:); %#ok<AGROW>
        maxs(end+1) = smoothed_maxs(i); %#ok<AGROW>
    end
end

% Make sure there are at least 3 above the threshold left and right
n = 3;
for i = 1:length(maxs)
    below = false;
    for j = max([maxs(i)-n,1]):max([maxs(i)-1,1])
        if smoothed_y(j) < height_threshold
            below = true;
            break
        end
    end
    for j = min([maxs(i)+1,length(smoothed_y)]):min([maxs(i)+n,length(smoothed_y)])
        if smoothed_y(j) < height_threshold
            below = true;
            break
        end
    end
    if below
        maxs(i) = NaN; %#ok<AGROW>
        mins(i,:) = [NaN NaN]; %#ok<AGROW>
%         maxs = maxs([1:i-1,i+1:end]);
%         mins = mins([1:i-1,i+1:end],:);
    end
end
i = 1;
while i <= length(maxs)
    if isnan(maxs(i))
        maxs = maxs([1:i-1,i+1:end]);
        mins = mins([1:i-1,i+1:end],:);
    else
        i = i + 1;
    end
end
