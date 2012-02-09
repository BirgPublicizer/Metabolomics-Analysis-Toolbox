%% Update scores plot
contents = get(handles.model_by_listbox,'String');
groups = {contents{get(handles.model_by_listbox,'Value')}};
axes(handles.scores_axes);
load('colors');
markers = {'o','s','d','v','^','<','>'};
hold on
for g = 1:length(groups)
    inxs = find(handles.Y == g);
    plot(handles.model.score(inxs,x_pc_inx),handles.model.score(inxs,y_pc_inx),...
        'Marker',markers{mod(g-1,length(markers))+1},'Color',...
        colors{mod(g-1,length(colors))+1},'LineStyle','none',...
        'MarkerFaceColor',colors{mod(g-1,length(colors))+1});
end
hold off
legend(groups,'Location','Best');
xlabel(['PC_',num2str(x_pc_inx)],'Interpreter','tex');
ylabel(['PC_',num2str(y_pc_inx)],'Interpreter','tex');