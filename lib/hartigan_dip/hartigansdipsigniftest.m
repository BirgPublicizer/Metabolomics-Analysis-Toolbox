
function		[dip, p_value, xlow,xup]=hartigansdipsigniftest(xpdf,nboot)

%  function		[dip,p_value,xlow,xup]=hartigansdipsigniftest(xpdf,nboot)
%
% calculates Hartigan's DIP statistic and its significance for the empirical p.d.f  XPDF (vector of sample values)
% This routine calls the matlab routine 'hartigansdiptest' that actually calculates the DIP
% NBOOT is the user-supplied sample size of boot-strap
% Code by F. Mechler (27 August 2002)

% calculate the DIP statistic from the empirical pdf
[dip,xlow,xup, ifault, gcm, lcm, mn, mj]=hartigansdiptest(xpdf);
N=length(xpdf);

% calculate a bootstrap sample of size NBOOT of the dip statistic for a uniform pdf of sample size N (the same as empirical pdf)
boot_dip=hartigansdipofuniform(nboot, N);
p_value=sum(dip<boot_dip)/nboot;

% % Plot Boot-strap sample and the DIP statistic of the empirical pdf
% figure(1); clf;
% [hy,hx]=hist(boot_dip); 
% bar(hx,hy,'k'); hold on;
% plot([dip dip],[0 max(hy)*1.1],'r:');

