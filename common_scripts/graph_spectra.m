% Graph spectra
h = figure;
set(gca,'xdir','reverse')
xlabel('Chemical shift, ppm')
ylabel('Intensity')
ax = gca;
set(ax,'ButtonDownFcn','right_click_menu')