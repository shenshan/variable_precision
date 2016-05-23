function showModelComparision(data_type, cmp_type, subtract, varargin)
%SHOWMODELCOMPARISION plots the model comparison results
%   varargin can specify the expriment, models, subjects, parameter sets
%   type specifies the type of evidence needed

assert(ismember(data_type, {'mean','ind'}), 'Non-existing data type, please enter "mean" or "ind"')
assert(ismember(cmp_type, {'aic','aicc','bic','lml'}), 'Non-existing comparison type, please enter one of the following: aic, aicc, bic, lml')


exps = fetch(varprecision.Experiment & varargin(1));

for exp = exps'
    
    keys_rec = fetch(varprecision.Recording & exp);
    models = fetch(varprecision.Model & exp);
    
    eviMat = zeros(length(keys_rec),length(models));
    for ikey = 1:length(keys_rec)
        key_rec = keys_rec(ikey);
        evi = fetchn(varprecision.FitParametersEvidence & key_rec & varargin, cmp_type);
        eviMat(ikey,:) = evi;
    end
    
    % fetch the evidence for VPG
    evi = fetchn(varprecision.FitParametersEvidence & keys_rec  & varargin & 'model_name="VPG"', cmp_type);
    
    if subtract
        eviMat = bsxfun(@minus, eviMat, evi);
    end
    
    
    if strcmp(data_type,'mean')
        fig = Figure(105,'size',[40,30]); hold on
        eviMat_mean = mean(eviMat);
        eviMat_sem = std(eviMat)/sqrt(size(eviMat,1));
        bar(eviMat_mean)
        errorbar(eviMat_mean,eviMat_sem, 'LineStyle','None')
        ylim([-100,10])
    else
        fig = Figure(105,'size',[100,30]); hold on
        bar(eviMat')
    end
    
    model_names = fetchn(varprecision.Model & exp, 'model_name');
    ylabel('LML')
    set(gca,'XTick',1:length(models),'XTickLabel',model_names)
    
    
    fig.cleanup
    fig.save(['~/Documents/MATLAB/local/+varprecision/figures/exp' num2str(models(1).exp_id) '_' cmp_type '.eps'])
end



