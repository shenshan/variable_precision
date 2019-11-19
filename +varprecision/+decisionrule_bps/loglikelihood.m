function [LL,predMat,prediction] = loglikelihood(params,key)
%loglikelihood computes likelihood given all trials and one set of parameters
%   LL is the negative log likelihood, predMat is the likelihood of a model
%   for each trial given subject's response, prediction is the model
%   prediction of reporting "right" or "present" for each trial.
if isfield(key,'trade_off')
    [stimuli, response, set_size] = fetch1(varprecision.TradeOffTestSet & key, 'stimuli','response','set_size');
    if key.exp_id == 3
        pars.sigma_s = fetch1(varprecision.Experiment & key, 'sigma_s');
        key.exp_id = key.exp_id - 1;
    end
    subj_type = 'trade_off';
else
    [stimuli, response, set_size] = fetch1(varprecision.Data & key ,'stimuli','response','set_size');
    pars.sigma_s = fetch1(varprecision.Experiment & key, 'sigma_s');
    subj_type = fetch1(varprecision.Subject & ['subj_initial="' key.subj_initial '"'],'subj_type');
end
setsizes = unique(set_size);
exp_id = key.exp_id;
[model_type,factor_code,rule,prior_type] = fetch1(varprecision.Model & key, 'model_type','factor_code','rule','prior_type');

if ismember(key.exp_id,[6,7,11])
    vm = 1;
    [jmap,kmap] = fetch1(varprecision.JbarKappaMap & 'jkmap_id=2','jmap','kmap');
else
    vm = 0;
end
% get parameters correctly
if ismember(key.exp_id,[3,5,7])
    exp_id = exp_id - 1;
end


if ismember(key.exp_id,[3,5,7,10,11,12]) && ismember(subj_type,{'real','fake','trade_off'})
    if strcmp(model_type,'opt')
        pars.p_right = params(1);
        pars.lambdaVec = params(2:5);
        switch factor_code
            case 'G'
                pars.guess = params(6);
            case 'V'
                pars.theta = params(6);
            case 'GV'
                pars.theta = params(6);
                pars.guess = params(7);
            case 'O'
                pars.beta = params(6);
            case 'GO'
                pars.beta = params(6);
                pars.guess = params(7);
            case 'OV'
                pars.theta = params(6);
                pars.beta = params(7);
            case 'GOV'
                pars.theta = params(6);
                pars.beta = params(7);
                pars.guess = params(8);
            case 'D'
                pars.sigma_dn = params(6);
            case 'GD'
                pars.guess = params(6);
                pars.sigma_dn = params(7);
            case 'DV'
                pars.theta = params(6);
                pars.sigma_dn = params(7);
            case 'GDV'
                pars.theta = params(6);
                pars.guess = params(7);
                pars.sigma_dn = params(8);
            case 'DO'
                pars.beta = params(6);
                pars.sigma_dn = params(7);
            case 'GDO'
                pars.beta = params(6);
                pars.guess = params(7);
                pars.sigma_dn = params(8);
            case 'DOV'
                pars.theta = params(6);
                pars.beta = params(7);
                pars.sigma_dn = params(8);
            case 'GDOV'
                pars.theta = params(6);
                pars.beta = params(7);
                pars.guess = params(8);
                pars.sigma_dn = params(9);
        end
    else
        pars.lambdaVec = params(1:4);
        switch factor_code
            case 'G'
                pars.guess = params(5);
            case 'V'
                pars.theta = params(5);
            case 'GV'
                pars.theta = params(5);
                pars.guess = params(6);
            case 'O'
                pars.beta = params(5);
            case 'GO'
                pars.beta = params(5);
                pars.guess = params(6);
            case 'OV'
                pars.theta = params(5);
                pars.beta = params(6);
            case 'GOV'
                pars.theta = params(5);
                pars.beta = params(6);
                pars.guess = params(7);
            case 'D'
                pars.sigma_dn = params(5);
            case 'GD'
                pars.guess = params(5);
                pars.sigma_dn = params(6);
            case 'DV'
                pars.theta = params(5);
                pars.sigma_dn = params(6);
            case 'GDV'
                pars.theta = params(5);
                pars.guess = params(6);
                pars.sigma_dn = params(7);
            case 'DO'
                pars.beta = params(5);
                pars.sigma_dn = params(6);
            case 'GDO'
                pars.beta = params(5);
                pars.guess = params(6);
                pars.sigma_dn = params(7);
            case 'DOV'
                pars.theta = params(5);
                pars.beta = params(6);
                pars.sigma_dn = params(7);
            case 'GDOV'
                pars.theta = params(5);
                pars.beta = params(6);
                pars.guess = params(7);
                pars.sigma_dn = params(8);
        end
    end
