function [mean_evi, sem_evi, p] = marginalposteriorGV(type, exp_res)
%MARGINALPOSTERIOR Summary of this function goes here
%   Detailed explanation goes here

exp = fetch(varprecision.Experiment & exp_res);

subjs = fetch(varprecision.Subject & 'subj_type="real"');
records = fetch(varprecision.Recording & exp & subjs);
eviMat = zeros(length(records),2);

switch type
    case 'aic'
        [eviMat(:,1),eviMat(:,2)] = fetchn(varprecision.EviFactorGV & records, 'guess_aic','var_aic');
    case 'bic'
        [eviMat(:,1),eviMat(:,2)] = fetchn(varprecision.EviFactorGV & records, 'guess_bic','var_bic');
end

mean_evi = mean(eviMat);
sem_evi = std(eviMat)./sqrt(length(records));

for ii = 1:size(eviMat,2)
    p(ii) = signrank(eviMat(:,ii), 0.5, 'tail', 'right');
end