function	[dips] = hartigansdipofuniform(ndips, nsamples)
% Takes nsamples samples from a uniform distribution ndips times and
% returns a vector of hartigan's dip statistic on each.
%
% usage: dips = hartigansdipofuniform(ndips, nsamples)
%
% ndips    - the number of dip statistic calculations to do
%
% nsamples - the number of samples used in each dip statistic
%            calculation
%
% dips     - a column vector of ndips values, each the dip statistic
%            calculated on one sample of size nsamples drawn from the
%            uniform 0,1 distribution
%
% Note: you can get the p value of a dip test by executing
%
% nbootstrap = 1000; % Increase this to increase accuracy of p values
% boot_dip = hartigansdipofuniform(nbootstrap, length(xpdf));
% dip = hartigansdiptest(xpdf);
% p_value=sum(dip<boot_dip)/nbootstrap;
%
% Modified: Eric Moyer (May 2012) eric_moyer (a) yahoo.com

dips=zeros(ndips,1);
for i=1:ndips
   unifpdfboot=sort(unifrnd(0,1,1,nsamples));
   dips(i)=hartigansdiptest(unifpdfboot);
end


