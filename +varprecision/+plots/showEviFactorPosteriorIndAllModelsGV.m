function showEviFactorPosteriorIndAllModelsGV(exp,type)
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
    
    eviMat = zeros(length(records),2);
    
    switch type
        case 'aic'
            [eviMat(:,1),eviMat(:,2)] = fetchn(varprecision.FactorPosteriorAllModels & records, 'guess_aic','var_aic');
        case 'bic'
            [eviMat(:,1),eviMat(:,2)] = fetchn(varprecision.FactorPosteriorAllModels & records, 'guess_bic','var_bic');
        case 'aicc'
            [eviMat(:,1),eviMat(:,2)] = fetchn(varprecision.FactorPosteriorAllModels & records, 'guess_aicc','var_aicc');
        case 'llmax'
            [eviMat(:,1),eviMat(:,2)] = fetchn(varprecision.FactorPosteriorAllModels & records, 'guess_llmax','var_llmax');
    end
    
    mean_evi = mean(eviMat);
    sem_evi = std(eviMat)./sqrt(length(records));
    
    fig = Figure(101,'size',[55,30]); hold on
    bar(mean_evi,'FaceColor','w');
    errorbar(mean_evi,sem_evi,'k','LineStyle','None')
    set(gca, 'xTick',[1,2,3,4,5],'xTickLabel',{'G','D','O','V','O+V'}, 'yTick',0:0.2:1)
    xLim = get(gca, 'xlim');
%     plot([xLim(1),xLim(2)],[0.269,0.269],'k--')
    plot([xLim(1),xLim(2)],[0.5,0.5],'k-.')
     
    xlabel('Factor')
    ylabel('Posterior probability')
    
    ylim([0,1])
   
    
    fig.cleanup
    fig.save(['~/Dropbox/VR/+varprecision/figures/aic_factor_posterior_exp' num2str(iexp.exp_id) '_all_models_GV']);
    
end