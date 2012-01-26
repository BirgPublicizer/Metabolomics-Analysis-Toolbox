function data = one_peak_model(BETA,x)
nRep = 4; % Number of repeating elements
M = @(j) (abs(BETA(nRep*(j-1)+1)));
G = @(j) (abs(BETA(nRep*(j-1)+2)));
sigma = @(j) (G(j)/(2*sqrt(2*log(2))));
P = @(j) (abs(BETA(nRep*(j-1)+3)));
x0 = @(j) (BETA(nRep*(j-1)+4));

data = P(1)*M(1)*G(1)^2./(4*(x-x0(1)).^2+G(1)^2) + ... % Lorentzian
       (1-P(1))*M(1)*exp(-(x-x0(1)).^2/(2*sigma(1)^2)); % Gaussian
   
if sum(isnan(data)) > 0
    data = 0*x;
end