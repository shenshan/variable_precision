function plotAll(exp_id)

exp_id_final = [1,3,4,5,6,9,10,2,7,8,11];

for ii = 1:length(exp_id)
    
    varprecision.plots.showStimDistr(exp_id_final(exp_id(ii)),1);
    varprecision.plots.FactorizedModelComparison(['exp_id=' num2str(exp_id(ii))],'aic','all','avg')
    varprecision.plots.showEviFactorAddInd(['exp_id=' num2str(exp_id(ii))],'aic')
    varprecision.plots.showEviFactorInd(['exp_id=' num2str(exp_id(ii))],'aic')
    varprecision.plots.showEviFactorLikelihoodInd(['exp_id=' num2str(exp_id(ii))],'aic')
    
    if exp_id(ii)==9
        varprecision.plots.drawPsychCurve('both',['exp_id=' num2str(exp_id(ii))],'model_name in ("CP","CPG","CPGN","OPVPGN")')
    elseif ismember(exp_id(ii),[10,11])
        varprecision.plots.drawPsychCurveDetectionBps(['exp_id=' num2str(exp_id(ii))],'model_name="CP"')
        varprecision.plots.drawPsychCurveDetectionBps(['exp_id=' num2str(exp_id(ii))],'model_name="CPG"')
        varprecision.plots.drawPsychCurveDetectionBps(['exp_id=' num2str(exp_id(ii))],'model_name="CPGN"')
        varprecision.plots.drawPsychCurveDetectionBps(['exp_id=' num2str(exp_id(ii))],'model_name="OPVPGN"')
    else
        varprecision.plots.drawPsychCurve('bps',['exp_id=' num2str(exp_id(ii))],'model_name in ("CP","CPG","CPGN","OPVPGN")')
    end
end



