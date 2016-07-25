function showPrecisionSetSize(exp,model,varargin)
%SHOWPRECISIONSETSIZE shows the encoding precision as a function of set size
%   function showPrecisionSetSize(exp,model)
subjs = fetch(varprecision.Subject & 'subj_type="real"');
J_bar = fetchn(varprecision.FitParametersEvidence & exp & model & subjs & varargin, 'lambda_hat');

exp = fetch(varprecision.Experiment & exp);
model = fetch(varprecision.Model & model);

setsize = fetch1(varprecision.Experiment & exp, 'setsize');

J_bar = squeeze(varprecision.utils.decell(J_bar));

[mean_Jbar, sem_Jbar] = varprecision.utils.getMeanStd(J_bar,'sem',2);

fig = Figure(101,'size',[60,40]);
if exp.exp_id > 6
    mean_Jbar = 4*mean_Jbar*pi^2/180^2;
    sem_Jbar = 4*sem_Jbar*pi^2/180^2;
end
errorbar(setsize, mean_Jbar,sem_Jbar,'k')

ylim([0,0.5]);
xlim([0,10]);
set(gca,'XTick',[1,2,3,4,8])
xlabel('Set size')
ylabel('Mean precision')

fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(exp.exp_id) '_jbar_ss_' model(1).model_name '.eps'])





