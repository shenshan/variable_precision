exp_id = 6;

varprecision.plots.showStimDistr(9,1);
varprecision.plots.FactorizedModelComparison(['exp_id=' num2str(exp_id)],'all')
varprecision.plots.showEviFactorAddInd(['exp_id=' num2str(exp_id)],'aic')
varprecision.plots.showEviFactorInd(['exp_id=' num2str(exp_id)],'aic')
varprecision.plots.showEviFactorLikelihoodInd(['exp_id=' num2str(exp_id)],'aic')