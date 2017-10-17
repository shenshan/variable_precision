function [mean_evi, sem_evi] = cmptoNonSimilar
%CMPTOOPVPGN compute mean and standard error compared to the best model
%with non similar rule to the Opt
%   function [mean_evi, sem_evi] = cmptoOpt(exp_res, model_res)

exp = fetch(varprecision.Experiment & 'exp_id=9');
subjs = fetch(varprecision.Subject & 'subj_type = "real"');

non_similar_rules = fetch(varprecision.Model & 'exp_id=9' & 'rule in ("Max","Min","Sum","Var","Sign","Max2","Max12","Max13","Max23","Max123","SumErf","SumErf1","SumErf2","SumErf12","SumX1","SumX2","SumX12")');
similar_rules = fetch(varprecision.Model & 'exp_id=9' & 'rule not in ("Opt","Max","Min","Sum","Var","Sign","Max2","Max12","Max13","Max23","Max123","SumErf","SumErf1","SumErf2","SumErf12","SumX1","SumX2","SumX12")');


mean_evi = zeros(1,length(models));
sem_evi = zeros(1,length(models));

for ii = 1:length(models)
    model = models(ii);
    factor_code = fetch1(varprecision.Model & model,'factor_code');
    model_opt = fetch(varprecision.Model & 'rule="Opt"' & ['factor_code="' factor_code '"']);
    eviMat = fetchn(varprecision.FitParsEviBpsBestAvg & model & subjs, type); 
    eviMat_ref = fetchn(varprecision.FitParsEviBpsBestAvg & model_opt & subjs, type);
    diff_evi = 2*(eviMat - eviMat_ref);
    mean_evi(ii) = mean(diff_evi);
    sem_evi(ii) = std(diff_evi)/sqrt(length(subj_rel));
    p(ii) = signrank(eviMat, eviMat_ref, 'tail', 'left');
end

    



