% Analysis Pipeline

%run Impedance_DataPull.m
load('Excel Spreadsheets/experiment_data.mat')
load('Excel Spreadsheets/t0Fitting_ByTreatment.mat')
load('InfoData.mat')
addpath('helperfcns')

cols=[[0, 0.4470, 0.7410]; [0.4660, 0.6740, 0.1880]; [0.6350, 0.0780, 0.1840];[0.8500, 0.3250, 0.0980]];


%% Q1: Does skin prep method have an effect on impedance at t0?

% Compare with no treatment, use minimum impedance measurement after log
% transform

close all;

% min of two arms @10Hz
[~,mltcmp]= get_anova_results(log(Z10_min.t0), varfun(@log, Z10_min_tbl.t0), 'rm_anova', [], false); 
anova_fig(Z10_min.t0, Z10_min_tbl.t0, mltcmp, []); y_lim= get(gca, 'Ylim'); ylim([y_lim(1), y_lim(2)*1.05])
title('Skin Prep Methods at t0, 10Hz');  ylabel('Impedance (\Omega)', 'interpreter', 'tex')

% mean of two arms @10k
[~,mltcmp]= get_anova_results(log(Z10_mean.t0), varfun(@log, Z10_mean_tbl.t0), 'rm_anova', [], true); 
anova_fig(Z10_mean.t0, Z10_mean_tbl.t0, mltcmp, []); y_lim= get(gca, 'Ylim'); ylim([y_lim(1), y_lim(2)*1.05])
title('Skin Prep Methods at t0, 10Hz');  ylabel('Impedance (\Omega)', 'interpreter', 'tex')

% Use all data points 
[~,mltcmp]=get_anova_results(log(Z10_allT.t0), varfun(@log,Z10_allT_tbl.t0), 'rm_anova', []); 
anova_fig(Z10_allT.t0, Z10_allT_tbl.t0, mltcmp, []); 
title('Skin Prep Methods at t0, min 10Hz');  ylabel('Impedance (\Omega)', 'interpreter', 'tex')

%get_anova_results(log(Z1k_allT.t0), varfun(@log, Z1k_allT_tbl.t0), 'rm_anova'); 
get_anova_results(Z1k_allT.t0, Z1k_allT_tbl.t0, 'rm_anova', []); 
title('Skin Prep Methods at t0, all subjects 1kHz');  ylabel('Impedance (\Omega)', 'interpreter', 'tex')

% right arm only at 10 Hz, 
tp='tf';
rt_arm_data= [Z10_min.(tp)(:,1), Z10_allT.(tp)(1:2:end,:)];
rt_arm_data_tbl= [Z10_mean_tbl.(tp)(:,1), Z10_allT_tbl.(tp)(1:2:end,:)];
[~,mltcmp]= get_anova_results(log(rt_arm_data), varfun(@log,rt_arm_data_tbl), 'rm_anova', [], true); 
%anova_fig(rt_arm_data, rt_arm_data_tbl, mltcmp, []);
title(sprintf('Skin Prep Methods at %s, 10Hz', tp));  ylabel('Impedance (\Omega)', 'interpreter', 'tex')

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

gender=cell(length(Z1k_min.tmid), 1); 
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


% Use right arm data
close all;
tp='t0';
rt_arm_data= log([Z10_min.(tp)(:,1), Z10_allT.(tp)(1:2:end,:)]);
rt_arm_data_tbl= varfun(@log, [Z10_mean_tbl.(tp)(:,1), Z10_allT_tbl.(tp)(1:2:end,:)]); 
rt_arm_data_tbl.gender= gender;
[~,multcmp_10]=get_anova_results(rt_arm_data, rt_arm_data_tbl, 'rm_anova_level', 'gender', true);
title('Skin Prep Methods at t0, 10Hz');  ylabel('Impedance (log \Omega)', 'interpreter', 'tex')

%% Plot Genders

tp='t0'
rt_arm_data= [Z10_min.(tp)(:,1), Z10_allT.(tp)(1:2:end,:)]
cols=[[0, 0.4470, 0.7410]; [0.4660, 0.6740, 0.1880]; [0.6350, 0.0780, 0.1840];[0.8500, 0.3250, 0.0980]];
M=find(SUBJ_info(3:16,2)==0);
F=find(SUBJ_info(3:16,2)==1);


rt_arm_data(M)
a=[-.25,.25];
close all; 

