function showEviFactorAddInd(exp, type)
%SHOWEVIFACTORAddInd shows the factor evidence for individual experiments
%   function showEviFactor(exp, type)
%   exp specifies the experiment number, type specifies the type of evidences, should be one of the following: aic, bic, aicc, llmax

exps = fetch(varprecision.Experiment & exp);
subjs = fetch(varprecision.Subject & 'subj_type="real"');

for iexp = exps'
        
    records = fetch(varprecision.Recording & iexp & subjs);
    
    eviMat = zeros(length(records),3);
    
    switch type
        case 'aic'
            [eviMat(:,1),eviMat(:,2),eviMat(:,3)] = fetchn(varprecision.EviFactorAdd & records, 'guess_aic','ori_aic','var_aic');
            eviMat = -eviMat*2;
        case 'bic'
            [eviMat(:,1),eviMat(:,2),eviMat(:,3)] = fetchn(varprecision.EviFactorAdd & records, 'guess_bic','ori_bic','var_bic');
            eviMat = -eviMat*2;
        case 'aicc'
            [eviMat(:,1),eviMat(:,2),eviMat(:,3)] = fetchn(varprecision.EviFactorAdd & records, 'guess_aicc','ori_aicc','var_aicc');
            eviMat = -eviMat*2;
        case 'llmax'
            [eviMat(:,1),eviMat(:,2),eviMat(:,3)] = fetchn(varprecision.EviFactorAdd & records, 'guess_llmax','ori_llmax','var_llmax');
    end
    
    mean_evi = mean(eviMat);
    sem_evi = std(eviMat)./sqrt(length(records));
    
    fig = Figure(101,'size',[60,40]); hold on
    bar(mean_evi,'FaceColor','w');
    errorbar(mean_evi,sem_evi,'k','LineStyle','None')
    set(gca, 'xTick',[1,2,3],'xTickLabel',{'Guess','Ori','Var'})
    xlabel('factor')
    ylabel('AIC difference')
    
    yLim = get(gca,'YLim');
    
    if min(mean_evi-sem_evi)>-60
        ylim([-60,20])
    else
        ylim([yLim(1),20])
    end
    
    fig.cleanup
    fig.save(['~/Dropbox/VR/+varprecision/figures/aic_factor_exp' num2str(iexp.exp_id)]);
    
end