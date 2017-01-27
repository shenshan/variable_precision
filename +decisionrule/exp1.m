function [prediction, response] = exp1(x,pars)
%EXP1 computes prediction of reporting right given noisy
%measurements and model parameters for exp1

%   x is the noisy sensory measurements, could be a vector or
%   a matrix (1 x N_trials) or (N_stimuli x N_trials)
%   pars is the parameters used in this model, usually composed of the
%   following fields: pars.model 'CP', 'VP', pars.lambda,
%   pars.p_right. pars.lambda is scalar for CP model, pars.lambdaMat is matrix for VP model,
%   and pars.p_right is a vector
%   pars.pre indicates whether it is to generate a pre-computed table.
    
    x = squeeze(x);
    nTrials = size(x, 2);
    nStimuli = size(x, 1); 
        
    p_right_adj = repmat(permute(pars.p_right,[3,1,2]),[nStimuli,nTrials,1]);
    
    if ismember(pars.model_name, {'CP','CPG','CPN','CPGN'})
        pars.lambdaMat = pars.lambda;
    else
        pars.lambdaMat = squeeze(pars.lambdaMat);
    end
    x_c = x.*pars.lambdaMat./sqrt(2.*(pars.lambdaMat+1/pars.sigma_s^2));
    
    term1 = 1+erf(x_c);
    term2 = 1-erf(x_c);
    
    obs_response = bsxfun(@times,repmat(term1,[1,1,length(pars.p_right)]),p_right_adj)./bsxfun(@times,repmat(term2,[1,1,length(pars.p_right)]),(1-p_right_adj));
    
    if ismember(pars.model_name,{'CPN','CPGN','VPN','VPGN','OPN','OPGN','OPVPN','OPVPGN'})
        obs_response = normrnd(obs_response,pars.sigma_dn);
    end
    
    prediction = (sum(obs_response>1,2) + .5*sum(obs_response==1,2))/nTrials;
    prediction = squeeze(prediction);
    response = obs_response;
    response(obs_response>=1) = 1;
    response(obs_response<1) = -1;