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

subplot1(3,1,'Gap',[0.04 0.04],'Min',[0.1 0.08],'Max',[0.99 0.99],'FontS',8);

% Plot 500 mg/kg
subplot1(1);
[opls_scores_code,add_new_data] = get_opls_model(350);
eval(opls_scores_code);
view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
collection = get_collection(2545,'Paul Anderson','birglab');
input_data = {'BE 500',48,0;... % Classification, time_unpaired, time_paired
    'BE 500',72,0;...
    'BE 500',96,0;...
    'BE 0',48,0;'BE 0',72,0;'BE 0',96,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);
setappdata(gca, 'markersize',3);
change_to_ellipses
fix_paired_bea_plot('delete_legend',true,'show_treatment_arrows',true);

% Plot 150 mg/kg
subplot1(2);
% eval(opls_scores_code);
metadata = {};
opls_scores = [];
% view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
input_data = {'BE 0',24,0;'BE 0',48,0;'BE 0',72,0;'BE 0',96,0;'BE 150',24,0;'BE 150',48,0;'BE 150',72,0;'BE 150',96,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);
setappdata(gca, 'markersize',3);
change_to_ellipses
fix_paired_bea_plot('delete_legend',true,'show_treatment_arrows',true);

% Plot 50 mg/kg
subplot1(3);
% eval(opls_scores_code);
metadata = {};
opls_scores = [];
% view_opls_scores;
% Create the variables that allow for the addition of new data
eval(add_new_data);
input_data = {'BE 0',24,0;'BE 0',48,0;'BE 0',72,0;'BE 0',96,0;'BE 50',24,0;'BE 50',48,0;'BE 50',72,0;'BE 50',96,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);
setappdata(gca, 'markersize',3);
change_to_ellipses
fix_paired_bea_plot('delete_legend',false,'show_treatment_arrows',true);

labels = {'A. 500 mg/kg','B. 150 mg/kg','C. 50 mg/kg'};
for i = 1:3
    subplot1(i);
%     if i == 2 || i == 4 || i == 6
%         set(gca,'YTickLabel',{});
%         ylabel('');
%     end
    if i == 1 || i == 2
        set(gca,'XTickLabel',{});
        xlabel('');
    end
    text(-380,-25,labels{i});
    axis normal
    xlim([-420,300]);
    ylim([-30,50]);
end

% Plot 500 mg/kg
[opls_scores_code,add_new_data] = get_opls_model(350);
eval(opls_scores_code);
% Create the variables that allow for the addition of new data
eval(add_new_data);
collection = get_collection(2545,'Paul Anderson','birglab');
input_data = {'BE 500',48,0;... % Classification, time_unpaired, time_paired
    'BE 500',72,0;...
    'BE 500',96,0;...
    'BE 0',48,0;'BE 0',72,0;'BE 0',96,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);

% Plot 150 mg/kg
input_data = {'BE 0',24,0;'BE 0',48,0;'BE 0',72,0;'BE 0',96,0;'BE 150',24,0;'BE 150',48,0;'BE 150',72,0;'BE 150',96,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);

% Plot 50 mg/kg
input_data = {'BE 0',24,0;'BE 0',48,0;'BE 0',72,0;'BE 0',96,0;'BE 50',24,0;'BE 50',48,0;'BE 50',72,0;'BE 50',96,0};
[metadata,metadata_headers,opls_scores,all_Xres] = add_new_data_to_paired_scores_plot(X,Y,num_opls_fact,metadata,metadata_headers,opls_scores,all_Xres,input_data,collection);

show_dendrogram;