function ANIT_100_PCAs
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

find_labels = {'4,100 mg/kg (1)','4,50 mg/kg (1)','4,20 mg/kg (1)','4,10 mg/kg (1)','4,1 mg/kg (1)','4,0.1 mg/kg (1)','4,Control (1)'};
labels = {'100','50','20','10','1','0.1','0'};
doses = [100,50,20,10,1,0.1,0];
PC1_values = [];

no_new_figure = true;
subplot1(3,2,'Gap',[0.04 0.04],'Min',[0.1 0.08],'Max',[0.99 0.99],'FontS',8);
subplot1(1);
pca_scores_100 = get_pca_model(121);
eval(pca_scores_100);
view_pca_scores
change_to_ellipse
fix_anit_plot('delete_legend',true,'show_treatment_arrows',true);
% PC1 scores
inxs = [];
j = 1;
for i = 1:length({metadata{:,1}})
    if strcmp(metadata{i,1},find_labels{j})
        inxs(end+1) = i;
    end
end
if ~isempty(inxs)
    PC1_values(end+1) = mean(pca_scores(inxs,1));
end

subplot1(2);
pca_scores_50 = get_pca_model(122);
eval(pca_scores_50);
view_pca_scores
change_to_ellipse
fix_anit_plot('delete_legend',true,'show_treatment_arrows',true);
% PC1 scores
inxs = [];
j = 2;
for i = 1:length({metadata{:,1}})
    if strcmp(metadata{i,1},find_labels{j})
        inxs(end+1) = i;
    end
end
if ~isempty(inxs)
    PC1_values(end+1) = mean(pca_scores(inxs,1));
end

subplot1(3);
pca_scores_temp = get_pca_model(123);
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_anit_plot('delete_legend',true,'show_treatment_arrows',true);
% PC1 scores
inxs = [];
j = 3;
for i = 1:length({metadata{:,1}})
    if strcmp(metadata{i,1},find_labels{j})
        inxs(end+1) = i;
    end
end
if ~isempty(inxs)
    PC1_values(end+1) = mean(pca_scores(inxs,1));
end

subplot1(4);
pca_scores_temp = get_pca_model(124);
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_anit_plot('delete_legend',true,'show_treatment_arrows',false);
% PC1 scores
inxs = [];
j = 4;
for i = 1:length({metadata{:,1}})
    if strcmp(metadata{i,1},find_labels{j})
        inxs(end+1) = i;
    end
end
if ~isempty(inxs)
    PC1_values(end+1) = mean(pca_scores(inxs,1));
end

subplot1(5);
pca_scores_temp = get_pca_model(125);
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_anit_plot('delete_legend',false,'show_treatment_arrows',false);
% PC1 scores
inxs = [];
j = 5;
for i = 1:length({metadata{:,1}})
    if strcmp(metadata{i,1},find_labels{j})
        inxs(end+1) = i;
    end
end
if ~isempty(inxs)
    PC1_values(end+1) = mean(pca_scores(inxs,1));
end

subplot1(6);
pca_scores_temp = get_pca_model(126);
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_anit_plot('delete_legend',true,'show_treatment_arrows',false);
% PC1 scores
inxs = [];
j = 6;
for i = 1:length({metadata{:,1}})
    if strcmp(metadata{i,1},find_labels{j})
        inxs(end+1) = i;
    end
end
if ~isempty(inxs)
    PC1_values(end+1) = mean(pca_scores(inxs,1));
end
% PC1 scores
inxs = [];
j = 7;
for i = 1:length({metadata{:,1}})
    if strcmp(metadata{i,1},find_labels{j})
        inxs(end+1) = i;
    end
end
if ~isempty(inxs)
    PC1_values(end+1) = mean(pca_scores(inxs,1));
end

labels = {'A. 100 mg/kg','B. 50 mg/kg','C. 20 mg/kg','D. 10 mg/kg','E. 1 mg/kg','F. 0.1 mg/kg'};
for i = 1:6
    subplot1(i);
    if i == 2 || i == 4 || i == 6
        set(gca,'YTickLabel',{});
        ylabel('');
    end
    if i == 1 || i == 2 || i == 3 || i == 4
        set(gca,'XTickLabel',{});
        xlabel('');
    end
    text(-30,-30,labels{i});
    axis normal
    xlim([-35,20]);
    ylim([-35,20]);
end

% Figure properties
set(0,'DefaultAxesFontName','arial');
set(0,'DefaultTextFontName','arial');
set(0,'DefaultTextFontSize',8);
set(0,'DefaultAxesFontSize',8);
set(0,'DefaultFigurePaperPositionMode', 'manual');
set(0,'DefaultFigurePaperUnits', 'inches');
set(0,'DefaultFigurePaperPosition', [2,1,3,2.5]);
set(0,'DefaultFigureUnits','inches');

defaultpos = get(0,'DefaultFigurePaperPosition');
figure('Position',defaultpos);

h1 = plot(doses(end:-1:1),PC1_values(end:-1:1),'ok');
fit1 = polyfit(doses(end:-1:1),PC1_values(end:-1:1),1);
myline = @(x) (fit1(2)+fit1(1)*x);
hold on
plot(doses(end:-1:1),myline(doses(end:-1:1)),'-k');
set(gca,'XTick',doses(end:-1:1));
% set(gca,'XTickLabel',{labels{end:-1:1}});
legend('d2');
ylabel('PC1');
xlabel('Dose');
y = myline(doses(end:-1:1));
R2 = 1 - sum((y-PC1_values(end:-1:1)).^2)/sum((mean(PC1_values(end:-1:1))-PC1_values(end:-1:1)).^2);
text(5,-35,sprintf('R^2 = %.3f',R2));
% rotateticklabel(gca,45);
%xticklabel_rotate([],45)

%% Just 20 mg/kg

% Figure properties
set(0,'DefaultAxesFontName','arial');
set(0,'DefaultTextFontName','arial');
set(0,'DefaultTextFontSize',8);
set(0,'DefaultAxesFontSize',8);
set(0,'DefaultFigurePaperPositionMode', 'manual');
set(0,'DefaultFigurePaperUnits', 'inches');
set(0,'DefaultFigurePaperPosition', [2,1,6/2,6.5/3]);
set(0,'DefaultFigureUnits','inches');

defaultpos = get(0,'DefaultFigurePaperPosition');
figure('Position',defaultpos);

no_new_figure = true;
pca_scores_temp = get_pca_model(190);
eval(pca_scores_temp);
view_pca_scores
change_to_ellipse
fix_anit_plot('delete_legend',false,'show_treatment_arrows',true);
