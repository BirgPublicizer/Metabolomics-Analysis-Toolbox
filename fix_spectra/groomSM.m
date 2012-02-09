function [groomed_noise_index, groomed_signal_index] = groomSM(noise_index,signal_index)

%Determine from signal index if there are any noise packets only
%representing 1, 2 or 3 contiguous packets of noise

add1SignalPacket = find(diff(signal_index)==2);
add2SignalPacket = find(diff(signal_index)==3);
add3SignalPacket = find(diff(signal_index)==4);

%Initialize variables
    singlePacketsToAdd = [];
    doublePacketsToAdd = [];
    tripPacketsToAdd = [];

    %--------------assign new packets to signal index----------------------
    %Add single packets
    singlePacketsToAdd = signal_index(add1SignalPacket)+1;
    
    %Add 2 consecutive packets
    for i = 1:length(add2SignalPacket)
        packet_to_add = signal_index(add2SignalPacket(i));
        doublePacketsToAdd((i*2)-1:i*2) = [packet_to_add+1 packet_to_add+2];
    end
    %Add three packets in a row
    for i = 1:length(add3SignalPacket)
        packet_to_add = signal_index(add3SignalPacket(i));
        tripPacketsToAdd((i*3)-2:(i*3)) = [packet_to_add+1 packet_to_add+2 packet_to_add+3];
    end
    %Add them to current packet index
    signal_index_temp = sort([singlePacketsToAdd doublePacketsToAdd tripPacketsToAdd signal_index],'ascend');

%Remove newly added signal packets from noise_index
%find packets from newly added signal packets in noise_index
packets_to_remove = abs(ismember(noise_index,signal_index_temp)-1);
noise_index_temp = noise_index(packets_to_remove==1);

%from noise_index_temp, determine if there are any signal packets
%representing only one packet width
considder_signal = find(diff(noise_index_temp)==2);
packets_to_add_to_noise = noise_index_temp(considder_signal)+1; %#ok<FNDSB>
noise_index_temp = sort([noise_index_temp packets_to_add_to_noise],'ascend');

%remove newly added noise packets from signal_index
packets_remaining_in_signal = abs(ismember(signal_index_temp,packets_to_add_to_noise)-1);
signal_index = signal_index_temp(packets_remaining_in_signal==1);

groomed_noise_index = noise_index_temp;
groomed_signal_index = signal_index;