else
    if ismember(model_type,{'Simple','Max','SumX','sub'})
        pars.lambda = params(1);
        if strcmp(factor_code,'G')
            pars.guess = params(2);
        elseif strcmp(factor_code,'D')
            pars.sigma_dn = params(2);
        elseif strcmp(factor_code,'GD')
            pars.guess = params(2);
            pars.sigma_dn = params(3);
        elseif strcmp(factor_code,'O')
            pars.beta = params(2);
        elseif strcmp(factor_code,'GO')
            pars.beta = params(2);
            pars.guess = params(3);
        elseif strcmp(factor_code,'DO')
            pars.beta = params(2);
            pars.sigma_dn = params(3);
        elseif strcmp(factor_code,'GDO')
            pars.beta = params(2);
            pars.guess = params(3);
            pars.sigma_dn = params(4);
        elseif strcmp(factor_code,'V')
            pars.theta = params(2);
        elseif strcmp(factor_code,'GV')
            pars.theta = params(2);
            pars.guess = params(3);
        elseif strcmp(factor_code,'DV')
            pars.theta = params(2);
            pars.sigma_dn = params(3);
        elseif strcmp(factor_code,'GDV')
            pars.theta = params(2);
            pars.guess = params(3);
            pars.sigma_dn = params(4);
        elseif strcmp(factor_code,'OV')
            pars.theta = params(2);
            pars.beta = params(3);   
        elseif strcmp(factor_code,'GOV')
            pars.theta = params(2);
            pars.beta = params(3);
            pars.guess = params(4);
        elseif strcmp(factor_code,'DOV')
            pars.theta = params(2);
            pars.beta = params(3);
            pars.sigma_dn = params(4);
        elseif strcmp(factor_code,'GDOV')
            pars.theta = params(2);
            pars.beta = params(3);
            pars.guess = params(4);
            pars.sigma_dn = params(5);
        end
    else
        pars.p_right = params(1);
        pars.lambda = params(2);
        switch factor_code
            case 'G'
                pars.guess = params(3);
            case 'V'
                pars.theta = params(3);
            case 'GV'
                pars.theta = params(3);
                pars.guess = params(4);
            case 'O'
                pars.beta = params(3);
            case 'GO'
                pars.beta = params(3);
                pars.guess = params(4);
            case 'OV'
                pars.theta = params(3);
                pars.beta = params(4);
            case 'GOV'
                pars.theta = params(3);
                pars.beta = params(4);
                pars.guess = params(5);
            case 'D'
                pars.sigma_dn = params(3);
            case 'GD'
                pars.guess = params(3);
                pars.sigma_dn = params(4);
            case 'DV'
                pars.theta = params(3);
                pars.sigma_dn = params(4);
            case 'GDV'
                pars.theta = params(3);
                pars.guess = params(4);
                pars.sigma_dn = params(5);
            case 'DO'
                pars.beta = params(3);
                pars.sigma_dn = params(4);
            case 'GDO'
                pars.beta = params(3);
                pars.guess = params(4);
                pars.sigma_dn = params(5);
            case 'DOV'
                pars.theta = params(3);
                pars.beta = params(4);
                pars.sigma_dn = params(5);
            case 'GDOV'
                pars.theta = params(3);
                pars.beta = params(4);
                pars.guess = params(5);
                pars.sigma_dn = params(6);
        end
    end
