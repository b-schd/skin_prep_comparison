clear all; warning off; 

load InfoData.mat; 

README
SUBJ_info

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

%% Get the INITIAL impedance data at 1 kHz and 10 Hz for each treatment, for all subjects

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

addpath('Excel Spreadsheets/'); %--add path to the Excel Spreadsheets

%--NB: the first 2 subjects are ignored, because they had different
%  electrodes from the other 14 subjects...thus, the overall N is actually
%  14, instead of 16. The subjects considered are SUBJ003 - SUBJ016.

NT_t0 = [xlsread('EpCo SUBJ003 Skin Impedance.xlsx',1,'E26')
    xlsread('EpCo SUBJ004 Skin Impedance.xlsx',1,'E26')
    xlsread('EpCo SUBJ005 Skin Impedance.xlsx',1,'E26')
    xlsread('EpCo SUBJ006 Skin Impedance.xlsx',1,'E26')
    xlsread('EpCo SUBJ007 Skin Impedance.xlsx',1,'E26')
    xlsread('EpCo SUBJ008 Skin Impedance.xlsx',1,'E26')
    xlsread('EpCo SUBJ009 Skin Impedance.xlsx',1,'E26')
    xlsread('EpCo SUBJ010 Skin Impedance.xlsx',1,'E26')
    xlsread('EpCo SUBJ011 Skin Impedance.xlsx',1,'E26')
    xlsread('EpCo SUBJ012 Skin Impedance.xlsx',1,'E26')
    xlsread('EpCo SUBJ013 Skin Impedance.xlsx',1,'E26')
    xlsread('EpCo SUBJ014 Skin Impedance.xlsx',1,'E26')
    xlsread('EpCo SUBJ015 Skin Impedance.xlsx',1,'E26')
    xlsread('EpCo SUBJ016 Skin Impedance.xlsx',1,'E26')];
Tape3M_t0 = [mean(xlsread('EpCo SUBJ003 Skin Impedance.xlsx',2,'J26:K26'))
    mean(xlsread('EpCo SUBJ004 Skin Impedance.xlsx',2,'J26:K26'))
    mean(xlsread('EpCo SUBJ005 Skin Impedance.xlsx',2,'J26:K26'))
    mean(xlsread('EpCo SUBJ006 Skin Impedance.xlsx',2,'J26:K26'))
    mean(xlsread('EpCo SUBJ007 Skin Impedance.xlsx',2,'J26:K26'))
    mean(xlsread('EpCo SUBJ008 Skin Impedance.xlsx',2,'J26:K26'))
    mean(xlsread('EpCo SUBJ009 Skin Impedance.xlsx',2,'J26:K26'))
    mean(xlsread('EpCo SUBJ010 Skin Impedance.xlsx',2,'J26:K26'))
    mean(xlsread('EpCo SUBJ011 Skin Impedance.xlsx',2,'J26:K26'))
    mean(xlsread('EpCo SUBJ012 Skin Impedance.xlsx',2,'J26:K26'))
    mean(xlsread('EpCo SUBJ013 Skin Impedance.xlsx',2,'J26:K26'))
    mean(xlsread('EpCo SUBJ014 Skin Impedance.xlsx',2,'J26:K26'))
    mean(xlsread('EpCo SUBJ015 Skin Impedance.xlsx',2,'J26:K26'))
    mean(xlsread('EpCo SUBJ016 Skin Impedance.xlsx',2,'J26:K26'))];
