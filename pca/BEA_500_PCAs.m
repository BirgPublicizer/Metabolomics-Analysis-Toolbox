function BEA_500_PCAs
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
subplot1(3,1,'Gap',[0.04 0.04],'Min',[0.1 0.08],'Max',[0.99 0.99],'FontS',8,'XTickL','Margin','YTickL','Margin');
subplot1(1);
pca_scores_temp = get_pca_model(161);
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_bea_plot('delete_legend',true,'show_treatment_arrows',true);

subplot1(2);
pca_scores_temp = get_pca_model(162);
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_bea_plot('delete_legend',true,'show_treatment_arrows',true);

subplot1(3);
pca_scores_temp = get_pca_model(163);
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_bea_plot('delete_legend',false,'show_treatment_arrows',true);

labels = {'A. 500 mg/kg','B. 150 mg/kg','C. 50 mg/kg'};
for i = 1:3
    subplot1(i);
    if i == 1 || i == 2
        set(gca,'XTickLabel',{});
        xlabel('');
    end
    text(600,140,labels{i});
    axis normal
    xlim([-80,700]);
    ylim([-20,150]);
end

% Now without any scaling
defaultpos = get(0,'DefaultFigurePaperPosition');
figure('Position',defaultpos);

no_new_figure = true;
subplot1(3,1,'Gap',[0.04 0.04],'Min',[0.1 0.08],'Max',[0.99 0.99],'FontS',8,'XTickL','Margin','YTickL','Margin');
subplot1(1);
pca_scores_temp = get_pca_model(161);
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_bea_plot('delete_legend',true,'show_treatment_arrows',true);
axis normal

subplot1(2);
pca_scores_temp = get_pca_model(162);
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_bea_plot('delete_legend',true,'show_treatment_arrows',true);
axis normal

subplot1(3);
pca_scores_temp = get_pca_model(163);
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_bea_plot('delete_legend',false,'show_treatment_arrows',true);
axis normal