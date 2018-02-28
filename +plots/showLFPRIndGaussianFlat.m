function showLFPRIndGaussianFlat(type)


if ~exist('type','var')
    type = 'aic';
end
exp_res = fetch(varprecision.Experiment & 'exp_id=4');
subjs = fetch(varprecision.Subject & 'subj_type="real"');


records = fetch(varprecision.Recording & exp_res & subjs);

eviMat = cell(5,2);

switch type
    case 'aic'
        [eviMat{1,1},eviMat{2,1},eviMat{3,1},eviMat{4,1},eviMat{5,1}] = fetchn(varprecision.EviFactor & records, 'g_lfpr_aic','o_lfpr_aic','d_lfpr_aic','v_lfpr_aic','ov_lfpr_aic');
        [eviMat{1,2},eviMat{2,2},eviMat{3,2},eviMat{4,2},eviMat{5,2}] = fetchn(varprecision.EviFactorFlat & records, 'g_lfpr_aic','o_lfpr_aic','d_lfpr_aic','v_lfpr_aic','ov_lfpr_aic');
    case 'bic'
        [eviMat{1,1},eviMat{2,1},eviMat{3,1},eviMat{4,1},eviMat{5,1}] = fetchn(varprecision.EviFactor & records, 'g_lfpr_bic','o_lfpr_bic','d_lfpr_bic','v_lfpr_bic','ov_lfpr_bic');
        [eviMat{1,2},eviMat{2,2},eviMat{3,2},eviMat{4,2},eviMat{5,2}] = fetchn(varprecision.EviFactorFlat & records, 'g_lfpr_bic','o_lfpr_bic','d_lfpr_bic','v_lfpr_bic','ov_lfpr_bic');
    case 'aicc'
        [eviMat{1,1},eviMat{2,1},eviMat{3,1},eviMat{4,1},eviMat{5,1}] = fetchn(varprecision.EviFactor & records, 'g_lfpr_aicc','o_lfpr_aicc','d_lfpr_aicc','v_lfpr_aicc','ov_lfpr_aicc');
        [eviMat{1,2},eviMat{2,2},eviMat{3,2},eviMat{4,2},eviMat{5,2}] = fetchn(varprecision.EviFactorFlat & records, 'g_lfpr_aicc','o_lfpr_aicc','d_lfpr_aicc','v_lfpr_aicc','ov_lfpr_aicc');
    case 'llmax'
        [eviMat{1,1},eviMat{2,1},eviMat{3,1},eviMat{4,1},eviMat{5,1}] = fetchn(varprecision.EviFactor & records, 'g_lfpr_llmax','o_lfpr_llmax','d_lfpr_llmax','v_lfpr_llmax','ov_lfpr_llmax');
        [eviMat{1,2},eviMat{2,2},eviMat{3,2},eviMat{4,2},eviMat{5,2}] = fetchn(varprecision.EviFactorFlat & records, 'g_lfpr_llmax','o_lfpr_llmax','d_lfpr_llmax','v_lfpr_llmax','ov_lfpr_llmax');
end


fig = Figure(101,'size',[60,40]); hold on

eviMat = cellfun(@(x)2*x, eviMat, 'Un', 0);

groupbar(eviMat)

set(gca, 'xTick',[1,2,3,4,5],'xTickLabel',{'G','O','D','V','O+V'}, 'yTick',-20:10:20)


xLim = get(gca, 'xLim'); hold on
plot([xLim(1),xLim(2)],[6.8,6.8],'k--')
plot([xLim(1),xLim(2)],[9.21,9.21],'k--')
plot([xLim(1),xLim(2)],[4.605,4.605],'k--')

xlabel('Factor')
ylabel('2xLFLP')
ylim([-20,20])

fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(exp_res.exp_id) '_LFLP_Gauss_flat_' type]);
