function LL = loglikelihood(params,key)
%EXP1 compute likelihood given all trials and one set of parameters

[stimuli, response, set_size] = fetch1(varprecision.Data & key ,'stimuli','response','set_size');
setsizes = fetch1(varprecision.Experiment & key, 'setsize');
exp_id = key.exp_id;

% get parameters correctly
if ismember(key.exp_id,[3,5,7,10,11])
    exp_id = exp_id - 1;
    pars.p_right = params(1);
    pars.lambdaVec = params(2:5);
    switch key.model_name
        case 'CPG'
            pars.guess = params(6);
        case 'VP'
            pars.theta = params(6);
        case 'VPG'
            pars.theta = params(6);
            pars.guess = params(7);
    end
else
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
end

f = eval(['@varprecision.decisionrule.exp' num2str(exp_id)]);
pars.model_name = key.model_name;
pars.pre = 0;
pars.sigma_s = fetch1(varprecision.Experiment & key, 'sigma_s');
trial_num_sim = 5000;

predMat = zeros(size(response));

if length(setsizes)==1
    if ismember(key.model_name,{'CP','CPG'})
        noiseMat = normrnd(0,1/sqrt(pars.lambda),[setsizes,trial_num_sim]);
    else
        pars.lambdaMat = gamrnd(pars.lambda/pars.theta,pars.theta,[setsizes,trial_num_sim]);
        noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
    end
    stimuli = varprecision.utils.adjustStimuliSize(exp_id,stimuli,setsizes);
    for ii = 1:length(stimuli)    
        stimulus = stimuli(ii,:);
        x = repmat(stimulus',[1,trial_num_sim]) + noiseMat;
        predMat(ii) = f(x,pars);    
    end
else
    for jj = 1:length(setsizes)
        setsize = setsizes(jj);
        stimuli_sub = stimuli(set_size==setsize);
        response_sub = response(set_size==setsize);
        if ismember(key.model_name,{'CP','CPG'})
            pars.lambda = pars.lambdaVec(jj);
            noiseMat = normrnd(0,1/sqrt(pars.lambdaVec(jj)),[setsize,trial_num_sim]);
        else
            pars.lambdaMat = gamrnd(pars.lambdaVec(jj)/pars.theta,pars.theta,[setsize,trial_num_sim]);
            noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
        end
        stimuliMat = varprecision.utils.adjustStimuliSize(exp_id,stimuli_sub,setsize);
        predMat_sub = zeros(size(response_sub));
        for ii = 1:length(stimuli_sub)
            stimulus = stimuliMat(ii,:);
            x = repmat(stimulus', [1,trial_num_sim]) + noiseMat;
        	predMat_sub(ii) = f(x,pars);
        end
        predMat(set_size==setsize) = predMat_sub;
    end
end
    
predMat(predMat==0) = 1/trial_num_sim;
predMat(predMat==1) = 1 - 1/trial_num_sim;
predMat(response==-1) = 1-predMat(response==-1);

if ismember(key.model_name,{'CPG','VPG'})
    predMat = predMat*(1-pars.guess) + .5*pars.guess;
end
LL = -sum(log(predMat));