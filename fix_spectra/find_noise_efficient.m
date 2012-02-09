function [noise_index,signal_index,xy,bins] = find_noise_efficient(data,num_of_points, time)
%%||||||||||||||||||||find_noise|||||||||||||||||||%%
%By: Daniel C. Homer
%WSU NMR lab 03/07
%     This function determines a signal threshold based on Kurtosis
%     critical value and packet sigma

%Inputs:  
% data = XY NMR spectrum to be processed set up in columns
% num_of_points = number of points per packet to use in analysis
% time = Loop counter for threshold determination      

%Outputs:  
% noise_index = sorted packet numbers containing noise (vector)
% signal_index = sorted packet numbers containing signal (vector)

%disp('Start Find_Noise')

%Read in information
xy.freq = data(:,1); xy.amp = data(:,2);

%Create list of index positions for binning
%disp('Creating list of index positions for binning')

[bins,num_of_bins] = findBinLimits(num_of_points,xy);
regional_std = zeros(1,num_of_bins);
%find standard deviation of each bin
%disp('Finding standard deviation values')
for i = 1:num_of_bins
     regional_std(i) = std(xy.amp(bins.start(i):bins.end(i)));
end

%disp('Sorting bins based on Standard deviation')

%find minumum standard deviation values and index in amplitude 
[R,I]=sort(regional_std,'ascend');
sig.start = bins.start(I); sig.fin = bins.end(I);

%Calculate fit to Gaussian population
%initialize all variables
noiseamp = [];
kurt_stock = ones(1,length(sig.start));
sigma = ones(1,length(sig.start));

% build NoiseAmp with whole spectrum included (packet mean corrected) and
% calculate kurtosis for each packet removal until you reack the critical
% value (0)
%increase_threshold_index = 0;
for i = 1:length(sig.start)
    %generate mean corrected signal amplitudes
    if sum(xy.amp(sig.start(i):sig.fin(i))) ~= 0
        addpacket = xy.amp(sig.start(i):sig.fin(i))-mean(xy.amp(sig.start(i):sig.fin(i)));
        noiseamp = [noiseamp ; addpacket];
        addpacket=[];
    end
end
%disp('Generating Kurtosis Values')
threshold=[];
for j = 1:length(sig.start)
    kurt_stock(j)=kurtosis(noiseamp(1:length(noiseamp)-((j-1)*num_of_points)))-3;
    if kurt_stock(j)<=0
        %determine threshold packet
        if time == 1
            %threshold set as 6*sigma of noiseamp on original packet sigma
            %values
            identified_noise_sigma = std(noiseamp(1:length(noiseamp)-((j-1)*num_of_points)));
            [trash,threshold] = min(abs(R-identified_noise_sigma*6));
            if isempty(threshold)==1
                error('Threshold is unidentified on iteration %i', time)
            end
            break
        end
        if time == 2
            %Threshold set as critical value of kurtosis (0)
            threshold = length(sig.start)-j;
            if isempty(threshold)==1
                error('Threshold is unidentified at or beyond the %i nd iteration', time)
            end
            break
        end
    end
end

noise_index = sort(I(1:threshold),'ascend');
signal_index = sort(I(threshold+1:length(I)),'ascend');
