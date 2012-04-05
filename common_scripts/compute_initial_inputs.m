function [BETA0,lb,ub] = compute_initial_inputs(x,y,peak_x,fit_inxs,X)
%Computes starting values for the deconvolution fitting routines
%
% These documentation comments are being put-in after the fact for code
% written by Paul Anderson.
%
% -------------------------------------------------------------------------
% Input arguments
% -------------------------------------------------------------------------
%
% x        The x values of the spectrum being fit
%
% y        The corresponding y values
%
% peak_x   The x values of the peaks
%
% fit_inxs Not sure what this does: set it to 1:length(x)
%
% X        Not sure: The subset of the peak x values that we want to fit
%
%
% -------------------------------------------------------------------------
% Output parameters
% -------------------------------------------------------------------------
%
% BETA0              A 1 dimensional array of doubles.
%
%                    Every 4 items are the starting parameters for one peak
%                    in the order M, G, P, x0.
%
%                    M  is the height parameter
%                    G  is the width parameter,
%                    P  is the proportion of Lorenzianness (1=lorenzian,
%                       0=gaussian)
%                    x0 is the location parameter, the location of the 
%                       peak.
%
% lb                 The lower bound on the corresponding entry in BETA0
%                    -- used in constraining the optimization
%
% ub                 The upper bound on the corresponding entry in BETA0
%                    -- used in constraining the optimization
%

min_M = 0.00001;
min_G = 0.00001;
% Compute the initial values for the width/height and offset
BETA0 = [];
lb = [];
ub = [];
% For each peak ppm (or whatever unit) location, put the index of the 
% value closest to it in the x array into the cooresponding slot in
% max_inxs
max_inxs = zeros(size(peak_x));
for mx_inx = 1:length(max_inxs)
    diff = abs(x - peak_x(mx_inx));
    [unused,inxs] = sort(diff); %#ok<ASGLU>
    max_inxs(mx_inx) = inxs(1);
end
for mx_inx = 1:length(X)
    % Inx is the index of the peak at the current x location 
    inx = find(peak_x == X(mx_inx));
    
    % Left
    if inx-1 >= 1
        temp_inxs = max_inxs(inx-1):max_inxs(inx)-1;
    else
        %The peak is the first peak
        temp_inxs = fit_inxs(1):max_inxs(inx)-1;
    end
    if isempty(temp_inxs) 
        temp_inxs = max_inxs(inx);
    end
    [unused,ix]=min(y(temp_inxs)); %#ok<ASGLU>
    left_inx = temp_inxs(ix);
    ub_x0 = x(left_inx);
    
    % Right
    if inx+1 <= length(peak_x)
        temp_inxs = max_inxs(inx)+1:max_inxs(inx+1);
    else
        temp_inxs = max_inxs(inx)+1:fit_inxs(end);
    end
    if isempty(temp_inxs)
        temp_inxs = max_inxs(inx);
    end
    [unused,ix]=min(y(temp_inxs)); %#ok<ASGLU>
    right_inx = temp_inxs(ix);
    lb_x0 = x(right_inx);
    
    g_M = calc_height(left_inx:right_inx,y);
    g_G = calc_width(left_inx:right_inx,x,y);
    % Peaks are not wider than they are tall (initially)
    if g_G > g_M
        g_G = g_M;
    end
    g_P = 0.5;
    if lb_x0 == ub_x0
        width = abs(x(1)-x(2));
        lb_x0 = lb_x0 - width/2;
        ub_x0 = ub_x0 + width/2;
    end
    BETA0 = [BETA0;max([g_M,min_M]);max([g_G,min_G]);g_P;X(mx_inx)];
    lb = [lb;0;0;0;lb_x0];
    ub = [ub;max(y(fit_inxs));...
        2*abs(x(fit_inxs(1))-x(fit_inxs(end)));1;ub_x0];
end