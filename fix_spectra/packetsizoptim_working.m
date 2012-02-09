%Packet size optimization
%Look at ratios of maximum and minimum SD for packets of certain length
%(ranging 4 to 128 points per packet)
%within an NMR spectrum (H1 and C13) based on standard bin size (128 points equivalent to 0.04 PPM) as a
%maximum for packet size.

function [loc,packetSize,SDmax,SDmin] = packetsizoptim_working(varargin)
psize = 5:30;%packet size window
SDmax = zeros(length(varargin),length(psize));
SDmin = zeros(length(varargin),length(psize));
loc = zeros(length(varargin),length(psize));
for m = 1:length(varargin);
    [max_amp,Ind] = max(varargin{m}(:,2));
    % set window around maximum apmlitude
    %This could also easily be done by finding the smallest width with the
    %greatest delta value...  It is important to exlude standard and
    %solvent peaks
    data = varargin{m}(Ind-round(0.01*length(varargin{m}(:,2))):Ind+round(0.01*length(varargin{m}(:,2))),2);
    for j = 1:length(psize)
        dev = zeros(1,length(data)-(psize(j)-1));
        for i = 1:length(data)-(psize(j)-1);
            dev(i) = std(data(i:i+(psize(j)-1)));
        end
        [SDmax(m,j),loc(m,j)] = max(dev);
        loc(m,j) = loc(m,j)+ Ind-round(0.01*length(varargin{m}(:,2)));
        SDmin(m,j) = min(dev);
        clear dev
    end
end
[val,pos] = max(SDmax,[],2);
packetSize = psize(pos);

for l = 1:length(varargin)
    plotspectrum('h',varargin{l},varargin{l}(loc(l,packetSize(l)-4):loc(l,packetSize(l)-4)+packetSize(l)-1,:))
end

hold off
figure;
plot(psize,SDmax)
title('SD_M_A_X with Increasing packet Width')
ylabel('SD_M_A_X')
xlabel('Packet Width (Points)')
hold on
plot(packetSize,val,'kx','MarkerSize',15)