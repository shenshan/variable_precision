function [mean_evi, sem_evi, p1, p2, p3] = LFLRGOV(type,exp_res)
%MARGINALPOSTERIOR Summary of this function goes here
%   Detailed explanation goes here

exp = fetch(varprecision.Experiment & exp_res);

subjs = fetch(varprecision.Subject & 'subj_type="real"');
records = fetch(varprecision.Recording & exp & subjs);
eviMat = zeros(length(records),4);

switch type
    case 'aic'
        [eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4)] = fetchn(varprecision.EviFactorGOV & records, 'g_lfpr_aic','o_lfpr_aic','v_lfpr_aic','ov_lfpr_aic');
    case 'bic'
        [eviMat(:,1),eviMat(:,2),eviMat(:,3),eviMat(:,4)] = fetchn(varprecision.EviFactorGOV & records, 'g_lfpr_bic','o_lfpr_bic','v_lfpr_bic','ov_lfpr_bic');
end
eviMat = eviMat * 2;
mean_evi = mean(eviMat);
sem_evi = std(eviMat)./sqrt(length(records));

for ii = 1:size(eviMat,2)
    p1(ii) = signrank(eviMat(:,ii), 9.2, 'tail', 'right');
    p2(ii) = signrank(eviMat(:,ii), 6.8, 'tail', 'right');
    p3(ii) = signrank(eviMat(:,ii), 4.6, 'tail', 'right');
end