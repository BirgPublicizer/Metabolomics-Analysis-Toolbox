%% Using an ID, download OPLS results from the website and show the scores
%% plot

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

subplot1(3,2,'Gap',[0.04 0.04],'Min',[0.1 0.08],'Max',[0.99 0.99],'FontS',8);

% Plot 100 mg/kg
subplot1(1);
[opls_scores_code,add_new_data] = get_opls_model(309);
eval(opls_scores_code);
view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
collection = get_collection(1661,'Paul Anderson','birglab');
input_data = {'100 mg/kg',1,0;... % Classification, time_unpaired, time_paired
    '100 mg/kg',3,0;...
    '100 mg/kg',4,0;...
    'Control',1,0;'Control',3,0;'Control',4,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);
setappdata(gca, 'markersize',3);
change_to_ellipses
fix_paired_anit_plot('delete_legend',true,'show_treatment_arrows',true);

% Plot 50 mg/kg
subplot1(2);
% eval(opls_scores_code);
metadata = {};
opls_scores = [];
% view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
input_data = {'Control',1,0;'Control',2,0;'Control',3,0;'Control',4,0;'50 mg/kg',1,0;'50 mg/kg',2,0;'50 mg/kg',3,0;'50 mg/kg',4,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);
setappdata(gca, 'markersize',3);
change_to_ellipses
fix_paired_anit_plot('delete_legend',true,'show_treatment_arrows',true);

% Plot 20 mg/kg
subplot1(3);
% eval(opls_scores_code);
metadata = {};
opls_scores = [];
% view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
input_data = {'Control',1,0;'Control',2,0;'Control',3,0;'Control',4,0;'20 mg/kg',1,0;'20 mg/kg',2,0;'20 mg/kg',3,0;'20 mg/kg',4,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);
setappdata(gca, 'markersize',3);
change_to_ellipses
fix_paired_anit_plot('delete_legend',true,'show_treatment_arrows',true);

% Plot 10 mg/kg
subplot1(4);
% eval(opls_scores_code);
metadata = {};
opls_scores = [];
% view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
input_data = {'Control',1,0;'Control',2,0;'Control',3,0;'Control',4,0;'10 mg/kg',1,0;'10 mg/kg',2,0;'10 mg/kg',3,0;'10 mg/kg',4,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);
setappdata(gca, 'markersize',3);
change_to_ellipses
fix_paired_anit_plot('delete_legend',true,'show_treatment_arrows',true);

% Plot 1 mg/kg
subplot1(5);
% eval(opls_scores_code);
metadata = {};
opls_scores = [];
% view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
input_data = {'Control',1,0;'Control',2,0;'Control',3,0;'Control',4,0;'1 mg/kg',1,0;'1 mg/kg',2,0;'1 mg/kg',3,0;'1 mg/kg',4,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);
setappdata(gca, 'markersize',3);
change_to_ellipses
fix_paired_anit_plot('delete_legend',false,'show_treatment_arrows',false);

% Plot 0.1 mg/kg
subplot1(6);
% eval(opls_scores_code);
metadata = {};
opls_scores = [];
% view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
input_data = {'Control',1,0;'Control',2,0;'Control',3,0;'Control',4,0;'0.1 mg/kg',1,0;'0.1 mg/kg',2,0;'0.1 mg/kg',3,0;'0.1 mg/kg',4,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);
setappdata(gca, 'markersize',3);
change_to_ellipses
fix_paired_anit_plot('delete_legend',true,'show_treatment_arrows',false);

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
    text(-18,-8,labels{i});
    axis normal
    xlim([-20,35]);
    ylim([-10,10]);
end

%% Now create the dendrogram
h = figure;
[opls_scores_code,add_new_data] = get_opls_model(309);
eval(opls_scores_code);
view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
collection = get_collection(1661,'Paul Anderson','birglab');
input_data = {'100 mg/kg',1,0;... % Classification, time_unpaired, time_paired
    '100 mg/kg',3,0;...
    '100 mg/kg',4,0;...
    'Control',1,0;'Control',3,0;'Control',4,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);

% Plot 50 mg/kg
% eval(opls_scores_code);
% view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
input_data = {'Control',1,0;'Control',2,0;'Control',3,0;'Control',4,0;'50 mg/kg',1,0;'50 mg/kg',2,0;'50 mg/kg',3,0;'50 mg/kg',4,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);

% Plot 20 mg/kg
% eval(opls_scores_code);
% view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
input_data = {'Control',1,0;'Control',2,0;'Control',3,0;'Control',4,0;'20 mg/kg',1,0;'20 mg/kg',2,0;'20 mg/kg',3,0;'20 mg/kg',4,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);

% Plot 10 mg/kg
% eval(opls_scores_code);
% view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
input_data = {'Control',1,0;'Control',2,0;'Control',3,0;'Control',4,0;'10 mg/kg',1,0;'10 mg/kg',2,0;'10 mg/kg',3,0;'10 mg/kg',4,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);

