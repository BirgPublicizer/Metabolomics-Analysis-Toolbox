addpath('../common_scripts');

% Figure properties
set(0,'DefaultAxesFontName','arial');
set(0,'DefaultTextFontName','arial');
set(0,'DefaultTextFontSize',8);
set(0,'DefaultAxesFontSize',8);
set(0,'DefaultFigurePaperPositionMode', 'manual');
set(0,'DefaultFigurePaperUnits', 'inches');
set(0,'DefaultFigurePaperPosition', [2,1,6,6.5]);
set(0,'DefaultFigureUnits','inches');

defaultpos = get(0,'DefaultFigurePaperPosition');
figure('Position',defaultpos);

no_new_figure = true;
subplot1(3,2,'Gap',[0.04 0.04],'Min',[0.1 0.08],'Max',[0.99 0.99],'FontS',8,'XTickL','Margin','YTickL','Margin');
subplot1(1);
pca_scores_temp = get_pca_model(180); % 500
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_bea_plot('delete_legend',true,'show_treatment_arrows',true);

subplot1(2);
pca_scores_temp = get_pca_model(181); % 200
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_bea_plot('delete_legend',true,'show_treatment_arrows',true);

subplot1(3);
pca_scores_temp = get_pca_model(182); % 100
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_bea_plot('delete_legend',true,'show_treatment_arrows',true);

subplot1(4);
pca_scores_temp = get_pca_model(183); % 50
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_bea_plot('delete_legend',true,'show_treatment_arrows',false);

subplot1(5);
pca_scores_temp = get_pca_model(184); % 20
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_bea_plot('delete_legend',true,'show_treatment_arrows',false);

subplot1(6);
pca_scores_temp = get_pca_model(185); % 5
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_bea_plot('delete_legend',false,'show_treatment_arrows',false);

labels = {'A. 500 mg/kg','B. 200 mg/kg','C. 100 mg/kg','D. 50 mg/kg','E. 20 mg/kg','F. 5 mg/kg'};
hs = [];
for i = 1:6
    subplot1(i);
    if i <= 4
        set(gca,'XTickLabel',{});
        xlabel('');
    end
    if i == 2 || i == 4 || i == 6
        set(gca,'YTickLabel',{});
        ylabel('');
    end
    hs(end+1) = text(-35,-25,labels{i});
    axis normal
    xlim([-40,120]);
    ylim([-30,20]);
end
% delete(hs); hs = [];