function showPrecisionSetSize(exp,model,varargin)
%SHOWPRECISIONSETSIZE shows the encoding precision as a function of set size
%   function showPrecisionSetSize(exp,model)
subjs = fetch(varprecision.Subject & 'subj_type="real"');
J_bar = fetchn(varprecision.FitParsEviBpsBestAvg & exp & model & subjs & varargin, 'lambda_hat');

exp = fetch(varprecision.Experiment & exp);
model = fetch(varprecision.Model & model & exp);
factor_code = fetch1(varprecision.Model & model,'factor_code');

setsize = fetch1(varprecision.Experiment & exp, 'setsize');

J_bar = squeeze(varprecision.utils.decell(J_bar));

[mean_Jbar, sem_Jbar] = varprecision.utils.getMeanStd(J_bar,'sem',2);

fig = Figure(101,'size',[60,40]); hold on

plot(setsize,mean_Jbar,'k.')
errorbar(setsize, mean_Jbar,sem_Jbar,'k')

ylim([0,0.6]);
xlim([0,10]);
set(gca,'XTick',[1,2,3,4,8], 'YTick', 0:0.2:0.6)
xlabel('Set size')

if isempty(strfind(factor_code, 'V'))
    ylabel('Precision')
else
    ylabel('Mean precision')
end

fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(exp.exp_id) '_jbar_ss_' model(1).model_name '.eps'])

mean_Jbar
sem_Jbar

mean_Jbar*90^2/pi^2

p = anova1(J_bar')

fig2 = Figure(102,'size',[60,40]);

errorbar(setsize, mean_Jbar'.*setsize,sem_Jbar'.*setsize,'k')

ylim([0,1.5]);
if exp.exp_id == 7
    ylim([0,0.5])
end
xlim([0,10]);

if exp.exp_id == 7
    set(gca,'XTick',[1,2,3,4,8], 'YTick', 0:0.1:0.5)
else
    set(gca,'XTick',[1,2,3,4,8], 'YTick', 0:0.5:1.5)
end

xlabel('Set size')
ylabel('Total mean precision')

fig2.cleanup
fig2.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(exp.exp_id) '__total_jbar_ss_' model(1).model_name '.eps'])
