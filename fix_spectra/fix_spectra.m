% fix_spectra.m
%
% This script is intended to fix a collection of spectra by correcting the
% baseline and shift.
%
% Key press documentation:
%   r - resets the zoom
%   pageup - zooms out the x axis
%   pagedown - zoom in the x axis
%   home - zooms out the y axis
%   down - zooms in the y axis
%   up/down - cycles through the spectra
%   left/right - cycles through the regions
addpath('../common_scripts');
addpath('../common_scripts/cursors');

% Fix spectra
fix_spectra_h = figure;
fix_spectra_ax = gca;
set(fix_spectra_ax,'xdir','reverse')
xlabel('Chemical shift, ppm')
ylabel('Intensity')
set(fix_spectra_ax,'ButtonDownFcn','fix_click_menu')
set(fix_spectra_h,'KeyPressFcn','fix_key_press');