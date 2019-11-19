function showLFPRGOV(type)
%SHOWEVIFACTOR shows the factor evidence for all experiments
%   function showEviFactor(type)
%   type specifies the type of evidences, should be one of the following: aic, bic, aicc, llmax

exp_ids = [1,8,2:5,9,10,6,7,11];
eviMat = cell(length(exp_ids),4);

for ii = 1:length(exp_ids)
    exp_id = exp_ids(ii);
    exp = fetch(varprecision.Experiment & ['exp_id =' num2str(exp_id)]);
    
    switch type
        case 'aic'
            [eviMat{ii,1},eviMat{ii,2},eviMat{ii,3},eviMat{ii,4}] = fetchn(varprecision.EviFactorGOV & exp, 'g_lfpr_aic','o_lfpr_aic','v_lfpr_aic','ov_lfpr_aic');
        case 'bic'
            [eviMat{ii,1},eviMat{ii,2},eviMat{ii,3},eviMat{ii,4}] = fetchn(varprecision.EviFactorGOV & exp, 'g_lfpr_bic','o_lfpr_bic','v_lfpr_bic','ov_lfpr_bic');
        case 'aicc'
            [eviMat{ii,1},eviMat{ii,2},eviMat{ii,3},eviMat{ii,4}] = fetchn(varprecision.EviFactorGOV & exp, 'g_lfpr_aicc','o_lfpr_aicc','v_lfpr_aicc','ov_lfpr_aicc');
        case 'llmax'
            [eviMat{ii,1},eviMat{ii,2},eviMat{ii,3},eviMat{ii,4}] = fetchn(varprecision.EviFactorGOV & exp, 'g_lfpr_llmax','o_lfpr_llmax','v_lfpr_llmax','ov_lfpr_llmax');
    end
    
end
eviMat = cellfun(@(x)x*2, eviMat, 'Un',0);

fig = Figure(101,'size',[150,27]);

groupbar(eviMat); hold on
xLim = get(gca, 'xLim');
plot([xLim(1),xLim(2)],[6.8,6.8],'k--')
plot([xLim(1),xLim(2)],[9.21,9.21],'k--')
plot([xLim(1),xLim(2)],[4.6,4.6],'k--')
ylim([-20,90])
set(gca,'YTick',-20:20:80);
% xlabel('Experiment number')
ylabel('2xLFPR ')


% legend('G','D','O','V','O+V','location','southeast')

fig.cleanup

fig.save(['~/Dropbox/VR/+varprecision/figures/lfpr_GOV_' type])