end

f = eval(['@varprecision.decisionrule.exp' num2str(exp_id)]);
pars.model_name = key.model_name;
pars.pre = 0;
pars.model_type = model_type;
pars.rule = rule;
pars.factor_code = factor_code;
pars.prior_type = prior_type;
trial_num_sim = key.trial_num_sim;

predMat = zeros(size(response));

if length(setsizes)==1
    if isempty(strfind(factor_code,'O')) && isempty(strfind(factor_code,'V'))
        if vm == 0
            noiseMat = normrnd(0,1/sqrt(pars.lambda),[setsizes,trial_num_sim]);
        else
            pars.lambda = pars.lambda*180^2/pi^2/4;
            % map jbar to kappa
            pars.lambda = varprecision.utils.mapJK(pars.lambda,jmap,kmap);
            noiseMat = circ_vmrnd(zeros(setsizes,trial_num_sim),pars.lambda)/2;
        end
    elseif isempty(strfind(factor_code,'O')) && ~isempty(strfind(factor_code,'V'))
        pars.lambdaMat = gamrnd(pars.lambda/pars.theta,pars.theta,[setsizes,trial_num_sim]);
        if vm == 0
            noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
        else
            pars.lambdaMat = pars.lambdaMat*180^2/pi^2/4;
            pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
            noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
        end
    elseif ~isempty(strfind(factor_code,'O'))
        sigma_baseline = 1/sqrt(pars.lambda);
    end
    stimuli = varprecision.utils.adjustStimuliSize(exp_id,stimuli,setsizes);
    for ii = 1:length(stimuli)    
        stimulus = stimuli(ii,:);
        if ~isempty(strfind(factor_code,'O')) && isempty(strfind(factor_code,'V'))           
            if vm
                sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus)));
                pars.lambdaMat = 1./sigma.^2*180^2/pi^2/4;
                pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                pars.lambdaMat = repmat(pars.lambdaMat, trial_num_sim,1)';
                noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
            else
                sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus*pi/180)));
                pars.lambdaMat = 1./sigma.^2;
                pars.lambdaMat = repmat(pars.lambdaMat,trial_num_sim,1)';
                noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
            end
        elseif ~isempty(strfind(factor_code,'O')) && ~isempty(strfind(factor_code,'V'))
            
            if vm
                sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus))); 
            else
                sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus*pi/180))); 
            end
                
            pars.lambdaMat = 1./sigma.^2;
            pars.lambdaMat = repmat(pars.lambdaMat, trial_num_sim,1)';
            pars.lambdaMat = gamrnd(pars.lambdaMat/pars.theta,pars.theta);
            if vm
                pars.lambdaMat = pars.lambdaMat*180^2/pi^2/4;
                pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);                       
                noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
            else
                noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
            end
        end
        x = repmat(stimulus',[1,trial_num_sim]) + noiseMat;
        if ismember(key.model_name,{'XP','XPG'})           
            if vm
                sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*x)));
                pars.lambdaMat = 1./sigma.^2*180^2/pi^2/4;
                pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
            else
                sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*x*pi/180)));
                pars.lambdaMat = 1./sigma.^2;
            end
        elseif ismember(key.model_name,{'XPVP','XPVPG'})
            
            if vm
                sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*x)));
            else
                sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*x*pi/180)));
            end
            
            pars.lambdaMat = 1./sigma.^2;
            pars.lambdaMat = gamrnd(pars.lambdaMat/pars.theta,pars.theta);
            if vm
                pars.lambdaMat = pars.lambdaMat*180^2/pi^2/4;         
                pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
            end
            
        end
        predMat(ii) = f(x,pars);    
    end
