function [p, mean_evi, sem_evi] = cmptoOpt(model_res, type)
%CMPTOOPVPGN compute mean and standard error compared to OPVPGN
%   function [mean_evi, sem_evi] = cmptoOpt(exp_res, model_res)
%   exp_res restricts the experiment id, only works for one suboptimal rule at
%   a time; model_res restricts models, supports multiple models at once
%   SS 17-06-08

exp = fetch(varprecision.Experiment & 'exp_id=9');
models = fetch(varprecision.Model & exp & model_res);
subjs = fetch(varprecision.Subject & 'subj_type = "real"');
subj_rel = fetch(varprecision.Recording & exp & subjs);

p = zeros(1,length(models));
mean_evi = zeros(1,length(models));
sem_evi = zeros(1,length(models));

for ii = 1:length(models)
    model = models(ii);
    factor_code = fetch1(varprecision.Model & model,'factor_code');
    model_opt = fetch(varprecision.Model & 'rule="Opt"' & ['factor_code="' factor_code '"']);
    eviMat = fetchn(varprecision.FitParsEviBpsBestAvg & model & subj_rel, type); 
    eviMat_ref = fetchn(varprecision.FitParsEviBpsBestAvg & model_opt & subj_rel, type);
    diff_evi = 2*(eviMat - eviMat_ref);
    mean_evi(ii) = mean(diff_evi);
    sem_evi(ii) = std(diff_evi)/sqrt(length(subj_rel));
    p(ii) = signrank(eviMat, eviMat_ref, 'tail', 'left');
end

    