% Plot 1 mg/kg
% eval(opls_scores_code);
% view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
input_data = {'Control',1,0;'Control',2,0;'Control',3,0;'Control',4,0;'1 mg/kg',1,0;'1 mg/kg',2,0;'1 mg/kg',3,0;'1 mg/kg',4,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);

% Plot 0.1 mg/kg
% eval(opls_scores_code);
% view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
input_data = {'Control',1,0;'Control',2,0;'Control',3,0;'Control',4,0;'0.1 mg/kg',1,0;'0.1 mg/kg',2,0;'0.1 mg/kg',3,0;'0.1 mg/kg',4,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);

% Create plots
set(0,'DefaultAxesFontName','arial');
set(0,'DefaultTextFontName','arial');
set(0,'DefaultTextFontSize',8);
set(0,'DefaultAxesFontSize',8);
set(0,'DefaultFigurePaperPositionMode', 'manual');
set(0,'DefaultFigurePaperUnits', 'inches');
set(0,'DefaultFigurePaperPosition', [2,1,6,3.25]);
set(0,'DefaultFigureUnits','inches');

defaultpos = get(0,'DefaultFigurePaperPosition');
figure('Position',defaultpos);

subplot1(1,2,'Gap',[0.04 0.04],'Min',[0.15 0.1],'Max',[0.99 0.99],'FontS',8);
subplot1(1);
show_dendrogram;
xlabel('Distance between clusters');
subplot1(2);
num_class_labels = zeros(size(class_labels));
cnt = 1;
order = [];
for i = 1:length(PERM)
    inxs1 = find(strcmp(unique_class_labels{PERM(i)},class_labels) == 1);
    num_class_labels(inxs1) = i;
    for j = 1:length(inxs1)
        order(end+1) = inxs1(j);
    end
end
yticklabels = {class_labels{order}};
for i = 1:length(yticklabels)
    yticklabels{i} = regexprep(yticklabels{i},'1-0','d1');
    yticklabels{i} = regexprep(yticklabels{i},'2-0','d2');
    yticklabels{i} = regexprep(yticklabels{i},'3-0','d3');
    yticklabels{i} = regexprep(yticklabels{i},'4-0','d4');
    fields = split(yticklabels{i},',');
    yticklabels{i} = sprintf('%2s%10s',fields{1},fields{2});
end
boxplot(opls_scores(order,1),yticklabels,'orientation','horizontal');
houtliers=findobj(gca,'tag','Outliers');
for i = 1:length(houtliers)
    set(houtliers(i),'Visible','off');
end
set(gca,'yticklabel',yticklabels);
set(gca,'fontname','fixedwidth');
subplot1(1);
yl = ylim;
subplot1(2);
ylim(yl);
xlabel('T');
delete(h);

%% Now show the q2 distributions

% Figure properties
set(0,'DefaultAxesFontName','arial');
set(0,'DefaultTextFontName','arial');
set(0,'DefaultTextFontSize',8);
set(0,'DefaultAxesFontSize',8);
set(0,'DefaultFigurePaperPositionMode', 'manual');
set(0,'DefaultFigurePaperUnits', 'inches');
set(0,'DefaultFigurePaperPosition', [2,1,3,6.5]);
set(0,'DefaultFigureUnits','inches');

defaultpos = get(0,'DefaultFigurePaperPosition');
figure('Position',defaultpos);

subplot1(3,1,'Gap',[0.04 0.04],'Min',[0.1 0.08],'Max',[0.99 0.99],'FontS',8);
% 100 mg/kg
[opls_scores_code,add_new_data] = get_opls_model(309);
eval(opls_scores_code);
subplot1(1);
[f,xi] = ksdensity(perm_q2s);
f = f/sum(f);
plot(xi,f,'k-');
xlim([-0.5,1]);
yl = ylim;
arrow([q2,yl(2)/4],[q2,0]);
sorted = sort(perm_q2s);
dashedx = sorted(end);
htemp = plot([dashedx,dashedx],yl,'--k');
set(gca,'yticklabel',{});

% 50 mg/kg
[opls_scores_code,add_new_data] = get_opls_model(312);
eval(opls_scores_code);
subplot1(2);
[f,xi] = ksdensity(perm_q2s);
f = f/sum(f);
plot(xi,f,'k-');
xlim([-0.5,1]);
yl = ylim;
arrow([q2,yl(2)/4],[q2,0]);
sorted = sort(perm_q2s);
dashedx = sorted(end);
htemp = plot([dashedx,dashedx],yl,'--k');
set(gca,'yticklabel',{});

% 20 mg/kg
[opls_scores_code,add_new_data] = get_opls_model(313);
eval(opls_scores_code);
subplot1(3);
[f,xi] = ksdensity(perm_q2s);
f = f/sum(f);
plot(xi,f,'k-');
xlim([-0.5,1]);
yl = ylim;
arrow([q2,yl(2)/4],[q2,0]);
xlabel('Q^2')
sorted = sort(perm_q2s);
dashedx = sorted(end);
htemp = plot([dashedx,dashedx],yl,'--k');
set(gca,'yticklabel',{});