function SM = generate_signal_map(x,y,num_of_points,collections,group_num,sample_num)
go = 1;
time = 1;
SI_prev = [];
spectrumTemp = [x,y];
itt = 1;
nucleus = 'h'; % prompt for later
while go == 1;
    %Determine noise from signal
    [noise_index,signal_index,xy,bins] = find_noise_efficient(spectrumTemp,num_of_points,time);
    %Groom Signal Map
    [newNI, newSI] = groomSM(noise_index,signal_index);
    %Pull remaining Noise from spectrum
    
    if isequal(SI_prev, newSI)==1
        fprintf('Signal Map has converged on %s\n', char(collections{group_num}.sample_id(sample_num)));
        [reducedNoiseIdx,expandedSignalIdx] = expandSigIDX(newNI,newSI,nucleus);
        [trashNI,expandedGroomedSignalIdx] = groomSM(reducedNoiseIdx,expandedSignalIdx);
        SM = create_SM(bins,xy,expandedGroomedSignalIdx);
        go = 0;
    else
      SI_prev = newSI;
      spectrumTemp = createNoiseSpectrum(xy,newSI,num_of_points);
      time = 2;
      clear bins newSI newNI SM noise_index signal_index xy
      itt = itt+1;
    end
end