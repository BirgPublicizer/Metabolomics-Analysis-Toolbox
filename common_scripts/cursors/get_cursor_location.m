function xloc = get_cursor_location(h)
pt = get(h,'XData');
xloc = pt(1);
