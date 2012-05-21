clc

addpath([pwd,'/lib/munkres']);      %Linear assignment problem
addpath([pwd,'/lib/rand_org']);     %True random numbers
addpath([pwd,'/lib/matlab_xunit/xunit']); %Unit testing framework
addpath([pwd,'/lib/hartigan_dip/']); % Statistical test for multimodality (i.e. reject unimodality with alpha=xyz)
addpath([pwd,'/common_scripts']);
addpath([pwd,'/common_scripts/cursors']);
addpath([pwd,'/common_scripts/dab']);

fprintf('Metabolomics Analysis Toolbox\n\n');
fprintf('Summary of functionality:\n');
fprintf('\topls/main - Orthogonal Projection on Latent Structures\n');
fprintf('\tpca/main - Orthogonal Projection on Latent Structures\n');
fprintf('\tfix_spectra/fix_spectra - Baseline correction, alignment to reference, and zero regions\n');
fprintf('\tbin/main - Bin based quantification/deconvolution designed around dynamic adaptive binning\n');
fprintf('\tvisualization/visualize_collections/main - Flexible spectral viewer\n');