SA_t0 = [mean(xlsread('EpCo SUBJ003 Skin Impedance.xlsx',3,'J26:K26'))
    mean(xlsread('EpCo SUBJ004 Skin Impedance.xlsx',3,'J26:K26'))
    mean(xlsread('EpCo SUBJ005 Skin Impedance.xlsx',3,'J26:K26'))
    mean(xlsread('EpCo SUBJ006 Skin Impedance.xlsx',3,'J26:K26'))
    mean(xlsread('EpCo SUBJ007 Skin Impedance.xlsx',3,'J26:K26'))
    mean(xlsread('EpCo SUBJ008 Skin Impedance.xlsx',3,'J26:K26'))
    mean(xlsread('EpCo SUBJ009 Skin Impedance.xlsx',3,'J26:K26'))
    mean(xlsread('EpCo SUBJ010 Skin Impedance.xlsx',3,'J26:K26'))
    mean(xlsread('EpCo SUBJ011 Skin Impedance.xlsx',3,'J26:K26'))
    mean(xlsread('EpCo SUBJ012 Skin Impedance.xlsx',3,'J26:K26'))
    mean(xlsread('EpCo SUBJ013 Skin Impedance.xlsx',3,'J26:K26'))
    mean(xlsread('EpCo SUBJ014 Skin Impedance.xlsx',3,'J26:K26'))
    mean(xlsread('EpCo SUBJ015 Skin Impedance.xlsx',3,'J26:K26'))
    mean(xlsread('EpCo SUBJ016 Skin Impedance.xlsx',3,'J26:K26'))];
uN_t0 = [mean(xlsread('EpCo SUBJ003 Skin Impedance.xlsx',4,'J26:K26'))
    mean(xlsread('EpCo SUBJ004 Skin Impedance.xlsx',4,'J26:K26'))
    mean(xlsread('EpCo SUBJ005 Skin Impedance.xlsx',4,'J26:K26'))
    mean(xlsread('EpCo SUBJ006 Skin Impedance.xlsx',4,'J26:K26'))
    mean(xlsread('EpCo SUBJ007 Skin Impedance.xlsx',4,'J26:K26'))
    mean(xlsread('EpCo SUBJ008 Skin Impedance.xlsx',4,'J26:K26'))
    mean(xlsread('EpCo SUBJ009 Skin Impedance.xlsx',4,'J26:K26'))
    mean(xlsread('EpCo SUBJ010 Skin Impedance.xlsx',4,'J26:K26'))
    mean(xlsread('EpCo SUBJ011 Skin Impedance.xlsx',4,'J26:K26'))
    mean(xlsread('EpCo SUBJ012 Skin Impedance.xlsx',4,'J26:K26'))
    mean(xlsread('EpCo SUBJ013 Skin Impedance.xlsx',4,'J26:K26'))
    mean(xlsread('EpCo SUBJ014 Skin Impedance.xlsx',4,'J26:K26'))
    mean(xlsread('EpCo SUBJ015 Skin Impedance.xlsx',4,'J26:K26'))
    mean(xlsread('EpCo SUBJ016 Skin Impedance.xlsx',4,'J26:K26'))];

Z1k_t0 = [NT_t0 Tape3M_t0 SA_t0 uN_t0]
Z1k_t0_tbl= array2table(Z1k_t0, 'VariableNames', {'NT_t0', 'Tape3M_t0', 'SA_t0', 'uN_t0'});
clear('NT_t0', 'Tape3M_t0', 'SA_t0', 'uN_t0'); 

NT_t0 = [xlsread('EpCo SUBJ003 Skin Impedance.xlsx',1,'E46')
    xlsread('EpCo SUBJ004 Skin Impedance.xlsx',1,'E46')
    xlsread('EpCo SUBJ005 Skin Impedance.xlsx',1,'E46')
    xlsread('EpCo SUBJ006 Skin Impedance.xlsx',1,'E46')
    xlsread('EpCo SUBJ007 Skin Impedance.xlsx',1,'E46')
    xlsread('EpCo SUBJ008 Skin Impedance.xlsx',1,'E46')
    xlsread('EpCo SUBJ009 Skin Impedance.xlsx',1,'E46')
    xlsread('EpCo SUBJ010 Skin Impedance.xlsx',1,'E46')
    xlsread('EpCo SUBJ011 Skin Impedance.xlsx',1,'E46')
    xlsread('EpCo SUBJ012 Skin Impedance.xlsx',1,'E46')
    xlsread('EpCo SUBJ013 Skin Impedance.xlsx',1,'E46')
    xlsread('EpCo SUBJ014 Skin Impedance.xlsx',1,'E46')
    xlsread('EpCo SUBJ015 Skin Impedance.xlsx',1,'E46')
    xlsread('EpCo SUBJ016 Skin Impedance.xlsx',1,'E46')];
