% Analysis Pipeline

run Impedance_DataPull.m
load('InfoData.mat')
addpath('helperfcns')

%% Q1: Does skin prep method have an effect on impedance at t0?

get_anova_results(Z10_t0, Z10_t0_tbl, 'rm_anova'); 
title('Skin Prep Methods at t0, 10Hz');  ylabel('Impedance')

get_anova_results(Z1k_t0, Z1k_t0_tbl, 'rm_anova'); 
title('Skin Prep Methods at t0, 1kHz');  ylabel('Impedance')

%% Q2: Does skin prep method have an effect on impedance over time (t0/tf) ?

data= Z10_t0./Z10_tf; 
data_tbl= array2table(data, 'VariableNames', {'MT', 'Tape3M', 'SA', 'uN'}); 
get_anova_results(data, data_tbl, 'rm_anova'); 
title('Skin Prep Methods at t0/tf, 10Hz');  ylabel('Impedance Ratio (t0/tf)')

data= Z1k_t0./Z1k_tf; 
data_tbl= array2table(data, 'VariableNames', {'MT', 'Tape3M', 'SA', 'uN'}); 
get_anova_results(data, data_tbl, 'rm_anova'); 
title('Skin Prep Methods at t0/tf, 1kHz');  ylabel('Impedance Ratio (t0/tf)')


%% Q3: Does gender introduce an interaction with skin prep effect?

gender=cell(height(data_tbl), 1); 
gender(SUBJ_info(3:16,2)==0)= {'M'}; gender(SUBJ_info(3:16,2)==1)= {'F'}; 

data_tbl= Z10_t0_tbl; data_tbl.gender= gender; data= Z10_t0; 
[~,multcmp_10]=get_anova_results(data, data_tbl, 'rm_anova_level', 'gender');
title('Skin Prep Methods at t0, 10Hz');  ylabel('Impedance')

data_tbl= Z1k_t0_tbl; data_tbl.gender= gender; data= Z1k_t0; 
[~,multcmp_1k]=get_anova_results(data, data_tbl, 'rm_anova_level', 'gender'); 
title('Skin Prep Methods at t0, 1kHz');  ylabel('Impedance')

%% Save Images

timepoint= 't0';
freq= '1k_gender';

saveas(gcf, sprintf('Figs/skin_prep_boxplot_%s_%s', replace(timepoint, '/', '_'), freq), 'png')
saveas(gcf, sprintf('Figs/skin_prep_boxplot_%s_%s', replace(timepoint, '/', '_'), freq), 'fig')






