function data = global_model(BETA,x,num_maxima,baseline_options)
global peak_data_store % Contains precomputed data

% baseline_options: x_all,x_baseline_BETA,baseline_BETA,use_inxs,interp_inxs,fit_inxs
% use_inxs - inxs of the baseline_BETA to use in the interpolation
% interp_inxs - inxs of the x data to interpolate to (i.e., xi)
% fit_inxs - those baseline_BETA values that should be updated
% nRep = 4; % Number of repeating elements

if num_maxima >= 1
    M = BETA(1:4:4*num_maxima);%@(j) (abs(BETA(nRep*(j-1)+1)));
    G = BETA(2:4:4*num_maxima);%@(j) (abs(BETA(nRep*(j-1)+2)));
    sigma = G/(2*sqrt(2*log(2)));%@(j) (G(j)/(2*sqrt(2*log(2))));
    P = BETA(3:4:4*num_maxima);%@(j) (abs(BETA(nRep*(j-1)+3)));
    x0 = BETA(4:4:4*num_maxima);%@(j) (BETA(nRep*(j-1)+4));
    if isnan(M(1)) % Precomputed
        inx = G(1);
        if length(x) == length(peak_data_store.peaks{inx}.y)
            data = peak_data_store.peaks{inx}.y;
        else
            M(1) = peak_data_store.peaks{inx}.MGPX(1);
            G(1) = peak_data_store.peaks{inx}.MGPX(2);
            sigma(1) = G(1)/(2*sqrt(2*log(2)));
            P(1) = peak_data_store.peaks{inx}.MGPX(3);
            x0(1) = peak_data_store.peaks{inx}.MGPX(4);
            data = one_peak_model([M(1),G(1),P(1),x0(1)],x);
        end
    elseif ~isnan(M(1)) && G(1) > 0
        data = one_peak_model([M(1),G(1),P(1),x0(1)],x);
    else
        data = zeros(size(x));
    end
    
    for i = 2:num_maxima
        if isnan(M(i))
            inx = G(i);
            if length(x) == length(peak_data_store.peaks{inx}.y)
                data = data + peak_data_store.peaks{inx}.y;
            else
                M(i) = peak_data_store.peaks{inx}.MGPX(1);
                G(i) = peak_data_store.peaks{inx}.MGPX(2);
                sigma(i) = G(i)/(2*sqrt(2*log(2)));
                P(i) = peak_data_store.peaks{inx}.MGPX(3);
                x0(i) = peak_data_store.peaks{inx}.MGPX(4);
                data = data + one_peak_model([M(i),G(i),P(i),x0(i)],x);
            end
        elseif ~isnan(M(i)) && G(i) > 0
            data = data + one_peak_model([M(i),G(i),P(i),x0(i)],x);
        end
    end
else
    data = zeros(size(x));
end
last_inx = 4*num_maxima;
remainder = BETA(last_inx+1:end);
baseline_BETA = remainder;

if sum(abs(baseline_BETA)) == 0 % Nothing to be done, so return
    return;
end

% Required options
x_baseline_BETA = baseline_options.x_baseline_BETA;
x_all = baseline_options.x_all;

use_inxs = 1:length(baseline_BETA); % By default use them all
if isfield(baseline_options,'use_inxs')
    use_inxs = baseline_options.use_inxs;
end

interp_inxs = 1:length(x_all); % By default interpolate to all of the x-values
if isfield(baseline_options,'interp_inxs')
    interp_inxs = baseline_options.interp_inxs;
end

window_inxs = 1:length(x_all);
if isfield(baseline_options,'window_inxs')
    window_inxs = baseline_options.window_inxs;
end

% Only if there are at least two
if length(use_inxs) >= 2
    baseline = baseline_piecewise_interp(baseline_BETA,x_baseline_BETA,use_inxs,interp_inxs,x_all);
    data = data + baseline(window_inxs);
end