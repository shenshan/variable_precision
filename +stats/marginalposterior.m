function [mean_evi, sem_evi, p] = marginalposterior(exp_res)
%MARGINALPOSTERIOR Summary of this function goes here
%   Detailed explanation goes here

exp = fetch(varprecision.Experiment & exp_res);

subjs = fetch(varprecision.Subject & 'subj_type="real"');
records = fetch(varprecision.Recording & exp & subjs);
eviMat = zeros(length(records),5);

[eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4),eviMat(:,5)] = fetchn(varprecision.EviFactor & records, 'guess_aic','dn_aic','ori_aic','var_aic','total_var_aic');

mean_evi = mean(eviMat);
sem_evi = std(eviMat)./sqrt(length(records));

for ii = 1:size(eviMat,2)
    p(ii) = signrank(eviMat(:,ii), 0.5, 'tail', 'right');
end