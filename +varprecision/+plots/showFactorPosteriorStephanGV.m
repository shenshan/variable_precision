function showFactorPosteriorStephanGV
%SHOWEVIFACTOR shows the factor evidence for all experiments
%   function showFactorPosteriorAll(type)

exp_ids = [1,8,2:5,9,10,6,7,11];
eviMat = cell(length(exp_ids),2);

for ii = 1:length(exp_ids)
    exp_id = exp_ids(ii);
    exp = fetch(varprecision.Experiment & ['exp_id =' num2str(exp_id)]);

    [eviMat{ii,1},eviMat{ii,2}] = fetch1(varprecision.BmcGroupGV & exp, 'fpp_g','fpp_v');
   
end

eviMat = cellfun(@(x) x/(1-x), eviMat,'Un',0);

fig = Figure(101,'size',[150,40]);

groupbar(eviMat); hold on

ylim([0,5])
% set(gca,'YTick',0:0.2:1)
xLim = get(gca, 'xLim');
plot([xLim(1),xLim(2)],[1,1],'k--')

xlabel('Experiment number')
ylabel('Posterior probability')


% legend('G','O','D','V','O+V','location','southeast')

fig.cleanup

fig.save('~/Dropbox/VR/+varprecision/figures/evi_factor_posterior_stephan_GV')