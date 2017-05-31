function [mean_evi, sem_evi] = eviAdd(exp_res)
%   Detailed explanation goes here

exp = fetch(varprecision.Experiment & exp_res);

subjs = fetch(varprecision.Subject & 'subj_type="real"');

records = fetch(varprecision.Recording & exp & subjs);
eviMat = zeros(length(records),5);

[eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4),eviMat(:,5)] = fetchn(varprecision.EviFactorAddEach & records, 'guess_aic','dn_aic','ori_aic','var_aic','total_var_aic');
eviMat = -eviMat*2;


mean_evi = mean(eviMat);
sem_evi = std(eviMat)./sqrt(length(records));
