function data = baseline_piecewise_interp(baseline_BETA,x_baseline_BETA,xi)
if ~isempty(baseline_BETA)
    data = interp1(x_baseline_BETA,baseline_BETA,xi,'cubic',0);

%     % Whittacker smoother algorithm
%     % Weights (0 = ignore this intensity)
%     xwidth = abs(xi(1)-xi(2));
%     lambda = 20;
%     y = NaN*ones(size(xi));
%     w = zeros(size(xi));
%     for i = 1:length(x_baseline_BETA)
%         inx = round((xi(1) -  x_baseline_BETA(i))/xwidth) + 1;
%         w(inx) = 1;
%         y(inx) = baseline_BETA(i);
%     end
%     % Matrix version of W
%     W = sparse(length(xi),length(xi));
%     for i = 1:length(w)
%         W(i,i) = w(i);
%     end
%     % Difference matrix (they call it derivative matrix, which a little
%     % misleading)
%     D = sparse(length(xi),length(xi));
%     for i = 1:length(xi)-1
%         D(i,i) = 1;
%         D(i,i+1) = -1;
%     end
% 
%     A = W + lambda*D'*D;
%     b = W*y;
% 
%     data = A\b; % Compute the baseline

%     xwidth = xi(2)-xi(1);
%     x = xi(1):xwidth:xi(end);
%     x = x';
%     y = 0*x;
%     inxs = round((x_baseline_BETA - xi(1))/xwidth) + 1;
%     y(inxs) = baseline_BETA;
% 
%     % Weights (0 = ignore this intensity)
%     w = 0*y;
%     w(inxs) = 1;
% 
%     % Matrix version of W
%     W = sparse(length(y),length(y));
%     for i = 1:length(w)
%         W(i,i) = w(i);
%     end
%     % Difference matrix (they call it derivative matrix, which a little
%     % misleading)
%     D = sparse(length(y),length(y));
%     for i = 1:length(y)-1
%         D(i,i) = 1;
%         D(i,i+1) = -1;
%     end
% 
%     lambda = 20;
%     A = W + lambda*D'*D;
%     b = W*y;
% 
%     data = A\b; % Compute the baseline
% 
%     inxs = round((xi - xi(1))/xwidth) + 1;
%     data = data(inxs);
else
    data = 0*xi;
end