Tape3M_t0 = [mean(xlsread('EpCo SUBJ003 Skin Impedance.xlsx',2,'J46:K46'))
    mean(xlsread('EpCo SUBJ004 Skin Impedance.xlsx',2,'J46:K46'))
    mean(xlsread('EpCo SUBJ005 Skin Impedance.xlsx',2,'J46:K46'))
    mean(xlsread('EpCo SUBJ006 Skin Impedance.xlsx',2,'J46:K46'))
    mean(xlsread('EpCo SUBJ007 Skin Impedance.xlsx',2,'J46:K46'))
    mean(xlsread('EpCo SUBJ008 Skin Impedance.xlsx',2,'J46:K46'))
    mean(xlsread('EpCo SUBJ009 Skin Impedance.xlsx',2,'J46:K46'))
    mean(xlsread('EpCo SUBJ010 Skin Impedance.xlsx',2,'J46:K46'))
    mean(xlsread('EpCo SUBJ011 Skin Impedance.xlsx',2,'J46:K46'))
    mean(xlsread('EpCo SUBJ012 Skin Impedance.xlsx',2,'J46:K46'))
    mean(xlsread('EpCo SUBJ013 Skin Impedance.xlsx',2,'J46:K46'))
    mean(xlsread('EpCo SUBJ014 Skin Impedance.xlsx',2,'J46:K46'))
    mean(xlsread('EpCo SUBJ015 Skin Impedance.xlsx',2,'J46:K46'))
    mean(xlsread('EpCo SUBJ016 Skin Impedance.xlsx',2,'J46:K46'))];
SA_t0 = [mean(xlsread('EpCo SUBJ003 Skin Impedance.xlsx',3,'J46:K46'))
    mean(xlsread('EpCo SUBJ004 Skin Impedance.xlsx',3,'J46:K46'))
    mean(xlsread('EpCo SUBJ005 Skin Impedance.xlsx',3,'J46:K46'))
    mean(xlsread('EpCo SUBJ006 Skin Impedance.xlsx',3,'J46:K46'))
    mean(xlsread('EpCo SUBJ007 Skin Impedance.xlsx',3,'J46:K46'))
    mean(xlsread('EpCo SUBJ008 Skin Impedance.xlsx',3,'J46:K46'))
    mean(xlsread('EpCo SUBJ009 Skin Impedance.xlsx',3,'J46:K46'))
    mean(xlsread('EpCo SUBJ010 Skin Impedance.xlsx',3,'J46:K46'))
    mean(xlsread('EpCo SUBJ011 Skin Impedance.xlsx',3,'J46:K46'))
    mean(xlsread('EpCo SUBJ012 Skin Impedance.xlsx',3,'J46:K46'))
    mean(xlsread('EpCo SUBJ013 Skin Impedance.xlsx',3,'J46:K46'))
    mean(xlsread('EpCo SUBJ014 Skin Impedance.xlsx',3,'J46:K46'))
    mean(xlsread('EpCo SUBJ015 Skin Impedance.xlsx',3,'J46:K46'))
    mean(xlsread('EpCo SUBJ016 Skin Impedance.xlsx',3,'J46:K46'))];
