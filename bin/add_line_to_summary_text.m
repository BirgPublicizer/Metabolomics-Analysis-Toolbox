function add_line_to_summary_text(h,line)
current = get(h,'String');
current = {line,current{:}};
set(h,'String',current);
