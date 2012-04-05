load 'example.mat';
bins = dynamic_adaptive_bin(x,Y,9.5,9.45,0.08,0.001);
[num_variables, num_samples] = size(Y);
[nBins,cols] = size(bins);
% Bin the data
Ybinned = zeros(nBins,num_samples);
for b = 1:nBins
    inxs = find(bins(b,1) >= x & x >= bins(b,2));
    for s = 1:num_samples
        Ybinned(b,s) = sum(Y(inxs,s));
    end
end

figure;
hold on
for i = 1:num_samples
 plot(x,Y(:,i));
end
hold off
set(gca,'xdir','reverse');
xlabel('Chemical shift, ppm');
for i = 1:nBins
 line([bins(i,1),bins(i,1)],ylim,'Color','g');
 line([bins(i,2),bins(i,2)],ylim,'Color','r');
end
