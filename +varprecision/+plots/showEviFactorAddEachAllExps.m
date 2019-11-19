function showEviFactorAddEachAllExps(type)
%SHOWEVIFACTORREMOVEALLEXPS shows the knock-in analysis results for all experiments

[cp_aic, cp_bic] = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name="CP"','aic','bic');
[cpg_aic, cpg_bic] = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name="CPG"','aic','bic');
[cpn_aic, cpn_bic] = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name="CPN"','aic','bic');
[op_aic, op_bic] = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name="OP"','aic','bic');
[vp_aic, vp_bic] = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name="VP"','aic','bic');
[opvp_aic, opvp_bic] = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name="opvp"','aic','bic');

switch type
    case 'aic'
        eviMat = 2*[cpg_aic - cp_aic, op_aic - cp_aic, cpn_aic - cp_aic, vp_aic - cp_aic, opvp_aic - cp_aic];
    case 'bic'
        eviMat = 2*[cpg_bic - cp_bic, op_bic - cp_bic, cpn_bic - cp_bic, vp_bic - cp_bic, opvp_bic - cp_bic];
end

 fig = Figure(101,'size',[55,30]); hold on
bar(eviMat,'FaceColor','w');

set(gca, 'xTick',[1,2,3,4,5],'xTickLabel',{'+G','+O','+D','+V','+O+V'})
xlabel('Factor')
ylabel('AIC difference')

fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/' type '_aic_factor_add_each']);