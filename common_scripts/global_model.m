function [data,y_baseline] = global_model(BETA,x,num_maxima,x_baseline_BETA)
nRep = 4; % Number of repeating elements
M = @(j) (abs(BETA(nRep*(j-1)+1)));
G = @(j) (abs(BETA(nRep*(j-1)+2)));
sigma = @(j) (G(j)/(2*sqrt(2*log(2))));
P = @(j) (abs(BETA(nRep*(j-1)+3)));
x0 = @(j) (BETA(nRep*(j-1)+4));
% VW = @(j) (G(j)*exp(-P(j)*(x-x0(j)).*sign(x)));

if num_maxima >= 1
    data = P(1)*M(1)*G(1)^2./(4*(x-x0(1)).^2+G(1)^2) + ... % Lorentzian
           (1-P(1))*M(1)*exp(-(x-x0(1)).^2/(2*sigma(1)^2)); % Gaussian
    for i = 2:num_maxima
        data = data + P(i)*M(i)*G(i)^2./(4*(x-x0(i)).^2+G(i)^2) + ... % Lorentzian
           (1-P(i))*M(i)*exp(-(x-x0(i)).^2/(2*sigma(i)^2)); % Gaussian
    end    
%     data = M(1)*VW(1).^2./(4*(x-x0(1)).^2+VW(1).^2); % Lorentzian           
%     for i = 2:num_maxima
%         data = data + M(i)*VW(i).^2./(4*(x-x0(i)).^2+VW(i).^2);
%     end
else
    data = zeros(size(x));
end
last_inx = nRep*num_maxima;
remainder = BETA(last_inx+1:end);
y_baseline = baseline_piecewise_interp(remainder,x_baseline_BETA,x);
data = data + y_baseline;