semilogy(1+a,mean(rt_arm_data(M,1))*[1,1]/1000, 'black')
hold on;
semilogy(4+a,mean(rt_arm_data(M,2))*[1,1]/1000, 'black')
semilogy(7+a,mean(rt_arm_data(M,3))*[1,1]/1000, 'black')
semilogy(10+a,mean(rt_arm_data(M,4))*[1,1]/1000, 'black')
set(gca, 'ColorOrder', cols)

semilogy(repmat([1,4,7,10],length(M),1), rt_arm_data(M,:)/1000, '.', 'MarkerSize', 20)
semilogy(repmat([1.5,4.5,7.5,10.5],length(F),1), rt_arm_data(F,:)/1000, 'x', 'MarkerSize', 12)

semilogy(1.5+a,mean(rt_arm_data(F,1))*[1,1]/1000, 'black')
semilogy(4.5+a,mean(rt_arm_data(F,2))*[1,1]/1000, 'black')
semilogy(7.5+a,mean(rt_arm_data(F,3))*[1,1]/1000, 'black')
semilogy(10.5+a,mean(rt_arm_data(F,4))*[1,1]/1000, 'black')
set(gca, 'ColorOrder', cols)

grid on
xticks([1,4,7,10]+.25)
ylim([0.1, 1000])
%xticklabels(Z10_allT_tbl.(tp).Properties.VariableNames)
ylabel('Z_{10Hz}(k\Omega)')
title(sprintf('Skin Prep Methods at %s, 10Hz', tp)); 
xticks('')

%% Q4
 
% Does timepoint and skin preparation method have a significant
% interaction? 

rt_arm_data= [[Z10_min.t0(:,1), Z10_allT.t0(1:2:end,:)];...
    [Z10_min.tmid(:,1), Z10_allT.tmid(1:2:end,:)];...
    [Z10_min.tf(:,1), Z10_allT.tf(1:2:end,:)]];
rt_arm_data_tbl= [[Z10_mean_tbl.t0(:,1), Z10_allT_tbl.t0(1:2:end,:)]; ...
    [Z10_mean_tbl.tmid(:,1), Z10_allT_tbl.tmid(1:2:end,:)];...
    [Z10_mean_tbl.tf(:,1), Z10_allT_tbl.tf(1:2:end,:)]];

anova2(rt_arm_data,14)
h=boxplot(rt_arm_data); set(h,{'linew'},{1.5})


%% Q5: Is there a difference in fitted skin treatment fitted values?

sigs= zeros(6,3); 

for i_param= 1:6 %1-Rsub, 2- Repi, 3-Rgel, 4-Rct, 5-Cdl, 6-Cepi

NT_vals= cellfun(@(x) x(i_param,1), NoTreatment);
SA_vals= cellfun(@(x) x(i_param,1), Salicylic);
uN_vals= cellfun(@(x) x(i_param,1), uNeedle);
Tape3M_vals= cellfun(@(x) x(i_param,1), AbrasiveTape);

data= [NT_vals', Tape3M_vals', SA_vals', uN_vals'];
data_tbl= array2table(data, 'VariableNames', {'NT', 'Tape3M', 'SA', 'uN'}); 

mthd='quartiles';
fprintf('Removing %d rows due to outliers \n', sum(any(isoutlier(data, mthd),2)))
data_tbl(any(isoutlier(data, mthd),2),:)=[];
data(any(isoutlier(data, mthd),2),:)=[];

% Anova Testing
% get_anova_results(data, data_tbl, 'rm_anova', []); 

% Ranksum testing: 
sigs(i_param, 1)= ranksum(data(:,1), data(:,2));
sigs(i_param, 2)= ranksum(data(:,3), data(:,2));
sigs(i_param, 3)= ranksum(data(:,4), data(:,2));

% t-test 
% [~,sigs(1)]= ttest(data(:,1), data(:,2));
% [~,sigs(2)]= ttest(data(:,3), data(:,2));
% [~,sigs(3)]= ttest(data(:,4), data(:,2));

figure(i_param); clf
scatter_mean_figure(data,cols,{[1,2], [3,2], [2,4]}, sigs(i_param, :), .0167)
xticklabels({'NT', 'Tape3M', 'SA', 'uN'});
title(rows{i_param})
set(gcf,'Position', [560   703   331   245])

%saveas(gcf, sprintf('Figs/param_fitting_t0_noOUTLIERS_%s', rows{i_param}), 'png')

end



%% Save Images

timepoint= 't0';
freq= '10_raw_rightarm_gender';

saveas(gcf, sprintf('Figs/skin_prep_boxplot_%s_%s', replace(timepoint, '/', '_'), freq), 'png')
saveas(gcf, sprintf('Figs/skin_prep_boxplot_%s_%s', replace(timepoint, '/', '_'), freq), 'fig')






