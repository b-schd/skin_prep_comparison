% Analysis Pipeline

run Impedance_DataPull.m
load('InfoData.mat')
addpath('helperfcns')

%% Q1: Does skin prep method have an effect on impedance at t0?

% Compare with no treatment, use minimum impedance measurement after log
% transform

close all;
get_anova_results(log(Z10_min.t0), varfun(@log, Z10_min_tbl.t0), 'rm_anova'); 
title('Skin Prep Methods at t0, 10Hz');  ylabel('Impedance (log \Omega)', 'interpreter', 'tex')

[st1,st]=get_anova_results(log(Z1k_min.t0),varfun(@log, Z1k_min_tbl.t0), 'rm_anova'); 
title('Skin Prep Methods at t0, 1kHz');  ylabel('Impedance (log \Omega)', 'interpreter', 'tex')

% Use all subjects 
get_anova_results(log(Z10_allT.t0), varfun(@log,Z10_allT_tbl.t0), 'rm_anova'); 
title('Skin Prep Methods at t0, min 10Hz');  ylabel('Impedance (log \Omega)', 'interpreter', 'tex')

%get_anova_results(log(Z1k_allT.t0), varfun(@log, Z1k_allT_tbl.t0), 'rm_anova'); 
get_anova_results(Z1k_allT.t0, Z1k_allT_tbl.t0, 'rm_anova'); 
title('Skin Prep Methods at t0, all subjects 1kHz');  ylabel('Impedance (\Omega)', 'interpreter', 'tex')


%% Q2: Does skin prep method have an effect on impedance over time (tmid/t0) ?

close all;
data= Z10_min.tmid./Z10_min.t0; 
data_tbl= array2table(data, 'VariableNames', {'MT', 'Tape3M', 'SA', 'uN'}); 
get_anova_results(data, data_tbl, 'rm_anova'); 
title('Skin Prep Methods at tmid/t0, 10Hz');
ylabel('Z/Z_0 at 10Hz (a.u.)', 'interpreter', 'tex')

data= Z1k_min.tmid./Z1k_min.t0; 
data_tbl= array2table(data, 'VariableNames', {'MT', 'Tape3M', 'SA', 'uN'}); 
get_anova_results(data, data_tbl, 'rm_anova'); 
title('Skin Prep Methods at tmid/t0, 1kHz', 'interpreter', 'tex');
ylabel('Z/Z_0 at 1KHz (a.u.)', 'interpreter', 'tex')


%% Q3: Does gender introduce an interaction with skin prep effect?

gender=cell(height(data_tbl), 1); 
gender(SUBJ_info(3:16,2)==0)= {'M'}; gender(SUBJ_info(3:16,2)==1)= {'F'}; 

data_tbl= varfun(@log, Z10_min_tbl.t0); data_tbl.gender= gender; data= log(Z10_min.t0);
%data_tbl= Z10_min_tbl.t0; data_tbl.gender= gender; data= Z10_min.t0; 
[~,multcmp_10]=get_anova_results(data, data_tbl, 'rm_anova_level', 'gender');
title('Skin Prep Methods at t0, 10Hz');  ylabel('Impedance (log \Omega)', 'interpreter', 'tex')

data_tbl= varfun(@log, Z1k_min_tbl.t0); data_tbl.gender= gender; data= log(Z1k_min.t0);
%data_tbl= Z1k_min_tbl.t0; data_tbl.gender= gender; data= Z1k_min.t0; 
[~,multcmp_1k]=get_anova_results(data, data_tbl, 'rm_anova_level', 'gender'); 
title('Skin Prep Methods at t0, 1kHz');  ylabel('Impedance (log \Omega)', 'interpreter', 'tex')

% Use all subjects 

close all
data_tbl= varfun(@log, Z10_allT_tbl.t0); data_tbl.gender= repelem(gender,2); data= log(Z10_allT.t0); 
%data_tbl= Z10_allT_tbl.t0; data_tbl.gender= repelem(gender,2); data= Z10_allT.t0; 
[~,multcmpAll_10]=get_anova_results(data, data_tbl, 'rm_anova_level', 'gender');
title('Skin Prep Methods at t0 10Hz');  ylabel('Impedance (log \Omega)', 'interpreter', 'tex')

%data_tbl= varfun(@log, Z1k_allT_tbl.t0); data_tbl.gender= repelem(gender,2); data= log(Z1k_allT.t0); 
data_tbl= Z1k_allT_tbl.t0; data_tbl.gender= repelem(gender,2); data= Z1k_allT.t0; 
[~,multcmpAll_1k]=get_anova_results(data, data_tbl, 'rm_anova_level', 'gender'); 
title('Skin Prep Methods at t0, 1kHz');  ylabel('Impedance (\Omega)', 'interpreter', 'tex')


%% Save Images

timepoint= 't0';
freq= '1K_gender_All';

saveas(gcf, sprintf('Figs/skin_prep_boxplot_%s_%s', replace(timepoint, '/', '_'), freq), 'png')
saveas(gcf, sprintf('Figs/skin_prep_boxplot_%s_%s', replace(timepoint, '/', '_'), freq), 'fig')






