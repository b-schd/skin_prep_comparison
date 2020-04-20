clear all; warning off; 

load InfoData.mat; 
addpath('Excel Spreadsheets/'); %--add path to the Excel Spreadsheets

%% SETTINGS:

% Define Subject IDs: 
subjNums=[3:16];

% Define frequencies of interest:
freqs= [10; 1000]; % currently hardcoded for 10 and 1k

% Note: timepoints of interest are hardcoded to t0, tf, and tf-1. 

%% Subject Information 

%--average age of all subjects = 29 +/- 9 yrs.
mean_age = [round(mean(SUBJ_info(:,3))) round(std(SUBJ_info(:,3)))];

clear k;
k = SUBJ_info(find(SUBJ_info(:,2) == 1)); %--find the female subjects
nF = length(k); %--number of female subjects = 7
mean_age_F = [round(mean(SUBJ_info(k,3))) round(std(SUBJ_info(k,3)))]; %--mean age of female subjects

clear k;
k = SUBJ_info(find(SUBJ_info(:,2) == 0)); %--find the male subjects
nM = length(k); %--number of male subjects = 9
mean_age_M = [round(mean(SUBJ_info(k,3))) round(std(SUBJ_info(k,3)))]; %--mean age of male subjects

%% Get the INITIAL and DAY END, and FINAL impedance data at 1 kHz and 10 Hz for each treatment, for all subjects

%--treatments: NT = "No Treatment", 
%              Tape3M = "3M TracePrep Abrasive Tape, 
%              SA = "Salicylic Acid in the form of Acne Face Wash", and 
%              uN = "AdminPatch MicroNeedle array"
%
%--the columns of the Z1k_t0 and Z10_t0 arrays represent each treatment,
%  while the rows represent each subject from SUBJ003 - SUBJ014
%
%--NB: there were 2 electrodes placed over top of the Tape3M, SA, and uN
%  skin treatments: thus, when these values are being pulled from the Excel
%  files, I am taking the MEAN of the 2 values as the true value of the
%  skin impedance under that specific treatment

%--NB: the first 2 subjects are ignored, because they had different
%  electrodes from the other 14 subjects...thus, the overall N is actually
%  14, instead of 16. The subjects considered are SUBJ003 - SUBJ016.


% Initialize data tables
tlab= {'tf', 'tmid', 't0'};  
[Z1k_min, Z1k_mean, Z1k_allT, Z10_min, Z10_mean, Z10_allT,...
    Z1k_min_tbl, Z1k_mean_tbl, Z1k_allT_Tbl, Z10_min_tbl,...
    Z10_mean_tbl, Z10_allT_tbl]= deal(struct());
   
