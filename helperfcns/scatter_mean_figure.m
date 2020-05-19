function scatter_mean_figure(data, cols, sig_gp, sigs, alpha)
    
[N,gp]= size(data); 

for g= 1:gp
    scatter(g*ones(1,N), data(:,g), [], cols(g,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.2)
     hold on
    plot([g-.25, g+.25], ones(1,2)*mean(data(:,g)), 'color', 'black', 'linewidth', 1)
    plot([g, g], mean(data(:,g))+[-std(data(:,g)),std(data(:,g))] , 'color', 'black', 'linewidth', .5)
end
xticks([1:gp])
xlim([.5,gp+.5])

% i_triu = find(triu(ones(gp)));
% [I,J] = ind2sub([gp,gp],i_triu); inds = [I(:), J(:)];
% sig_gp = arrayfun(@(x)inds(x,:), (1:length(inds)), 'UniformOutput', false);

i_sg= sigs <alpha; 

if ~isempty(sigs)
    sigstar(sig_gp(i_sg),  sigs(i_sg))
end

end
