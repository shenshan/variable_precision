function LL = loglikelihood(params,key)
%EXP1 compute likelihood given all trials and one set of parameters

[stimuli, response, set_size] = fetch1(varprecision.Data & key ,'stimuli','response','set_size');
setsizes = fetch1(varprecision.Experiment & key, 'setsize');
exp_id = key.exp_id;

if ismember(key.exp_id,[6,7,8,10,11])
    vm = 1;
    [jmap,kmap] = fetch1(varprecision.JbarKappaMap & 'jkmap_id=2','jmap','kmap');
else
    vm = 0;
end
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
        case 'XP'
            pars.beta = params(6);
        case 'XPG'
            pars.beta = params(6);
            pars.guess = params(7);
        case 'XPVP'
            pars.theta = params(6);
            pars.beta = params(7);
        case 'XPVPG'
            pars.theta = params(6);
            pars.beta = params(7);
            pars.guess = params(8);
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
        case 'XP'
            pars.beta = params(3);
        case 'XPG'
            pars.beta = params(3);
            pars.guess = params(4);
        case 'XPVP'
            pars.theta = params(3);
            pars.beta = params(4);
        case 'XPVPG'
            pars.theta = params(3);
            pars.beta = params(4);
            pars.guess = params(5);
    end
end

f = eval(['@varprecision.decisionrule.exp' num2str(exp_id)]);
pars.model_name = key.model_name;
pars.pre = 0;
pars.sigma_s = fetch1(varprecision.Experiment & key, 'sigma_s');
trial_num_sim = 1000;

predMat = zeros(size(response));

if length(setsizes)==1
    if ismember(key.model_name,{'CP','CPG'})
        if vm == 0
            noiseMat = normrnd(0,1/sqrt(pars.lambda),[setsizes,trial_num_sim]);
        else
            pars.lambda = pars.lambda*180^2/pi^2/4;
            % map jbar to kappa
            pars.lambda = varprecision.utils.mapJK(pars.lambda,jmap,kmap);
            noiseMat = circ_vmrnd(zeros(setsizes,trial_num_sim),pars.lambda)/2;
        end
    elseif ismember(key.model_name, {'VP','VPG'})
        pars.lambdaMat = gamrnd(pars.lambda/pars.theta,pars.theta,[setsizes,trial_num_sim]);
        if vm == 0
            noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
        else
            pars.lambdaMat = pars.lambdaMat*180^2/pi^2/4;
            pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
            noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
        end
    elseif ismember(key.model_name, {'XP','XPG','XPVP','XPVPG'})
        sigma_baseline = 1/sqrt(pars.lambda);
    end
    stimuli = varprecision.utils.adjustStimuliSize(exp_id,stimuli,setsizes);
    for ii = 1:length(stimuli)    
        stimulus = stimuli(ii,:);
        if ismember(key.model_name, {'XP','XPG'})
            sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus)));
            pars.lambdaMat = 1./sigma.^2*180^2/pi^2/4;
            pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
            pars.lambdaMat = repmat(pars.lambdaMat, trial_num_sim,1)';
            noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
        elseif ismember(key.model_name, {'XPVP','XPVPG'})
            sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus)));
            pars.lambdaMat = 1./sigma.^2;
            pars.lambdaMat = repmat(pars.lambdaMat, trial_num_sim,1)';
            pars.lambdaMat = gamrnd(pars.lambdaMat/pars.theta,pars.theta);
            pars.lambdaMat = pars.lambdaMat*180^2/pi^2/4;
            pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);                       
            noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
        end
        x = repmat(stimulus',[1,trial_num_sim]) + noiseMat;
        if ismember(key.model_name,{'XPVP','XPVPG'})
            sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*x)));
            pars.lambdaMat = 1./sigma.^2;
            pars.lambdaMat = gamrnd(pars.lambdaMat/pars.theta,pars.theta);
            pars.lambdaMat = pars.lambdaMat*180^2/pi^2/4;         
            pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);          
        end
        predMat(ii) = f(x,pars);    
    end
else
    for jj = 1:length(setsizes)
        setsize = setsizes(jj);
        stimuli_sub = stimuli(set_size==setsize);
        response_sub = response(set_size==setsize);
        if ismember(key.model_name,{'CP','CPG'})
            pars.lambda = pars.lambdaVec(jj);
            if vm == 0            
                noiseMat = normrnd(0,1/sqrt(pars.lambdaVec(jj)),[setsize,trial_num_sim]);
            else
                pars.lambda = pars.lambda*180^2/pi^2/4;
                pars.lambda = varprecision.utils.mapJK(pars.lambda,jmap,kmap);
                noiseMat = circ_vmrnd(zeros(setsize,trial_num_sim),pars.lambda)/2;
            end  
        else
            pars.lambdaMat = gamrnd(pars.lambdaVec(jj)/pars.theta,pars.theta,[setsize,trial_num_sim]);
            if vm == 0
                noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
            else
                pars.lambdaMat = pars.lambdaMat*180^2/pi^2/4;
                pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
            end
        end
        stimuliMat = varprecision.utils.adjustStimuliSize(exp_id,stimuli_sub,setsize);
        predMat_sub = zeros(size(response_sub));
        for ii = 1:length(stimuli_sub)
            stimulus = stimuliMat(ii,:);
            if ismember(key.model_name, {'XP','XPG'})
                sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus)));
                pars.lambdaMat = 1./sigma.^2*180^2/pi^2/4;
                pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,'jmap','kmap');
                pars.lambdaMat = repmat(pars.lambdaMat, trial_num_sim,1)';
                noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
            elseif ismember(key.model_name, {'XPVP','XPVPG'})
                sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus)));
                pars.lambdaMat = 1./sigma.^2*180^2/pi^2/4;
                pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,'jmap','kmap');
                pars.lambdaMat = repmat(pars.lambdaMat, trial_num_sim,1)';
                pars.lambdaMat = gamrnd(pars.lambdaMat/pars.theta,pars.theta);
                noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
            end
            x = repmat(stimulus', [1,trial_num_sim]) + noiseMat;
        	predMat_sub(ii) = f(x,pars);
        end
        predMat(set_size==setsize) = predMat_sub;
    end
end
    
predMat(predMat==0) = 1/trial_num_sim;
predMat(predMat==1) = 1 - 1/trial_num_sim;
predMat(response==-1) = 1-predMat(response==-1);

if ismember(key.model_name,{'CPG','VPG','XPG','XPVPG'})
    predMat = predMat*(1-pars.guess) + .5*pars.guess;
end
LL = -sum(log(predMat));