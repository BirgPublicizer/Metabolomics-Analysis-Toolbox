function bins = optimize_bins(grouped_maxs,max_distance,maxs_spectra,nSpectra)
align_scores = Inf*ones(1,rows(grouped_maxs)+1);
align_tscores = Inf*ones(1,rows(grouped_maxs)+1);
align_num_bins = NaN*ones(1,rows(grouped_maxs)+1);
align_directions = NaN*ones(1,rows(grouped_maxs)+1); % i(col inx):two or more peaks, -1:own bin

% Fill out the first entry
align_scores(1) = 0; %score(answer_peaks{1},calc_peaks{1});
align_tscores(1) = 0; %score(answer_peaks{1},calc_peaks{1});
align_num_bins(1) = 0;
align_directions(1) = NaN;

% Fill in the rest
for j = 2:rows(grouped_maxs)+1
    % Always have a score for being in its own bin
    [score,tscore] = bin_score(grouped_maxs(j-1,1),grouped_maxs(j-1,2),maxs_spectra,nSpectra);
    ind_score = align_scores(j-1) + score;
    ind_num_bins = align_num_bins(j-1) + 1;
    ind_tscore = align_tscores(j-1) + tscore;
    
    min_match_score = Inf;
    min_match_j = 0;
    max_match_tscore = -Inf;
    max_match_num_bins = NaN;
    for match_j = (j-1):-1:2
        % Could also include a cutoff on the number of maximum because the
        % score would not increase...
        if abs(grouped_maxs(j-1,2) - grouped_maxs(match_j-1,1)) <= max_distance
            [score,tscore] = bin_score(grouped_maxs(match_j-1,1),grouped_maxs(j-1,2),maxs_spectra,nSpectra);
            match_score = align_scores(match_j-1) + score;
            match_num_bins = align_scores(match_j-1) + 1;
            match_tscore = align_tscores(match_j-1) + tscore;
            if match_score < min_match_score
                min_match_j = match_j;
                min_match_score = match_score;
                max_match_tscore = match_tscore;
                max_match_num_bins = match_num_bins;
            elseif match_score == min_match_score && match_num_bins > max_match_num_bins
                min_match_j = match_j;
                min_match_score = match_score;
                max_match_tscore = match_tscore;
                max_match_num_bins = match_num_bins;
            elseif match_score == min_match_score && match_num_bins == max_match_num_bins && ...
                    match_tscore/match_num_bins > max_match_tscore/max_match_num_bins
                min_match_j = match_j;
                min_match_score = match_score;
                max_match_tscore = match_tscore;
                max_match_num_bins = match_num_bins;                
            end
        else
            break;
        end
    end
    if min_match_score < ind_score
        align_scores(j) = min_match_score;
        align_tscores(j) = max_match_tscore;
        align_num_bins(j) = max_match_num_bins;
        align_directions(j) = min_match_j;        
    elseif min_match_score == ind_score && max_match_num_bins > ind_num_bins
        align_scores(j) = min_match_score;
        align_tscores(j) = max_match_tscore;
        align_num_bins(j) = max_match_num_bins;
        align_directions(j) = min_match_j;
    elseif min_match_score == ind_score && max_match_num_bins == ind_num_bins && ...
            max_match_tscore/max_match_num_bins > ind_tscore/ind_num_bins
        align_scores(j) = min_match_score;
        align_tscores(j) = max_match_tscore;
        align_num_bins(j) = max_match_num_bins;
        align_directions(j) = min_match_j;
    else
        align_scores(j) = ind_score;
        align_tscores(j) = ind_tscore;
        align_num_bins(j) = ind_num_bins;
        align_directions(j) = -1;
    end
end

temp_bins = create_temp_bins(grouped_maxs,align_directions);

bins = [];
for i = length(temp_bins):-1:1
    if temp_bins(i,1) ~= 0 && temp_bins(i,2) ~= 0
        bins(end+1,:) = [0,0];
        if temp_bins(i,1) ~= 1
            bins(end,1) = grouped_maxs(temp_bins(i,1),1)+1;
        else
            bins(end,1) = grouped_maxs(temp_bins(i,1),1);
        end
        bins(end,2) = grouped_maxs(temp_bins(i,2),2);
    elseif temp_bins(i,1) == 0 && temp_bins(i,2) ~= 0
        bins(end+1,1) = grouped_maxs(temp_bins(i,2),1);
        bins(end,2) = grouped_maxs(temp_bins(i,2),2);
    elseif temp_bins(i,1) ~= 0 && temp_bins(i,2) == 0
        bins(end+1,1) = grouped_maxs(temp_bins(i,1),1);
        bins(end,2) = grouped_maxs(temp_bins(i,1),2);
    end
end

function [sc,tsc] = bin_score(left_inx,right_inx,maxs_spectra,nSpectra)
norm_num_maxs_in_bin = zeros(1,nSpectra);

% Find the distance between the maxs spanning the left bin boundary
dist_to_prev_max = NaN;

for i = left_inx:right_inx
    norm_num_maxs_in_bin(maxs_spectra{i}) = norm_num_maxs_in_bin(maxs_spectra{i}) + 1;
    for j = 1:length(maxs_spectra{i})
        if isnan(dist_to_prev_max)
            for k = i-1:-1:1
                if ~isempty(maxs_spectra{k})
                    dist_to_prev_max = i - k;
                    break;
                end
            end
        end
    end
end
tsc = dist_to_prev_max;
norm_num_maxs_in_bin = abs(1 - norm_num_maxs_in_bin);

sc = sum(norm_num_maxs_in_bin);

function n = rows(mt)
nm = size(mt);
n = nm(1);