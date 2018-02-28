function showLFPRIndOptAllModels(exp,type)
%SHOWEVIFACTOR shows the factor evidence for individual experiment, but for
%all models including suboptimal ones
%   function showEviFactor(type)
%   type specifies the type of evidences, should be one of the following: aic, bic, aicc, llmax

if ~exist('type','var')
    type = 'aic';
end
exps = fetch(varprecision.Experiment & exp);
subjs = fetch(varprecision.Subject & 'subj_type="real"');

for iexp = exps'
        
    records = fetch(varprecision.Recording & iexp & subjs);

    eviMat = cell(5,2);

    switch type
        case 'aic'
            [eviMat{1,1},eviMat{2,1},eviMat{3,1},eviMat{4,1},eviMat{5,1}] = fetchn(varprecision.EviFactor & records, 'g_lfpr_aic','o_lfpr_aic','d_lfpr_aic','v_lfpr_aic','ov_lfpr_aic');
            [eviMat{1,2},eviMat{2,2},eviMat{3,2},eviMat{4,2},eviMat{5,2}] = fetchn(varprecision.FactorPosteriorAllModels & records, 'g_lfpr_aic','o_lfpr_aic','d_lfpr_aic','v_lfpr_aic','ov_lfpr_aic');
        case 'bic'
            [eviMat{1,1},eviMat{2,1},eviMat{3,1},eviMat{4,1},eviMat{5,1}] = fetchn(varprecision.EviFactor & records, 'g_lfpr_bic','o_lfpr_bic','d_lfpr_bic','v_lfpr_bic','ov_lfpr_bic');
            [eviMat{1,2},eviMat{2,2},eviMat{3,2},eviMat{4,2},eviMat{5,2}] = fetchn(varprecision.FactorPosteriorAllModels & records, 'g_lfpr_bic','o_lfpr_bic','d_lfpr_bic','v_lfpr_bic','ov_lfpr_bic');
        case 'aicc'
            [eviMat{1,1},eviMat{2,1},eviMat{3,1},eviMat{4,1},eviMat{5,1}] = fetchn(varprecision.EviFactor & records, 'g_lfpr_aicc','o_lfpr_aicc','d_lfpr_aicc','v_lfpr_aicc','ov_lfpr_aicc');
            [eviMat{1,2},eviMat{2,2},eviMat{3,2},eviMat{4,2},eviMat{5,2}] = fetchn(varprecision.FactorPosteriorAllModels & records, 'g_lfpr_aicc','o_lfpr_aicc','d_lfpr_aicc','v_lfpr_aicc','ov_lfpr_aicc');
        case 'llmax'
            [eviMat{1,1},eviMat{2,1},eviMat{3,1},eviMat{4,1},eviMat{5,1}] = fetchn(varprecision.EviFactor & records, 'g_lfpr_llmax','o_lfpr_llmax','d_lfpr_llmax','v_lfpr_llmax','ov_lfpr_llmax');
            [eviMat{1,2},eviMat{2,2},eviMat{3,2},eviMat{4,2},eviMat{5,2}] = fetchn(varprecision.FactorPosteriorAllModels & records, 'g_lfpr_llmax','o_lfpr_llmax','d_lfpr_llmax','v_lfpr_llmax','ov_lfpr_llmax');
    end
    
    eviMat = cellfun(@(x)2*x, eviMat, 'Un', 0);

    fig = Figure(101,'size',[60,40]); hold on

    groupbar(eviMat)

    set(gca, 'xTick',[1,2,3,4,5],'xTickLabel',{'G','O','D','V','O+V'})
    
    if iexp.exp_id==9
        set(gca,'yTick',-20:20:60)
        ylim([-20,60])
    else
        set(gca,'yTick',-20:20:80)
        ylim([-20,80])
    end


    xLim = get(gca, 'xLim'); hold on
    plot([xLim(1),xLim(2)],[6.8,6.8],'k--')
    plot([xLim(1),xLim(2)],[9.21,9.21],'k--')
    plot([xLim(1),xLim(2)],[4.605,4.605],'k--')
    xlabel('Factor')
    ylabel('2xLFLP')
    

    fig.cleanup
    fig.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(iexp.exp_id) '_LFLP_OptAll_' type]);

    
end