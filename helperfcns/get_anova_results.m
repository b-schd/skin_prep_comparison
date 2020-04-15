function [stats, multcmp]= get_anova_results(data, data_tbl, test_type, level)

if nargin < 4
    level= [];
end

% measure names
meas= data_tbl.Properties.VariableNames(1:size(data,2)); 
Meas = table([1:size(data,2)]','VariableNames',{'Measurements'});

% Throw out rows with Nans
fprintf('Removing %d rows due to NaNs \n', sum(any(isnan(data),2)))
data_tbl(any(isnan(data),2),:)=[];
data(any(isnan(data),2),:)=[];

% Throw out rows with outliers
mthd='quartiles';
fprintf('Removing %d rows due to outliers \n', sum(any(isoutlier(data, mthd),2)))
data_tbl(any(isoutlier(data, mthd),2),:)=[];
data(any(isoutlier(data, mthd),2),:)=[];

% Anova Assumptions: 
% Test that variances are equal across groups (Bartlett's test)
p_vartest= vartestn(data, 'display', 'off')

switch(test_type)
    
    % One Way ANOVA across all measures
    case 'anova1'                                                           
        [p, tbl, stats]= anova1(data, meas,'off')
        multcmp= multcompare(stats); 
        
    % Within subjects repeated measures design    
    case 'rm_anova'                                                         
        rm = fitrm(data_tbl, sprintf('%s-%s~1', meas{1}, meas{length(meas)}), 'WithinDesign', Meas);
        stats= ranova(rm); ranova_pval= stats.pValue(1); 
        multcmp= multcompare(rm, 'Measurements');                           % Mult. Comparisons with HSD
       
        m_tbl= mauchly(rm);                                                 % Mauchly test of sphericity
        if m_tbl.pValue < 0.05
            fprintf(['The assumption of sphericity is violated (Mauchly''s Test), ',...
                'chi^2(%d) = %.02f, p < %.02f, and therefore,',...
            'a Greenhouse-Geisser correction is used.\n'],m_tbl.DF, m_tbl.ChiStat, m_tbl.pValue)
            ranova_pval= stats.pValueGG; 
        end
        
        fprintf('F(%d, %d)= %.02f, p= %.03f \n', length(data), stats.DF(1), stats.F(1), ranova_pval)
        
    % Grouped within-subjects repeated measures design
    case 'rm_anova_level' 
        
        rm = fitrm(data_tbl, sprintf('%s-%s~%s', meas{1}, meas{length(meas)}, level), 'WithinDesign', Meas);
        stats= ranova(rm); interact_pval= stats.pValue(2);   
        multcmp= multcompare(rm, level, 'By', 'Measurements');              % simple effect with HSD
        
        fprintf('Interaction between measurements and %s: F(%d, %d)= %.02f, p= %.3g \n',...
        level, length(data), stats.DF(2), stats.F(2), interact_pval)

    % Non parametric Within subjects repeated measures design      
    case 'friedman' 
        [p_fried, tbl_fried, stats]= friedman(data);
        multcmp= multcompare(stats);
    otherwise
        disp('Unknown test type')
end

anova_fig(data, data_tbl, multcmp, level);
    
end
        
