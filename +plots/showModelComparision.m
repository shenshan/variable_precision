function showModelComparision(data_type, cmp_type, subtract, varargin)
%SHOWMODELCOMPARISION plots the model comparison results
%   varargin can specify the expriment, models, subjects, parameter sets
%   type specifies the type of evidence needed

assert(ismember(data_type, {'mean','ind'}), 'Non-existing data type, please enter "mean" or "ind"')
assert(ismember(cmp_type, {'aic','aicc','bic','lml'}), 'Non-existing comparison type, please enter one of the following: aic, aicc, bic, lml')


exps = fetch(varprecision.Experiment & varargin);

for exp = exps'
    
    keys_rec = fetch(varprecision.Recording & exp);
    models = fetch(varprecision.Model & exp);
    
    eviMat = zeros(length(keys_rec),length(models));
    for ikey = 1:length(keys_rec)
        key_rec = keys_rec(ikey);
        evi = fetchn(varprecision.Evidence & key_rec, cmp_type);
        eviMat(ikey,:) = evi;
    end
    
    % fetch the evidence for VPG
    evi = fetchn(varprecision.Evidence & keys_rec & 'model_name="VPG"', cmp_type);
    
    if subtract
        eviMat = bsxfun(@minus, eviMat, evi);
    end
    
    figure; hold on
    if strcmp(data_type,'mean')
        eviMat_mean = mean(eviMat);
        eviMat_sem = std(eviMat)/sqrt(size(eviMat,1));
        bar(eviMat_mean)
        errorbar(eviMat_mean,eviMat_sem, 'LineStyle','None')
    else
        bar(eviMat)
    end
    
    model_names = fetchn(varprecision.Model & exp, 'model_name');
    ylabel('LML')
    set(gca,'XTick',1:length(models),'XTickLabel',model_names)
    

end