else
    for jj = 1:length(setsizes)
        setsize = setsizes(jj);
        if ismember(key.exp_id,[7,10,11,12])
            stimuli_sub = stimuli(set_size==setsize,:);
        else
            stimuli_sub = stimuli(set_size==setsize);
        end
        response_sub = response(set_size==setsize);
        if isempty(strfind(factor_code,'O')) && isempty(strfind(factor_code,'V'))
            pars.lambda = pars.lambdaVec(jj);
            if vm == 0            
                noiseMat = normrnd(0,1/sqrt(pars.lambdaVec(jj)),[setsize,trial_num_sim]);
            else
                pars.lambda = pars.lambda*180^2/pi^2/4;
                pars.lambda = varprecision.utils.mapJK(pars.lambda,jmap,kmap);
                noiseMat = circ_vmrnd(zeros(setsize,trial_num_sim),pars.lambda)/2;
            end  
        elseif isempty(strfind(factor_code,'O')) && ~isempty(strfind(factor_code,'V'))
            pars.lambdaMat = gamrnd(pars.lambdaVec(jj)/pars.theta,pars.theta,[setsize,trial_num_sim]);
            if vm == 0
                noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
            else
                pars.lambdaMat = pars.lambdaMat*180^2/pi^2/4;
                pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
            end
        elseif ~isempty(strfind(factor_code,'O'))
            sigma_baseline = 1/sqrt(pars.lambdaVec(jj));
        end
        
        stimuliMat = varprecision.utils.adjustStimuliSize(key.exp_id,stimuli_sub,setsize);
        predMat_sub = zeros(size(response_sub));
        for ii = 1:length(stimuli_sub)
            stimulus = stimuliMat(ii,:);
            if ~isempty(strfind(factor_code,'O')) && isempty(strfind(factor_code,'V'))
                
                if vm
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus)));
                    pars.lambdaMat = 1./sigma.^2*180^2/pi^2/4;
                    pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                    pars.lambdaMat = repmat(pars.lambdaMat, trial_num_sim,1)';
                    noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
                else
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus*pi/180)));
                    pars.lambdaMat = 1./sigma.^2;
                    pars.lambdaMat = repmat(pars.lambdaMat, trial_num_sim,1)';
                    noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
                end
            elseif ~isempty(strfind(factor_code,'O')) && ~isempty(strfind(factor_code,'V'))
                if vm
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus)));
                else
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus*pi/180)));
                end
                pars.lambdaMat = 1./sigma.^2;
                pars.lambdaMat = repmat(pars.lambdaMat, trial_num_sim,1)';
                pars.lambdaMat = gamrnd(pars.lambdaMat/pars.theta,pars.theta);
                if vm
                    pars.lambdaMat = pars.lambdaMat*180^2/pi^2/4;
                    pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap); 
                    noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
                else
                    noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
                end
            end
            x = repmat(stimulus', [1,trial_num_sim]) + noiseMat;
            if ismember(key.model_name,{'XP','XPG'})
                
                if vm
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*x)));
                    pars.lambdaMat = 1./sigma.^2*180^2/pi^2/4;
                    pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                else
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*x*pi/180)));
                    pars.lambdaMat = 1./sigma.^2;
                end
            elseif ismember(key.model_name,{'XPVP','XPVPG'})
                if vm
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*x)));
                else
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*x*pi/180)));
                end
                pars.lambdaMat = 1./sigma.^2;
                pars.lambdaMat = gamrnd(pars.lambdaMat/pars.theta,pars.theta);
                if vm
                    pars.lambdaMat = pars.lambdaMat*180^2/pi^2/4;         
                    pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                end
            end
        	predMat_sub(ii) = f(x,pars);
        end
        predMat(set_size==setsize) = predMat_sub;
    end
end
    
predMat(predMat==0) = 1/trial_num_sim;
predMat(predMat==1) = 1 - 1/trial_num_sim;

if ~isempty(strfind(factor_code,'G'))
    predMat = predMat*(1-pars.guess) + .5*pars.guess;
end

prediction = predMat;

if ~ismember(key.exp_id,[10,11,12])
    predMat(response==-1) = 1-predMat(response==-1);
else
    predMat(response==0) = 1-predMat(response==0);
end


LL = -sum(log(predMat));