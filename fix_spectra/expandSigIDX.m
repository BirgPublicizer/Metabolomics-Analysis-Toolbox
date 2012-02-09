function [expandedNoiseIdx,expandedSignalIdx] = expandSigIDX(noiseIDX,signalIDX,nucleus)
%set nucleus parameters
if strcmpi('h',nucleus) == 1;
    %expand 1H SM by 5 packets
    increase_SM_bounds = 5;
elseif strcmpi('c',nucleus) == 1;
    %expand 13C SM by 10 packets
    increase_SM_bounds = 10;
else
    display('Not a correct entry')
end

packetsToAdd = [];
totalPackets = numel(noiseIDX)+numel(signalIDX);
for i = 1:length(signalIDX)
    if signalIDX(i) < (increase_SM_bounds-1)
        packetsToAdd = [packetsToAdd 1:signalIDX(i)+increase_SM_bounds];
    elseif signalIDX(i) > increase_SM_bounds && signalIDX(i) < (totalPackets-increase_SM_bounds)
            packetsToAdd = [packetsToAdd signalIDX(i)-increase_SM_bounds:signalIDX(i)+increase_SM_bounds];
    elseif signalIDX(i) > totalPackets-increase_SM_bounds
                packetsToAdd = [packetsToAdd signalIDX(i)-increase_SM_bounds:totalPackets];
    end
end
expandedSignalIdx = union(signalIDX,abs(packetsToAdd));%Unique set of signal IDX sorted
expandedNoiseIdx = setxor(1:length(noiseIDX)+length(signalIDX),expandedSignalIdx);
clear packetsToAdd