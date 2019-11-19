function showEviFactorPosteriorAllExps(type)
%SHOWEVIFACTORLIKELIHOODALLEXPS factor posterior of each factor for all
%exps

[ori_aicMat, ori_bicMat] = fetchn(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name in ("OP","OPN","OPG","OPGN","OPVP","OPVPN","OPVPG","OPVPGN")','aic','bic');
[non_ori_aicMat, non_ori_bicMat] = fetchn(varprecision.FitParsEviBpsBestAvgAllExps  & 'model_name in ("CP","CPN","CPG","CPGN","VP","VPN","VPG","VPGN")','aic','bic');
[var_aicMat, var_bicMat] = fetchn(varprecision.FitParsEviBpsBestAvgAllExps  & 'model_name in ("VP","VPN","VPG","VPGN","OPVP","OPVPN","OPVPG","OPVPGN")','aic','bic');
[non_var_aicMat, non_var_bicMat] = fetchn(varprecision.FitParsEviBpsBestAvgAllExps  & 'model_name in ("CP","CPN","CPG","CPGN","OP","OPN","OPG","OPGN")','aic','bic');
[guess_aicMat, guess_bicMat] = fetchn(varprecision.FitParsEviBpsBestAvgAllExps  & 'model_name in ("CPG","CPGN","VPG","VPGN","OPG","OPGN","OPVPG","OPVPGN")','aic','bic');
[non_guess_aicMat, non_guess_bicMat] = fetchn(varprecision.FitParsEviBpsBestAvgAllExps  & 'model_name in ("CP","CPN","VP","VPN","OP","OPN","OPVP","OPVPN")','aic','bic');
[dn_aicMat, dn_bicMat] = fetchn(varprecision.FitParsEviBpsBestAvgAllExps  & 'model_name in ("CPN","CPGN","VPN","VPGN","OPN","OPGN","OPVPN","OPVPGN")','aic','bic');
[non_dn_aicMat, non_dn_bicMat] = fetchn(varprecision.FitParsEviBpsBestAvgAllExps  & 'model_name in ("CP","CPG","VP","VPG","OP","OPG","OPVP","OPVPG")','aic','bic');
[total_var_aicMat, total_var_bicMat] = fetchn(varprecision.FitParsEviBpsBestAvgAllExps  & 'model_name in ("OPVP","OPVPN","OPVPG","OPVPGN")','aic','bic');
[non_total_var_aicMat, non_total_var_bicMat] = fetchn(varprecision.FitParsEviBpsBestAvgAllExps  & 'model_name in ("CP","CPN","CPG","CPGN")','aic','bic');
            
            
% aic 
min_val = min(min(ori_aicMat),min(non_ori_aicMat));
res_ori_aicMat = ori_aicMat - min_val;
res_non_ori_aicMat = non_ori_aicMat - min_val;

res_var_aicMat = var_aicMat - min_val; 
res_non_var_aicMat = non_var_aicMat - min_val;

res_guess_aicMat = guess_aicMat - min_val;
res_non_guess_aicMat = non_guess_aicMat - min_val;

res_dn_aicMat = dn_aicMat - min_val;
res_non_dn_aicMat = non_dn_aicMat - min_val;

res_total_var_aicMat = total_var_aicMat - min_val;
res_non_total_var_aicMat = non_total_var_aicMat - min_val;

ori_aic_ratio = mean(exp(-res_ori_aicMat))/(mean(exp(-res_non_ori_aicMat)));
ori_aic = ori_aic_ratio/(ori_aic_ratio+1);

var_aic_ratio = mean(exp(-res_var_aicMat))/(mean(exp(-res_non_var_aicMat)));
var_aic = var_aic_ratio/(var_aic_ratio+1);

guess_aic_ratio = mean(exp(-res_guess_aicMat))/(mean(exp(-res_non_guess_aicMat)));
guess_aic = guess_aic_ratio/(guess_aic_ratio+1);

dn_aic_ratio = mean(exp(-res_dn_aicMat))/(mean(exp(-res_non_dn_aicMat)));
dn_aic = dn_aic_ratio/(dn_aic_ratio+1);

total_var_aic_ratio = mean(exp(-res_total_var_aicMat))/(mean(exp(-res_non_total_var_aicMat)));
total_var_aic = total_var_aic_ratio/(total_var_aic_ratio+1);

% bic 
min_val = min(min(ori_bicMat),min(non_ori_bicMat));
res_ori_bicMat = ori_bicMat - min_val;
res_non_ori_bicMat = non_ori_bicMat - min_val;

res_var_bicMat = var_bicMat - min_val; 
res_non_var_bicMat = non_var_bicMat - min_val;

res_guess_bicMat = guess_bicMat - min_val;
res_non_guess_bicMat = non_guess_bicMat - min_val;

res_dn_bicMat = dn_bicMat - min_val;
res_non_dn_bicMat = non_dn_bicMat - min_val;

res_total_var_bicMat = total_var_bicMat - min_val;
res_non_total_var_bicMat = non_total_var_bicMat - min_val;

ori_bic_ratio = mean(exp(-res_ori_bicMat))/(mean(exp(-res_non_ori_bicMat)));
ori_bic = ori_bic_ratio/(ori_bic_ratio+1);

var_bic_ratio = mean(exp(-res_var_bicMat))/(mean(exp(-res_non_var_bicMat)));
var_bic = var_bic_ratio/(var_bic_ratio+1);

guess_bic_ratio = mean(exp(-res_guess_bicMat))/(mean(exp(-res_non_guess_bicMat)));
guess_bic = guess_bic_ratio/(guess_bic_ratio+1);

dn_bic_ratio = mean(exp(-res_dn_bicMat))/(mean(exp(-res_non_dn_bicMat)));
dn_bic = dn_bic_ratio/(dn_bic_ratio+1);

total_var_bic_ratio = mean(exp(-res_total_var_bicMat))/(mean(exp(-res_non_total_var_bicMat)));
total_var_bic = total_var_bic_ratio/(total_var_bic_ratio+1);



switch type
    case 'aic'
        eviMat = [guess_aic,ori_aic,dn_aic,var_aic,total_var_aic];
    case 'bic'
        eviMat = [guess_bic,ori_bic,dn_bic,var_bic,total_var_bic];
end

fig = Figure(101,'size',[55,30]); hold on
bar(eviMat,'FaceColor','w');
set(gca, 'xTick',[1,2,3,4,5],'xTickLabel',{'G','O','D','V','O+V'}, 'yTick',0:0.2:1)

xlabel('Factor')
ylabel('Posterior probability')

ylim([0,1])
set(gca,'YTick',0:0.2:1)

fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/aic_factor_likelihood_all_exps_' type]);