uN_t0 = [mean(xlsread('EpCo SUBJ003 Skin Impedance.xlsx',4,'J46:K46'))
    mean(xlsread('EpCo SUBJ004 Skin Impedance.xlsx',4,'J46:K46'))
    mean(xlsread('EpCo SUBJ005 Skin Impedance.xlsx',4,'J46:K46'))
    mean(xlsread('EpCo SUBJ006 Skin Impedance.xlsx',4,'J46:K46'))
    mean(xlsread('EpCo SUBJ007 Skin Impedance.xlsx',4,'J46:K46'))
    mean(xlsread('EpCo SUBJ008 Skin Impedance.xlsx',4,'J46:K46'))
    mean(xlsread('EpCo SUBJ009 Skin Impedance.xlsx',4,'J46:K46'))
    mean(xlsread('EpCo SUBJ010 Skin Impedance.xlsx',4,'J46:K46'))
    mean(xlsread('EpCo SUBJ011 Skin Impedance.xlsx',4,'J46:K46'))
    mean(xlsread('EpCo SUBJ012 Skin Impedance.xlsx',4,'J46:K46'))
    mean(xlsread('EpCo SUBJ013 Skin Impedance.xlsx',4,'J46:K46'))
    mean(xlsread('EpCo SUBJ014 Skin Impedance.xlsx',4,'J46:K46'))
    mean(xlsread('EpCo SUBJ015 Skin Impedance.xlsx',4,'J46:K46'))
    mean(xlsread('EpCo SUBJ016 Skin Impedance.xlsx',4,'J46:K46'))];

Z10_t0 = [NT_t0 Tape3M_t0 SA_t0 uN_t0]
Z10_t0_tbl= array2table(Z1k_t0, 'VariableNames', {'NT_t0', 'Tape3M_t0', 'SA_t0', 'uN_t0'});
clear('NT_t0', 'Tape3M_t0', 'SA_t0', 'uN_t0'); 

for i=1:4 %--for each skin treatment
    
    avgZ1k_t0(i) = nanmean(Z1k_t0(:,i)); %--average 1 kHz impedance of all subjects
    stdZ1k_t0(i) = nanstd(Z1k_t0(:,i)); %--std. dev. 1 kHz impedance of all subjects
    
    avgZ10_t0(i) = nanmean(Z10_t0(:,i)); %--average 10 Hz impedance of all subjects
    stdZ10_t0(i) = nanstd(Z10_t0(:,i)); %--std. dev. 10 Hz impedance of all subjects
    
end; clear i;

[avgZ1k_t0; stdZ1k_t0] %--avg. +/- std. dev. for each treatment, across all subjects
[avgZ10_t0; stdZ10_t0] %--avg. +/- std. dev. for each treatment, across all subjects

%% Get the FINAL impedance data at 1 kHz and 10 Hz for each treatment, for all subjects

%--again, the columns of the Z1k_t0 and Z10_t0 arrays represent each
%  treatment, while the rows represent each subject from SUBJ003 - SUBJ014
%
%--Again, there were 2 electrodes placed over top of the Tape3M, SA, and uN
%  skin treatments: thus, when these values are being pulled from the Excel
%  files, I am taking the MEAN of the 2 values as the true value of the
%  skin impedance under that specific treatment

NT_tf = [xlsread('EpCo SUBJ003 Skin Impedance.xlsx',1,'B26')
    xlsread('EpCo SUBJ004 Skin Impedance.xlsx',1,'B26')
    xlsread('EpCo SUBJ005 Skin Impedance.xlsx',1,'B26')
    xlsread('EpCo SUBJ006 Skin Impedance.xlsx',1,'B26')
    xlsread('EpCo SUBJ007 Skin Impedance.xlsx',1,'B26')
    xlsread('EpCo SUBJ008 Skin Impedance.xlsx',1,'B26')
    xlsread('EpCo SUBJ009 Skin Impedance.xlsx',1,'B26')
    xlsread('EpCo SUBJ010 Skin Impedance.xlsx',1,'B26')
    xlsread('EpCo SUBJ011 Skin Impedance.xlsx',1,'B26')
    xlsread('EpCo SUBJ012 Skin Impedance.xlsx',1,'B26')
    xlsread('EpCo SUBJ013 Skin Impedance.xlsx',1,'B26')
    xlsread('EpCo SUBJ014 Skin Impedance.xlsx',1,'B26')
    xlsread('EpCo SUBJ015 Skin Impedance.xlsx',1,'B26')
    xlsread('EpCo SUBJ016 Skin Impedance.xlsx',1,'B26')];
