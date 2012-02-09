% Create PCA graphs and normalize them so that the scales are comparable

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
subplot1(2,2,'Gap',[0.04 0.04],'Min',[0.1 0.08],'Max',[0.99 0.99],'FontS',8,'XTickL','Margin','YTickL','Margin');
subplot1(1);
pca_scores_temp = get_pca_model(165);
eval(pca_scores_temp);
max_PC1 = max(pca_scores(:,1));
min_PC1 = min(pca_scores(:,1));
max_PC2 = max(pca_scores(:,2));
min_PC2 = min(pca_scores(:,2));
pca_scores(:,1) = 100*(pca_scores(:,1) - min_PC1)/(max_PC1-min_PC1);
pca_scores(:,2) = 100*(pca_scores(:,2) - min_PC2)/(max_PC2-min_PC2);
view_pca_scores
change_to_ellipse
fix_DAB_plot('delete_legend',true,'show_treatment_arrows',false);
set(gca,'XTickLabel',{});
xlabel('');
xlim([-10,100]);
ylim([-10,100]);

subplot1(2);
pca_scores_temp = get_pca_model(166);
eval(pca_scores_temp);
pca_scores(:,1) = -1*pca_scores(:,1);
max_PC1 = max(pca_scores(:,1));
min_PC1 = min(pca_scores(:,1));
max_PC2 = max(pca_scores(:,2));
min_PC2 = min(pca_scores(:,2));
pca_scores(:,1) = 100*(pca_scores(:,1) - min_PC1)/(max_PC1-min_PC1);
pca_scores(:,2) = 100*(pca_scores(:,2) - min_PC2)/(max_PC2-min_PC2);
view_pca_scores
change_to_ellipse
fix_DAB_plot('delete_legend',true,'show_treatment_arrows',false);
ylabel('');
set(gca,'YTickLabel',{});
set(gca,'XTickLabel',{});
xlabel('');
xlim([-10,100]);
ylim([-10,100]);

subplot1(3);
pca_scores_temp = get_pca_model(167);
eval(pca_scores_temp);
max_PC1 = max(pca_scores(:,1));
min_PC1 = min(pca_scores(:,1));
max_PC2 = max(pca_scores(:,2));
min_PC2 = min(pca_scores(:,2));
pca_scores(:,1) = 100*(pca_scores(:,1) - min_PC1)/(max_PC1-min_PC1);
pca_scores(:,2) = 100*(pca_scores(:,2) - min_PC2)/(max_PC2-min_PC2);
view_pca_scores
change_to_ellipse
fix_DAB_plot('delete_legend',true,'show_treatment_arrows',false);
xlim([-10,100]);
ylim([-10,100]);

subplot1(4);
pca_scores_temp = get_pca_model(168);
eval(pca_scores_temp);
pca_scores(:,2) = -1*pca_scores(:,2);
max_PC1 = max(pca_scores(:,1));
min_PC1 = min(pca_scores(:,1));
max_PC2 = max(pca_scores(:,2));
min_PC2 = min(pca_scores(:,2));
pca_scores(:,1) = 100*(pca_scores(:,1) - min_PC1)/(max_PC1-min_PC1);
pca_scores(:,2) = 100*(pca_scores(:,2) - min_PC2)/(max_PC2-min_PC2);
view_pca_scores
change_to_ellipse
fix_DAB_plot('delete_legend',false,'show_treatment_arrows',false);
set(gca,'YTickLabel',{});
ylabel('');
xlim([-10,100]);
ylim([-10,100]);