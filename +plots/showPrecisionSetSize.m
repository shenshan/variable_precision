function showPrecisionSetSize(exp,model)
%SHOWPRECISIONSETSIZE shows the encoding precision as a function of set size
%   function showPrecisionSetSize(exp,model)
subjs = fetch(varprecision.Subject & 'subj_type="real"');
J_bar = fetchn(varprecision.FitParametersEvidence & exp & model & subjs, 'lambda_hat');

setsize = fetch1(varprecision.Experiment & exp, 'setsize');

J_bar = squeeze(varprecision.utils.decell(J_bar));

[mean_Jbar, sem_Jbar] = varprecision.utils.getMeanStd(J_bar,'sem',2);

fig = Figure(101,'size',[60,40]);
errorbar(setsize, mean_Jbar,sem_Jbar)
% ylim([0,1]);

fig.cleanup






