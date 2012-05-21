
%create some obviously unimodal and bimodal Gaussian distributions just to
%see what dip statistic does
% Nic Price 2006
%
% Only the first distribution is unimodal. The rest are mixtures of
% two Gaussians with different centers. The mean of the second
% distribution increases by 1 with each subplot. Since these are standard
% normals, that is, by 1 standard deviation.

Cent1 = ones(1,9); % Centers for the first distribution
Cent2 = 1:1:9;     % Centers for the second distribution - increases by one for every subplot
sig = 0.5;   % Not used
nboot = 500; %Size of the bootstrap sample used in calculating the p values

tic
for a = 1:length(Cent1),
    xpdf(a,:) = sort([Cent1(a)+randn(1,200) Cent2(a)+randn(1,200)]); %allocate 200 points from each of two unit Normals
    [dip(a), p(a)] = hartigansdipsigniftest(xpdf(a,:), nboot); % Perform the dip test
    
    subplot(3,3,a) %Plot histogram of the current sample
    hist(xpdf(a,:),-2:0.25:12)    
    title(['dip=',num2str(dip(a),3), ', p=',num2str(p(a),3)]) %Draw the title indicating the p-value and dip statistic value
    xlim([-2 12])
end
% FixAxis([-2 12]);
toc