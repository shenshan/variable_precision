function [mean_evi, sem_evi, p] = marginalposteriorGOV(type, exp_res)
%MARGINALPOSTERIOR Summary of this function goes here
%   Detailed explanation goes here

exp = fetch(varprecision.Experiment & exp_res);

subjs = fetch(varprecision.Subject & 'subj_type="real"');
records = fetch(varprecision.Recording & exp & subjs);
eviMat = zeros(length(records),4);

switch type
    case 'aic'
        [eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4)] = fetchn(varprecision.EviFactorGOV & records, 'guess_aic','ori_aic','var_aic','total_var_aic');
    case 'bic'
        [eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4)] = fetchn(varprecision.EviFactorGOV & records, 'guess_bic','ori_bic','var_bic','total_var_bic');
end

mean_evi = mean(eviMat);
sem_evi = std(eviMat)./sqrt(length(records));

for ii = 1:size(eviMat,2)
    p(ii) = signrank(eviMat(:,ii), 0.5, 'tail', 'right');
end