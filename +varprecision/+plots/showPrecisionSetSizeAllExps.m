function showPrecisionSetSizeAllExps(model_res,varargin)
%SHOWPRECISIONSETSIZE shows the encoding precision as a function of set
%size for all experiments
%   function showPrecisionSetSize(model,varargin)
subjs = fetch(varprecision.Subject & 'subj_type="real"');

exp_ids = [3,5,10,7,11];

fig = Figure(101,'size',[60,40]); hold on
colors = get(gca, 'ColorOrder');

for iexp = 1:length(exp_ids)
    exp = fetch(varprecision.Experiment & ['exp_id=' num2str(exp_ids(iexp))]);
    J_bar = fetchn(varprecision.FitParsEviBpsBestAvg & exp & model_res & subjs & varargin, 'lambda_hat');
    model = fetch(varprecision.Model & model_res & exp);
    factor_code = fetch1(varprecision.Model & model,'factor_code');
    setsize = fetch1(varprecision.Experiment & exp, 'setsize');
    J_bar = squeeze(varprecision.utils.decell(J_bar));
    [mean_Jbar, sem_Jbar] = varprecision.utils.getMeanStd(J_bar,'sem',2);

    plot(setsize,mean_Jbar,'Color',colors(iexp,:),'Marker','.')
    errorbar(setsize, mean_Jbar,sem_Jbar,'Color',colors(iexp,:))
end
ylim([0,0.6]);
xlim([0,10]);
set(gca,'XTick',[1,2,3,4,8], 'YTick', 0:0.2:0.6)
xlabel('Set size')

legend('Exp4','Exp6','Exp8','Exp10','Exp11')
if isempty(strfind(factor_code, 'V'))
    ylabel('Precision')
else
    ylabel('Mean precision')
end

fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/jbar_ss_' model(1).model_name '_all exps.eps'])
