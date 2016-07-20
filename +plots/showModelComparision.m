function showModelComparision(data_type, cmp_type, subtract, jkmap, varargin)
%SHOWMODELCOMPARISION plots the model comparison results
%   varargin can specify the expriment, models, subjects, parameter sets
%   type specifies the type of evidence needed

assert(ismember(data_type, {'mean','ind'}), 'Non-existing data type, please enter "mean" or "ind"')
assert(ismember(cmp_type, {'aic','aicc','bic','lml','llmax'}), 'Non-existing comparison type, please enter one of the following: aic, aicc, bic, lml')


exps = fetch(varprecision.Experiment & varargin(1));
subjs = fetch(varprecision.Subject & 'subj_type="real"');
jkmap_id = fetch1(varprecision.JbarKappaMap & jkmap,'jkmap_id');

for exp = exps'
    
    keys_rec = fetch(varprecision.Recording & exp & subjs);
    models = fetch(varprecision.Model & exp);
    
    eviMat = zeros(length(keys_rec),length(models));
    for ikey = 1:length(keys_rec)
        key_rec = keys_rec(ikey);
        evi = fetchn(varprecision.FitParametersEvidence & key_rec & jkmap & varargin, cmp_type);
        eviMat(ikey,:) = evi;
    end
    
    % fetch the evidence for VPG
    evi = fetchn(varprecision.FitParametersEvidence & keys_rec & jkmap & varargin & 'model_name="VPG"', cmp_type);
    model_names = fetchn(varprecision.Model & exp, 'model_name');
    if subtract
        eviMat = bsxfun(@minus, eviMat, evi);
    end
    
    
    if strcmp(data_type,'mean')
        fig = Figure(105,'size',[40,30]); hold on       
        bar_custom(eviMat(:,1:length(model_names)-1),'mean')
        if ismember(cmp_type,{'lml','llmax'})
            ylim([-100,10])
        else
            ylim([-10,100])
        end
        set(gca,'XTick',1:length(models)-1,'XTickLabel',model_names(1:length(model_names)-1))
    else
        nSubjs = size(eviMat,1);
        if nSubjs>10
            fig = Figure(105, 'size',[80,30]);
        else
            fig = Figure(105, 'size',[50,30]);
        end
        hold on
        bar_custom(eviMat(:,1:length(model_names)-1),'group')
        if ismember(cmp_type,{'lml','llmax'})
            ylim([-100,10])
        else
            ylim([-10,100])
        end
        set(gca,'Xtick',1:nSubjs)
    end
    
    
%     ylabel('LML')
%     title('evidences')
%     
    
    fig.cleanup
    fig.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(models(1).exp_id) '_' cmp_type '_' data_type '_' num2str(jkmap_id) '.eps'])
end