Tape3M_tf = [mean(xlsread('EpCo SUBJ003 Skin Impedance.xlsx',2,'B26:C26'))
    mean(xlsread('EpCo SUBJ004 Skin Impedance.xlsx',2,'B26:C26'))
    mean(xlsread('EpCo SUBJ005 Skin Impedance.xlsx',2,'B26:C26'))
    mean(xlsread('EpCo SUBJ006 Skin Impedance.xlsx',2,'B26:C26'))
    mean(xlsread('EpCo SUBJ007 Skin Impedance.xlsx',2,'B26:C26'))
    mean(xlsread('EpCo SUBJ008 Skin Impedance.xlsx',2,'B26:C26'))
    mean(xlsread('EpCo SUBJ009 Skin Impedance.xlsx',2,'B26:C26'))
    mean(xlsread('EpCo SUBJ010 Skin Impedance.xlsx',2,'B26:C26'))
    mean(xlsread('EpCo SUBJ011 Skin Impedance.xlsx',2,'B26:C26'))
    mean(xlsread('EpCo SUBJ012 Skin Impedance.xlsx',2,'B26:C26'))
    mean(xlsread('EpCo SUBJ013 Skin Impedance.xlsx',2,'B26:C26'))
    mean(xlsread('EpCo SUBJ014 Skin Impedance.xlsx',2,'B26:C26'))
    mean(xlsread('EpCo SUBJ015 Skin Impedance.xlsx',2,'B26:C26'))
    mean(xlsread('EpCo SUBJ016 Skin Impedance.xlsx',2,'B26:C26'))];
SA_tf = [mean(xlsread('EpCo SUBJ003 Skin Impedance.xlsx',3,'B26:C26'))
    mean(xlsread('EpCo SUBJ004 Skin Impedance.xlsx',3,'B26:C26'))
    mean(xlsread('EpCo SUBJ005 Skin Impedance.xlsx',3,'B26:C26'))
    mean(xlsread('EpCo SUBJ006 Skin Impedance.xlsx',3,'B26:C26'))
    mean(xlsread('EpCo SUBJ007 Skin Impedance.xlsx',3,'B26:C26'))
    mean(xlsread('EpCo SUBJ008 Skin Impedance.xlsx',3,'B26:C26'))
    mean(xlsread('EpCo SUBJ009 Skin Impedance.xlsx',3,'B26:C26'))
    mean(xlsread('EpCo SUBJ010 Skin Impedance.xlsx',3,'B26:C26'))
    mean(xlsread('EpCo SUBJ011 Skin Impedance.xlsx',3,'B26:C26'))
    mean(xlsread('EpCo SUBJ012 Skin Impedance.xlsx',3,'B26:C26'))
    mean(xlsread('EpCo SUBJ013 Skin Impedance.xlsx',3,'B26:C26'))
    mean(xlsread('EpCo SUBJ014 Skin Impedance.xlsx',3,'B26:C26'))
    mean(xlsread('EpCo SUBJ015 Skin Impedance.xlsx',3,'B26:C26'))
    mean(xlsread('EpCo SUBJ016 Skin Impedance.xlsx',3,'B26:C26'))];
uN_tf = [mean(xlsread('EpCo SUBJ003 Skin Impedance.xlsx',4,'B26:C26'))
    mean(xlsread('EpCo SUBJ004 Skin Impedance.xlsx',4,'B26:C26'))
    mean(xlsread('EpCo SUBJ005 Skin Impedance.xlsx',4,'B26:C26'))
    mean(xlsread('EpCo SUBJ006 Skin Impedance.xlsx',4,'B26:C26'))
    mean(xlsread('EpCo SUBJ007 Skin Impedance.xlsx',4,'B26:C26'))
    mean(xlsread('EpCo SUBJ008 Skin Impedance.xlsx',4,'B26:C26'))
    mean(xlsread('EpCo SUBJ009 Skin Impedance.xlsx',4,'B26:C26'))
    mean(xlsread('EpCo SUBJ010 Skin Impedance.xlsx',4,'B26:C26'))
    mean(xlsread('EpCo SUBJ011 Skin Impedance.xlsx',4,'B26:C26'))
    mean(xlsread('EpCo SUBJ012 Skin Impedance.xlsx',4,'B26:C26'))
    mean(xlsread('EpCo SUBJ013 Skin Impedance.xlsx',4,'B26:C26'))
    mean(xlsread('EpCo SUBJ014 Skin Impedance.xlsx',4,'B26:C26'))
    mean(xlsread('EpCo SUBJ015 Skin Impedance.xlsx',4,'B26:C26'))
    mean(xlsread('EpCo SUBJ016 Skin Impedance.xlsx',4,'B26:C26'))];