for i_subj= 1:length(subjNums)
    
    % Read in subject's sheets
    NT= readtable(sprintf('EpCo SUBJ%03.f Skin Impedance.xlsx',subjNums(i_subj)),'Sheet', 1, 'Range', '5:46');
    Tape3M= readtable(sprintf('EpCo SUBJ%03.f Skin Impedance.xlsx',subjNums(i_subj)),'Sheet', 2, 'Range', '5:46');
    SA= readtable(sprintf('EpCo SUBJ%03.f Skin Impedance.xlsx',subjNums(i_subj)),'Sheet', 3, 'Range', '5:46');
    uN= readtable(sprintf('EpCo SUBJ%03.f Skin Impedance.xlsx',subjNums(i_subj)),'Sheet', 4, 'Range', '5:46');
    
    ntrials= (width(NT)-2)/3;       % total number of time_trials. 
    i_f= dsearchn(NT{:,1},freqs);   % get frequency indices
    
    NT_t= 1+[1, 2, ntrials];         % get time indices for no treatment, add 1 since first column is frequency
    T_t= 1+[1, 3, (ntrials*2)-1];    % get time indices with treatment, add 1 since first column is frequency
 
    % Loop through different time points, get impedance at each time point
    % and frequency value (currently frequency values are hard coded). 
    for i_t = 1:length(NT_t)
        
        % Get minimum of each arm's impedance measurement
        Z10_min.(tlab{i_t})(i_subj,:)= [ NT{i_f(1), NT_t(i_t)}, nanmin(Tape3M{i_f(1), (0:1)+T_t(i_t)}),...
            nanmin(SA{i_f(1), (0:1)+T_t(i_t)}), nanmin(uN{i_f(1), (0:1)+T_t(i_t)})];
        Z1k_min.(tlab{i_t})(i_subj,:)= [ NT{i_f(2), NT_t(i_t)}, nanmin(Tape3M{i_f(2), (0:1)+T_t(i_t)}),...
            nanmin(SA{i_f(2), (0:1)+T_t(i_t)}), nanmin(uN{i_f(2), (0:1)+T_t(i_t)})];
        
        % Get mean of each arm's impedance measurement
        Z10_mean.(tlab{i_t})(i_subj,:)= [ NT{i_f(1), NT_t(i_t)}, nanmean(Tape3M{i_f(1), (0:1)+T_t(i_t)}),...
            nanmean(SA{i_f(1), (0:1)+T_t(i_t)}), nanmean(uN{i_f(1), (0:1)+T_t(i_t)})];
        Z1k_mean.(tlab{i_t})(i_subj,:)= [ NT{i_f(2), NT_t(i_t)}, nanmean(Tape3M{i_f(2), (0:1)+T_t(i_t)}),...
            nanmean(SA{i_f(2), (0:1)+T_t(i_t)}), nanmean(uN{i_f(2), (0:1)+T_t(i_t)})];
        
        % Get both values for all treatments 
        ind=(0:1)+(i_subj*2-1);
        Z10_allT.(tlab{i_t})(ind,:)= [Tape3M{i_f(1), (0:1)+T_t(i_t)}', SA{i_f(1), (0:1)+T_t(i_t)}', uN{i_f(1), (0:1)+T_t(i_t)}']; 
        Z1k_allT.(tlab{i_t})(ind,:)= [Tape3M{i_f(2), (0:1)+T_t(i_t)}', SA{i_f(2), (0:1)+T_t(i_t)}', uN{i_f(2), (0:1)+T_t(i_t)}'];
    end
end


% Create tables from the data
for i_t = 1:length(NT_t) 
   Z10_min_tbl.(tlab{i_t})= array2table(Z10_min.(tlab{i_t}), 'VariableNames', {'NT', 'Tape3M', 'SA', 'uN'});
   Z1k_min_tbl.(tlab{i_t})= array2table(Z1k_min.(tlab{i_t}), 'VariableNames', {'NT', 'Tape3M', 'SA', 'uN'});
   Z10_mean_tbl.(tlab{i_t})= array2table(Z10_mean.(tlab{i_t}), 'VariableNames', {'NT', 'Tape3M', 'SA', 'uN'});
   Z1k_mean_tbl.(tlab{i_t})= array2table(Z1k_mean.(tlab{i_t}), 'VariableNames', {'NT', 'Tape3M', 'SA', 'uN'});
   Z10_allT_tbl.(tlab{i_t})= array2table(Z10_allT.(tlab{i_t}), 'VariableNames', {'Tape3M', 'SA', 'uN'});
   Z1k_allT_tbl.(tlab{i_t})= array2table(Z1k_allT.(tlab{i_t}), 'VariableNames', {'Tape3M', 'SA', 'uN'});   
end

clear('NT', 'Tape3M', 'SA', 'uN', 'i_t', 'i_f', 'NT_t', 'T_t', 'i_subj','k')

%%

for i=1:4 %--for each skin treatment
    
    avgZ1k_t0(:,i) = [nanmean(Z1k_min.t0(:,i)); nanstd(Z1k_min.t0(:,i))]; %--average and std 1 kHz impedance of all subjects    
    avgZ10_t0(:,i) = [nanmean(Z10_min.t0(:,i)); nanstd(Z10_min.t0(:,i))];%--average 10 Hz impedance of all subjects   
    avgZ1k_tf(:,i) = [nanmean(Z1k_min.tf(:,i)); nanstd(Z1k_min.tf(:,i))]; %--average 1 kHz impedance of all subjects
    avgZ10_tf(:,i) = [nanmean(Z10_min.tf(:,i)); nanstd(Z10_min.tf(:,i))]; %--average 10 Hz impedance of all subjects
    
end; clear i;
