function min_diff = cmpTwoGroups

% this function returns the minimal difference between mean AICs for
% suboptimal rules similar and non-similar to the Opt rule

subjs = fetch(varprecision.Subject & 'subj_type="real"');

non_similar_rules = fetch(varprecision.Model & 'exp_id=9' & 'rule in ("Max","Min","Sum","Var","Sign","Max2","Max12","Max13","Max23","Max123","SumErf","SumErf1","SumErf2","SumErf12","SumX1","SumX2","SumX12")');

similar_rules = fetch(varprecision.Model & 'exp_id=9' & 'rule not in ("Opt","Max","Min","Sum","Var","Sign","Max2","Max12","Max13","Max23","Max123","SumErf","SumErf1","SumErf2","SumErf12","SumX1","SumX2","SumX12")');

mean_aic_non_similar = zeros(1,length(non_similar_rules));
mean_aic_similar = zeros(1,length(similar_rules));

for ii = 1:length(non_similar_rules)
    model = non_similar_rules(ii);
    aicMat = fetchn(varprecision.FitParsEviBpsBestAvg & model & subjs,'aic');
    mean_aic_non_similar(ii) = 2*mean(aicMat);
end

for ii = 1:length(similar_rules)
    model = similar_rules(ii);
    aicMat = fetchn(varprecision.FitParsEviBpsBestAvg & model & subjs,'aic');
    mean_aic_similar(ii) = 2*mean(aicMat);
end

min_diff = min(mean_aic_non_similar)-max(mean_aic_similar);