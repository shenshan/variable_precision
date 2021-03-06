function showEviFactorAddEachInd(exp, type)
%SHOWEVIFACTORAddInd shows the factor evidence for individual experiments
%   function showEviFactor(exp, type)
%   exp specifies the experiment number, type specifies the type of evidences, should be one of the following: aic, bic, aicc, llmax

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
            [eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4),eviMat(:,5)] = fetchn(varprecision.EviFactorAddEach & records, 'guess_aic','dn_aic','ori_aic','var_aic','total_var_aic');
            eviMat = -eviMat*2;
        case 'bic'
            [eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4),eviMat(:,5)] = fetchn(varprecision.EviFactorAddEach & records, 'guess_bic','dn_bic','ori_bic','var_bic','total_var_bic');
            eviMat = -eviMat*2;
        case 'aicc'
            [eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4),eviMat(:,5)] = fetchn(varprecision.EviFactorAddEach & records, 'guess_aicc','dn_aicc','ori_aicc','var_aicc','total_var_aicc');
            eviMat = -eviMat*2;
        case 'llmax'
            [eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4),eviMat(:,5)] = fetchn(varprecision.EviFactorAddEach & records, 'guess_llmax','dn_llmax','ori_llmax','var_llmax','total_var_llmax');
    end
    
    mean_evi = mean(eviMat);
    sem_evi = std(eviMat)./sqrt(length(records));
    
    fig = Figure(101,'size',[55,30]); hold on
    bar(mean_evi,'FaceColor','w');
    errorbar(mean_evi,sem_evi,'k','LineStyle','None')
    set(gca, 'xTick',[1,2,3,4,5],'xTickLabel',{'+G','+D','+O','+V','+O+V'})
    xlabel('Factor')
    ylabel('AIC difference')
    
    yLim = get(gca,'YLim');
    
    if min(mean_evi-sem_evi)>-100
        ylim([-100,20])
    else
        ylim([yLim(1),20])
    end
    
    fig.cleanup
    fig.save(['~/Dropbox/VR/+varprecision/figures/aic_factor_add_each_exp' num2str(iexp.exp_id)]);
    
end