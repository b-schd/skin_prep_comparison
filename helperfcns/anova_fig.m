function f= anova_fig(data, data_tbl, multcmp, level)

% Get measures names
meas= data_tbl.Properties.VariableNames; 

% Set color scheme
cols= parula;

f= figure(1); clf; hold on

% Scatter plot of data, separate into categories if level is included
if nargin > 3
    
    cats= unique(data_tbl.(level)); 
    x_disp=linspace(-.1,.1, length(cats));
    for i_cat=1:length(cats)
        d_split= data(strcmp(cats(i_cat), data_tbl.(level)),:);
        xx= repmat([1:size(data,2)],length(d_split),1)+normrnd(x_disp(i_cat),.01,size(d_split));
        yy= d_split;
        plot(xx(:), yy(:),'o', 'color', 1-ones(1,3)*i_cat/length(cats), 'markersize', 5)
    end
    legend(cats)
    
else
    
plot(repmat([1:size(data,2)],length(data),1)+normrnd(0,.05,size(data)), ...
data, 'o', 'color', ones(1,3)*.5, 'markersize', 5)

% Get significance levels
sig_p= find(multcmp.pValue <= 0.05); 
[p_row, p_ind]=unique(sort(table2array(multcmp(sig_p, (1:2))), 2),'rows'); 
sigstar(num2cell(p_row,2), multcmp.pValue(sig_p(p_ind)))

end

h=boxplot(data, 'Colors', cols(1:10:size(data,2)*10,:)); set(h,{'linew'},{1.5})

xticklabels(meas);
y_lim= get(gca, 'Ylim'); ylim([y_lim(1), y_lim(2)*1.1])

set(gcf, 'Position', [484   665   440   266])

end