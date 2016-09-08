function LL = loglikelihood(params,key)
%EXP1 compute likelihood given all trials and one set of parameters

[stimuli, response] = fetch1(varprecision.Data & key ,'stimuli','response');
f = eval(['@varprecision.decisionrule.exp' num2str(key.exp_id)]);

pars.p_right = params(1);
pars.lambda = params(2);

switch key.model_name
    case 'CPG'
        pars.guess = params(3);
    case 'VP'
        pars.theta = params(3);
    case 'VPG'
        pars.theta = params(3);
        pars.guess = params(4);
end
pars.model_name = key.model_name;
pars.pre = 0;
pars.sigma_s = 9.38;
trial_num_sim = 5000;

predMat = zeros(size(response));

if ismember(key.model_name,{'CP','CPG'})
    noiseMat = normrnd(0,1/sqrt(pars.lambda),[1,trial_num_sim]);
else
    pars.lambdaMat = gamrnd(pars.lambda/pars.theta,pars.theta,[1,trial_num_sim]);
    noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
end

for ii = 1:length(stimuli)    
    stimulus = stimuli(ii);
    x = repmat(stimulus,[1,trial_num_sim]) + noiseMat;
    predMat(ii) = f(x,pars);    
end
predMat(predMat==0) = 1/trial_num_sim;
predMat(predMat==1) = 1 - 1/trial_num_sim;
predMat(response==-1) = 1-predMat(response==-1);

if ismember(key.model_name,{'CPG','VPG'})
    predMat = predMat*(1-pars.guess) + .5*pars.guess;
end
LL = -sum(log(predMat));