Z1k_tf = [NT_tf Tape3M_tf SA_tf uN_tf]
Z1k_tf_tbl= array2table(Z1k_tf, 'VariableNames', {'NT_tf', 'Tape3M_tf', 'SA_tf', 'uN_tf'});
clear('NT_tf', 'Tape3M_tf', 'SA_tf', 'uN_tf'); 

NT_tf = [xlsread('EpCo SUBJ003 Skin Impedance.xlsx',1,'B46')
    xlsread('EpCo SUBJ004 Skin Impedance.xlsx',1,'B46')
    xlsread('EpCo SUBJ005 Skin Impedance.xlsx',1,'B46')
    xlsread('EpCo SUBJ006 Skin Impedance.xlsx',1,'B46')
    xlsread('EpCo SUBJ007 Skin Impedance.xlsx',1,'B46')
    xlsread('EpCo SUBJ008 Skin Impedance.xlsx',1,'B46')
    xlsread('EpCo SUBJ009 Skin Impedance.xlsx',1,'B46')
    xlsread('EpCo SUBJ010 Skin Impedance.xlsx',1,'B46')
    xlsread('EpCo SUBJ011 Skin Impedance.xlsx',1,'B46')
    xlsread('EpCo SUBJ012 Skin Impedance.xlsx',1,'B46')
    xlsread('EpCo SUBJ013 Skin Impedance.xlsx',1,'B46')
    xlsread('EpCo SUBJ014 Skin Impedance.xlsx',1,'B46')
    xlsread('EpCo SUBJ015 Skin Impedance.xlsx',1,'B46')
    xlsread('EpCo SUBJ016 Skin Impedance.xlsx',1,'B46')];
Tape3M_tf = [mean(xlsread('EpCo SUBJ003 Skin Impedance.xlsx',2,'B46:C46'))
    mean(xlsread('EpCo SUBJ004 Skin Impedance.xlsx',2,'B46:C46'))
    mean(xlsread('EpCo SUBJ005 Skin Impedance.xlsx',2,'B46:C46'))
    mean(xlsread('EpCo SUBJ006 Skin Impedance.xlsx',2,'B46:C46'))
    mean(xlsread('EpCo SUBJ007 Skin Impedance.xlsx',2,'B46:C46'))
    mean(xlsread('EpCo SUBJ008 Skin Impedance.xlsx',2,'B46:C46'))
    mean(xlsread('EpCo SUBJ009 Skin Impedance.xlsx',2,'B46:C46'))
    mean(xlsread('EpCo SUBJ010 Skin Impedance.xlsx',2,'B46:C46'))
    mean(xlsread('EpCo SUBJ011 Skin Impedance.xlsx',2,'B46:C46'))
    mean(xlsread('EpCo SUBJ012 Skin Impedance.xlsx',2,'B46:C46'))
    mean(xlsread('EpCo SUBJ013 Skin Impedance.xlsx',2,'B46:C46'))
    mean(xlsread('EpCo SUBJ014 Skin Impedance.xlsx',2,'B46:C46'))
    mean(xlsread('EpCo SUBJ015 Skin Impedance.xlsx',2,'B46:C46'))
    mean(xlsread('EpCo SUBJ016 Skin Impedance.xlsx',2,'B46:C46'))];
