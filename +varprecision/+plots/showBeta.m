function showBeta(varargin)
%SHOWBETA shows the fit beta for model XP,XPG,XPVP,XPVPG

exp = fetch(varprecision.Experiment & varargin);
fig = Figure(exp.exp_id,'size',[80,40]);

models = {'XP','XPG','XPVP','XPVPG'};

beta_vec_mean = zeros(1,length(models));
beta_vec_sem = zeros(1,length(models));
for ii = 1:length(models)
    model = ['model_name="' models{ii} '"'];
    beta_hat = fetchn(varprecision.FitParsEviBpsBest & model & exp, 'beta_hat');
    [beta_vec_mean(ii),beta_vec_sem(ii)] = varprecision.utils.getMeanStd(beta_hat,'sem');
end

bar(beta_vec_mean); hold on
errorbar(beta_vec_mean,beta_vec_sem,'LineStyle','None')
ylim([0,4])
set(gca,'xTickLabel',models)
ylabel('beta hat')
title(['Exp' num2str(exp.exp_id)])

fig.cleanup
