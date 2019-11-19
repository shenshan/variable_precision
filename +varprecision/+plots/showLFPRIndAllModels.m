function showLFPRIndAllModels(exp,type)
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
    
    eviMat = zeros(length(records),5);
    
    switch type
        case 'aic'
            [eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4),eviMat(:,5)] = fetchn(varprecision.FactorPosteriorAllModels & records, 'g_lfpr_aic','o_lfpr_aic','d_lfpr_aic','v_lfpr_aic','ov_lfpr_aic');
        case 'bic'
            [eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4),eviMat(:,5)] = fetchn(varprecision.FactorPosteriorAllModels & records, 'g_lfpr_bic','o_lfpr_bic','d_lfpr_bic','v_lfpr_bic','ov_lfpr_bic');
        case 'aicc'
            [eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4),eviMat(:,5)] = fetchn(varprecision.FactorPosteriorAllModels & records, 'g_lfpr_aicc','o_lfpr_aicc','d_lfpr_aicc','v_lfpr_aicc','ov_lfpr_aicc');
        case 'llmax'
            [eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4),eviMat(:,5)] = fetchn(varprecision.FactorPosteriorAllModels & records, 'g_lfpr_llmax','o_lfpr_llmax','d_lfpr_llmax','v_lfpr_llmax','ov_lfpr_llmax');
    end
    
    mean_evi = mean(2*eviMat)
    sem_evi = std(2*eviMat)./sqrt(length(records))
    
    fig = Figure(101,'size',[55,30]); hold on
    bar(mean_evi,'FaceColor','w');
    errorbar(mean_evi,sem_evi,'k','LineStyle','None')
    set(gca, 'xTick',[1,2,3,4,5],'xTickLabel',{'G','O','D','V','O+V'}, 'yTick',-20:20:80)

    
    xLim = get(gca, 'xLim');
    plot([xLim(1),xLim(2)],[6.8,6.8],'k--')
    plot([xLim(1),xLim(2)],[9.21,9.21],'k--')
    plot([xLim(1),xLim(2)],[4.6,4.6],'k--')

    xlabel('Factor')
    ylabel('2*LFLP')
    ylim([-20,60])
    
    fig.cleanup
    fig.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(iexp.exp_id) '_LFRP_all_models_' type]);
    
end