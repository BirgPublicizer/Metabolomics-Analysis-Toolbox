function data = baseline_piecewise_interp(intensities,x_intensities,use_inxs,interp_inxs,x_all)
if ~isempty(intensities) && sum(abs(intensities)) > 0
    data = zeros(size(x_all)); % Anything before x_all(interp_inxs) is zero
    data(interp_inxs) = interp1(x_intensities(use_inxs),intensities(use_inxs),x_all(interp_inxs),'linear','extrap');

%     lambda = 200;
% %     x = x_intensities;
%     y = zeros(size(x_all));
%     xwidth = x_all(1)-x_all(2);
%     inxs = round((x_all(1) - x_intensities(use_inxs))/xwidth) + 1;
%     y(inxs) = intensities(use_inxs);
%     
%     % Weights (0 = ignore this intensity)
%     w = zeros(size(y));
%     w(inxs) = 1;
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
%     A = W + lambda*D'*D;
%     b = W*y;
% 
%     data = A\b; % Compute the baseline
% 
%     data(interp_inxs(end):end) = data(interp_inxs(end)); % Anything after x_all(interp_inxs) is data(interp_inxs(end))
else
    data = zeros(size(x_all));
end