function showEviFactorRemoveAllExps(type)
%SHOWEVIFACTORREMOVEALLEXPS shows the lesion analysis results for all experiments

[opvpgn_aic, opvpgn_bic] = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name="OPVPGN"','aic','bic');
[opvpn_aic, opvpn_bic] = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name="OPVPN"','aic','bic');
[opvpg_aic, opvpg_bic] = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name="OPVPG"','aic','bic');
[vpgn_aic, vpgn_bic] = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name="VPGN"','aic','bic');
[opgn_aic, opgn_bic] = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name="OPGN"','aic','bic');
[cpgn_aic, cpgn_bic] = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name="CPGN"','aic','bic');

switch type
    case 'aic'
        eviMat = 2*[opvpn_aic - opvpgn_aic, vpgn_aic - opvpgn_aic, opvpg_aic - opvpgn_aic, opgn_aic - opvpgn_aic, cpgn_aic - opvpgn_aic];
    case 'bic'
        eviMat = 2*[opvpn_bic - opvpgn_bic, vpgn_bic - opvpgn_bic, opvpg_bic - opvpgn_bic, opgn_bic - opvpgn_bic, cpgn_bic - opvpgn_bic];
end

 
fig = Figure(101,'size',[55,30]); hold on
bar(eviMat,'FaceColor','w');

set(gca, 'xTick',[1,2,3,4,5],'xTickLabel',{'-G','-O','-D','-V','-O-V'})
xlabel('Factor')
ylabel('AIC difference')

fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/' type '_factor_remove']);