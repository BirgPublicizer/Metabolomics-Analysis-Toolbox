function click_bin_boundary(bix,h,handles) % TODO: I need to update all of the code, so handles isn't required, but for now I'm leaving it
handles = guidata(gcf);
[bins,deconvolve,names] = get_bins(handles);

ButtonName = questdlg('Include in deconvolution?', ...
                         'Deconvolution', ...
                         'Yes', 'No','No');

if strcmp(ButtonName,'Yes')
    deconvolve(bix) = true;
elseif strcmp(ButtonName,'No')
    deconvolve(bix) = false;
else
    return;
end

update_bin_list(handles,bins,deconvolve,names);

plot_maxs(handles,true);
