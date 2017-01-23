function showThetaHistogram

theta = fetchn(varprecision.FitParsEviBpsBest & 'model_name="OPVPG"','theta_hat');

hist(theta, 0:0.01:1);

