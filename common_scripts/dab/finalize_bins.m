function bins = finalize_bins(x,composite_spectrum,bins,padding,min_dist_from_boundary,maxs_spectra)
% For smoothing the composite
options = {};
options.level = 3;
options.tptr = 'sqtwolog';
options.sorh = 'h';
options.scal = 'sln';
options.wname = 'sym7';
[y_smoothed,all_maxs,all_mins] = smooth(composite_spectrum,0,options);

nm = size(bins);
for bi = 1:nm(1)
    left_inx = bins(bi,1);
    if bi == 1
        inxs = max([(left_inx-padding),1]):left_inx;
    else
        inxs = bins(bi-1,2):bins(bi,1);        
    end
    if ~isempty(inxs)
        ix = find(all_mins(:,1) <= inxs(end),1,'last');
        if isempty(ix)
            bins(bi,1) = inxs(1);
        else
            bins(bi,1) = all_mins(ix,1);        
        end
%         [v,ix] = min(composite_spectrum(inxs));
%         bins(bi,1) = inxs(ix);
        
        % Check to see if we need to fix the boundary
        % Find distance from boundary to nearest maximum
        i = bins(bi,1);
        while i > 0
            if ~isempty(maxs_spectra{i})
                break;
            end
            i = i - 1;
        end
        dist_left = bins(bi,1) - i;
        i = bins(bi,1);
        while i < length(maxs_spectra)
            if ~isempty(maxs_spectra{i})
                break;
            end
            i = i + 1;
        end
        dist_right = i - bins(bi,1);
        dist = min([dist_right,dist_left]);
        if dist < min_dist_from_boundary
            bins(bi,1) = inxs(round(length(inxs)/2)); % Put the boundary in the middle
        end
    end
    
    right_inx = bins(bi,2);
    if bi == nm(1)
        inxs = right_inx:min([(right_inx+padding),length(composite_spectrum)]);
    else
        inxs = bins(bi,2):bins(bi+1,1);
    end
    if ~isempty(inxs)
        ix = find(all_mins(:,2) >= inxs(1),1,'first');
        try
            bins(bi,2) = all_mins(ix,2);
        catch ME
            disp('here');
        end
%         [v,ix] = min(composite_spectrum(inxs));
%         bins(bi,2) = inxs(ix);
        
        % Check to see if we need to fix the boundary
        % Find distance from boundary to nearest maximum
        i = bins(bi,2);
        while i > 0
            if ~isempty(maxs_spectra{i})
                break;
            end
            i = i - 1;
        end
        dist_left = bins(bi,2) - i;
        i = bins(bi,2);
        while i < length(maxs_spectra)
            if ~isempty(maxs_spectra{i})
                break;
            end
            i = i + 1;
        end
        dist_right = i - bins(bi,2);
        dist = min([dist_right,dist_left]);
        if dist < min_dist_from_boundary
            bins(bi,2) = inxs(round(length(inxs)/2)); % Put the boundary in the middle
        end
    end
end

% Change to chemical shift
nm = size(bins);
for i = 1:nm(1)
    bins(i,:) = x(bins(i,:));
end
% Make sure adjacent bins have identical boundaries
for b = 1:nm(1)-1
    if bins(b,2) ~= bins(b+1,1)
        new_boundary = (bins(b,2)+bins(b+1,1))/2;
        bins(b,2) = new_boundary;
        bins(b+1,1) = new_boundary;
    end
end