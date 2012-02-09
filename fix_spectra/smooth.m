function [smoothed_y,maxs,mins] = smooth(y,height_threshold,options)
level = 3;
if exist('options') && isfield(options,'level')
    level = options.level;
end
tptr = 'sqtwolog';
if exist('options') && isfield(options,'tptr')
    tptr = options.tptr;
end
sorh = 's';
if exist('options') && isfield(options,'sorh')
    sorh = options.sorh;
end
scal = 'mln';
if exist('options') && isfield(options,'scal')
    scal = options.scal;
end
wname = 'db3';
if exist('options') && isfield(options,'wname')
    wname = options.wname;
end

% Find first value in order to avoid edge effects. 
deb = y(1);

% De-noise signal using soft fixed form thresholding 
% and unknown noise option. 
smoothed_y = wden(y-deb,tptr,sorh,scal,level,wname)+deb;
% smoothed_y = max(smoothed_y,y);
% Now apply triangle smoothing
n = 3;
for i = 1:length(smoothed_y)
    inxs = max([1,i-(n-1)/2]):min([length(smoothed_y),i+(n-1)/2]);
    smoothed_y(i) = mean(smoothed_y(inxs));
end

smoothed_maxs = find_maxs(smoothed_y);
smoothed_mins = find_mins(smoothed_y,smoothed_maxs);
maxs = [];
mins = [];
for i = 1:length(smoothed_maxs)
    mx_inx = smoothed_maxs(i);
    left_inx = smoothed_mins(i,1);
    right_inx = smoothed_mins(i,2);
    min_height = min([abs(smoothed_y(mx_inx)-smoothed_y(left_inx)),abs(smoothed_y(mx_inx)-smoothed_y(right_inx))]);
    if min_height >= height_threshold
        mins(end+1,:) = smoothed_mins(i,:);
        maxs(end+1) = smoothed_maxs(i);
    end
end

% % Make sure there are at least 3 above the threshold left and right
% n = 3;
% for i = 1:length(maxs)
%     below = false;
%     for j = max([maxs(i)-n,1]):max([maxs(i)-1,1])
%         if smoothed_y(j) < height_threshold
%             below = true;
%             break
%         end
%     end
%     for j = min([maxs(i)+1,length(smoothed_y)]):min([maxs(i)+n,length(smoothed_y)])
%         if smoothed_y(j) < height_threshold
%             below = true;
%             break
%         end
%     end
%     if below
%         maxs(i) = NaN;
%         mins(i,:) = [NaN NaN];
% %         maxs = maxs([1:i-1,i+1:end]);
% %         mins = mins([1:i-1,i+1:end],:);
%     end
% end
% i = 1;
% while i <= length(maxs)
%     if isnan(maxs(i))
%         maxs = maxs([1:i-1,i+1:end]);
%         mins = mins([1:i-1,i+1:end],:);
%     else
%         i = i + 1;
%     end
% end