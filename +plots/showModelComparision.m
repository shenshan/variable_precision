function showModelComparision(data_type, subj_type, cmp_type, subtract, varargin)
%SHOWMODELCOMPARISION plots the model comparison results
%   varargin can specify the expriment, models, subjects, parameter sets
%   type specifies the type of evidence needed

assert(ismember(data_type, {'mean','ind'}), 'Non-existing data type, please enter "mean" or "ind"')
assert(ismember(subj_type, {'real','real_sub'}), 'Non-existing data type, please enter "mean" or "ind"')
assert(ismember(cmp_type, {'aic','aicc','bic','lml','llmax'}), 'Non-existing comparison type, please enter one of the following: aic, aicc, bic, lml')

exp_res = varprecision.utils.parseVarargin('exp',varargin);
subj_res = varprecision.utils.parseVarargin('subj',varargin);
model_res = varprecision.utils.parseVarargin('model',varargin);

exps = fetch(varprecision.Experiment & exp_res);

res = fetch(varprecision.FitParsEviBpsBest & varargin);
subjs = fetch(varprecision.Subject & ['subj_type="' subj_type '"']);
% jkmap_id = fetch1(varprecision.JbarKappaMap & jkmap,'jkmap_id');

for exp = exps'
    
    keys_rec = fetch(varprecision.Recording & exp & subjs & subj_res);
    models = fetch(varprecision.Model & exp & model_res);
    
    eviMat = zeros(length(keys_rec),length(models));
    for ikey = 1:length(keys_rec)
        key_rec = keys_rec(ikey);
%         evi = fetchn(varprecision.FitParametersEvidence & key_rec & jkmap & varargin, cmp_type);
        evi = fetchn(varprecision.FitParsEviBpsBest & key_rec & varargin, cmp_type);
        eviMat(ikey,:) = evi;
    end
    
    % fetch the evidence for VPG
%     evi = fetchn(varprecision.FitParametersEvidence & keys_rec & jkmap & varargin(2) & 'model_name="VPG"', cmp_type);
    if ismember(exp.exp_id,[1:5,9,10])
        evi = fetchn(varprecision.FitParsEviBpsBest & keys_rec & varargin & 'model_name="VPG"', cmp_type);
    else
        evi = fetchn(varprecision.FitParsEviBpsBest & keys_rec & varargin & 'model_name="XPVPG"', cmp_type);
    end
    model_names = fetchn(varprecision.Model & exp & res, 'model_name');
    if subtract
        eviMat = bsxfun(@minus, eviMat, evi);
    end
    
    
    if strcmp(data_type,'mean')
        if length(model_names)>7
            fig = Figure(105,'size',[80,30]);
        else
            fig = Figure(105,'size',[40,30]);
        end
        hold on 
        bar_custom(eviMat(:,1:length(model_names)),'mean')
        if ismember(cmp_type,{'lml','llmax'})
            ylim([-100,20])
        else
            ylim([-10,100])
        end
        set(gca,'XTick',1:length(models),'XTickLabel',model_names)
    else
        nSubjs = size(eviMat,1);
        if nSubjs>10
            fig = Figure(105, 'size',[80,30]);
        else
            fig = Figure(105, 'size',[50,30]);
        end
        hold on
        bar_custom(eviMat(:,1:length(model_names)),'group')
        if ismember(cmp_type,{'lml','llmax'})
            ylim([-100,20])
        else
            ylim([-10,100])
        end
        set(gca,'Xtick',1:nSubjs)
        legend(model_names)
    end
    
    
%     ylabel('LML')
%     title('evidences')
%     
    
    fig.cleanup
%     fig.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(models(1).exp_id) '_' cmp_type '_' data_type '_' num2str(jkmap_id) '.eps'])
fig.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(models(1).exp_id) '_' cmp_type '_' data_type '.eps'])
end



