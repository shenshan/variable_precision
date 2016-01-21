% This script inserts the parameters of each model for each experiments. 

% For experiments 1-5 we used guassian as the noise model, for 6-10, we
% used von mises. So the precision parameter of experiment 1-5 is lambda
% and experiments 6-10 is kappa

% parameterset id 1 uses lambda = linspace(0.01,0.7,31), theta = linspace(0.01,0.7,31) for gaussian experiments
% and uses kappa = linspace(1,150,31), theta = linspace(0.1,20,31) for von mises experiments

% parameters
p_right = linspace(0.3,0.7,21);
lambda = linspace(0.01,0.7,31);
theta1 = linspace(0.01,0.7,31);
kappa = linspace(1,150,31);
theta2 = linspace(0.1,20,31);
guess = linspace(0,0.5,31);

% gaussian experiments
for ii = 1:5
    varprecision.utils.insertParameters(ii,'CP',1,p_right,lambda);
    varprecision.utils.insertParameters(ii,'CPG',1,p_right,lambda,guess);
    varprecision.utils.insertParameters(ii,'VP',1,p_right,lambda,theta1);
    varprecision.utils.insertParameters(ii,'VPG',1,p_right,lambda,theta1,guess);
end

% von mises experiments
for ii = 6:10
    varprecision.utils.insertParameters(ii,'CP',1,p_right,kappa);
    varprecision.utils.insertParameters(ii,'CPG',1,p_right,kappa,guess);
    varprecision.utils.insertParameters(ii,'VP',1,p_right,kappa,theta2);
    varprecision.utils.insertParameters(ii,'VPG',1,p_right,kappa,theta2,guess);
end