SA_tf = [mean(xlsread('EpCo SUBJ003 Skin Impedance.xlsx',3,'B46:C46'))
    mean(xlsread('EpCo SUBJ004 Skin Impedance.xlsx',3,'B46:C46'))
    mean(xlsread('EpCo SUBJ005 Skin Impedance.xlsx',3,'B46:C46'))
    mean(xlsread('EpCo SUBJ006 Skin Impedance.xlsx',3,'B46:C46'))
    mean(xlsread('EpCo SUBJ007 Skin Impedance.xlsx',3,'B46:C46'))
    mean(xlsread('EpCo SUBJ008 Skin Impedance.xlsx',3,'B46:C46'))
    mean(xlsread('EpCo SUBJ009 Skin Impedance.xlsx',3,'B46:C46'))
    mean(xlsread('EpCo SUBJ010 Skin Impedance.xlsx',3,'B46:C46'))
    mean(xlsread('EpCo SUBJ011 Skin Impedance.xlsx',3,'B46:C46'))
    mean(xlsread('EpCo SUBJ012 Skin Impedance.xlsx',3,'B46:C46'))
    mean(xlsread('EpCo SUBJ013 Skin Impedance.xlsx',3,'B46:C46'))
    mean(xlsread('EpCo SUBJ014 Skin Impedance.xlsx',3,'B46:C46'))
    mean(xlsread('EpCo SUBJ015 Skin Impedance.xlsx',3,'B46:C46'))
    mean(xlsread('EpCo SUBJ016 Skin Impedance.xlsx',3,'B46:C46'))];
uN_tf = [mean(xlsread('EpCo SUBJ003 Skin Impedance.xlsx',4,'B46:C46'))
    mean(xlsread('EpCo SUBJ004 Skin Impedance.xlsx',4,'B46:C46'))
    mean(xlsread('EpCo SUBJ005 Skin Impedance.xlsx',4,'B46:C46'))
    mean(xlsread('EpCo SUBJ006 Skin Impedance.xlsx',4,'B46:C46'))
    mean(xlsread('EpCo SUBJ007 Skin Impedance.xlsx',4,'B46:C46'))
    mean(xlsread('EpCo SUBJ008 Skin Impedance.xlsx',4,'B46:C46'))
    mean(xlsread('EpCo SUBJ009 Skin Impedance.xlsx',4,'B46:C46'))
    mean(xlsread('EpCo SUBJ010 Skin Impedance.xlsx',4,'B46:C46'))
    mean(xlsread('EpCo SUBJ011 Skin Impedance.xlsx',4,'B46:C46'))
    mean(xlsread('EpCo SUBJ012 Skin Impedance.xlsx',4,'B46:C46'))
    mean(xlsread('EpCo SUBJ013 Skin Impedance.xlsx',4,'B46:C46'))
    mean(xlsread('EpCo SUBJ014 Skin Impedance.xlsx',4,'B46:C46'))
    mean(xlsread('EpCo SUBJ015 Skin Impedance.xlsx',4,'B46:C46'))
    mean(xlsread('EpCo SUBJ016 Skin Impedance.xlsx',4,'B46:C46'))];

Z10_tf = [NT_tf Tape3M_tf SA_tf uN_tf]
Z10_tf_tbl= array2table(Z1k_tf, 'VariableNames', {'NT_tf', 'Tape3M_tf', 'SA_tf', 'uN_tf'});
clear('NT_tf', 'Tape3M_tf', 'SA_tf', 'uN_tf'); 

for i=1:4 %--for each skin treatment
    
    avgZ1k_tf(i) = nanmean(Z1k_tf(:,i)); %--average 1 kHz impedance of all subjects
    stdZ1k_tf(i) = nanstd(Z1k_tf(:,i)); %--std. dev. 1 kHz impedance of all subjects
    
    avgZ10_tf(i) = nanmean(Z10_tf(:,i)); %--average 10 Hz impedance of all subjects
    stdZ10_tf(i) = nanstd(Z10_tf(:,i)); %--std. dev. 10 Hz impedance of all subjects
    
end; clear i;

[avgZ1k_tf; stdZ1k_tf] %--avg. +/- std. dev. for each treatment, across all subjects
[avgZ10_tf; stdZ10_tf] %--avg. +/- std. dev. for each treatment, across all subjects