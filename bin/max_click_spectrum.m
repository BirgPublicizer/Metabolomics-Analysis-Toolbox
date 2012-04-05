function max_click_spectrum(h,eventdata)
s = getappdata(h,'s');
max_inx = getappdata(h,'max_inx');
handles = guidata(h);
collection = handles.collection;
bin_inx = get(handles.bins_listbox,'Value')-1;
ButtonName = questdlg('Action?', ...
                      'Spectrum peak', ...
                      'Toggle mark', 'Remove peak','Toggle mark');
switch ButtonName,
 case 'Toggle mark',
     collection.regions{s}{bin_inx}.include_mask(max_inx) = ~collection.regions{s}{bin_inx}.include_mask(max_inx);
     
     if collection.regions{s}{bin_inx}.include_mask(max_inx)
         set(h,'color','b');
         set(h,'MarkerFaceColor','b');
     else
         set(h,'color',[0.8,0.8,0.8]);
         set(h,'MarkerFaceColor',[0.8,0.8,0.8]);
     end
     
     handles.collection = collection;
     guidata(handles.figure1, handles);
 case 'Remove peak',
     collection.regions{s}{bin_inx}.include_mask = [collection.regions{s}{bin_inx}.include_mask(1:max_inx-1),...
         collection.regions{s}{bin_inx}.include_mask((max_inx+1):end)];
     collection.maxs{s} = [collection.maxs{s}(1:max_inx-1),collection.maxs{s}((max_inx+1):end)];
     collection.mins{s} = [collection.mins{s}(1:max_inx-1,:);collection.mins{s}((max_inx+1):end,:)];     
     
     delete(h);
     
     handles.collection = collection;

     plot_maxs(handles,true); % Added this so numbers stay in sync
     
     guidata(handles.figure1, handles);
end % switch