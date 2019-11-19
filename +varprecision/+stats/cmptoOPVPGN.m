function [mean_evi, sem_evi] = cmptoOPVPGN(exp_res, model_res, type)
%CMPTOOPVPGN compute mean and standard error compared to OPVPGN
%   function [mean_evi, sem_evi] = cmptoOPVPGN(exp_res, model_res)
%   exp_res restricts the experiment id, only works for one experiment at
%   a time; model_res restricts models, supports multiple models at once
%   SS 17-04-21

exp = fetch(varprecision.Experiment & exp_res);
models = fetch(varprecision.Model & exp & model_res);
subjs = fetch(varprecision.Subject & 'subj_type = "real"');
subj_rel = fetch(varprecision.Recording & exp & subjs);

eviMat_ref = fetchn(varprecision.FitParsEviBpsBestAvg & 'model_name = "OPVPGN"' & subj_rel, type);

if ismember(type, {'aic', 'bic', 'aicc'})
    eviMat_rel = 2*eviMat_ref;
end

eviMat = zeros(length(subj_rel),length(models));

for ii = 1:length(models)
    eviMat(:,ii) = fetchn(varprecision.FitParsEviBpsBestAvg & models(ii) & subj_rel, type);
end

if ismember(type, {'aic','bic','aicc'})
    eviMat = eviMat * 2;
end

diff_evi = bsxfun(@minus, eviMat, eviMat_rel);

mean_evi = mean(diff_evi);
sem_evi = std(diff_evi)/sqrt(length(subj_rel));

    



