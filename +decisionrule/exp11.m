function [prediction, response] = exp11(x,pars)
%EXP11 computes prediction of reporting right given noisy
%measurements and model parameters, this one does not work for pre table

%   function [prediction, response] = exp11(x,pars)
%   x is the noisy sensory measurements, could be a vector (N_items x 1) or
%   a matrix (N_items x N_trials) or (N_items x N_stimuli x N_trials)
%   pars is the parameters used in this model, usually composed of the
%   following fields: pars.model 'CP', 'VP', pars.lambda,
%   pars.p_right. pars.lambda is scalar for CP model, pars.lambdaMat is matrix for VP model,
%   and pars.p_right is a vector
%   pars.pre indicates whether it is to generate a pre-computed table.
    
    if pars.pre
        nTrials = size(x, 3);
        nStimuli = size(x, 2); 
    else
        nTrials = size(x, 2);
        nStimuli = 1;
    end
    nItems = size(x,1);
    p_right_adj = repmat(permute(pars.p_right,[3,1,2]),[nStimuli,nTrials,1]);
    
    if ismember(pars.model_name,{'CP','CPG','CPN','CPGN'})
        term = squeeze(1/nItems*sum(exp(pars.lambda*cos(2*x))/besseli0_fast(pars.lambda),1));
    else
        term = squeeze(1/nItems*sum(exp(pars.lambdaMat.*(cos(2*x)-1))./besseli0_fast(pars.lambdaMat,1),1));
    end
    
    obs_response = bsxfun(@times,repmat(term,[1,1,length(pars.p_right)]),p_right_adj./(1-p_right_adj));
    
    if ismember(pars.model_name,{'CPN','CPGN','VPN','VPGN','OPN','OPGN','OPVPN','OPVPGN'})
        obs_response = normrnd(obs_response,pars.sigma_dn);
    end
    prediction = (sum(obs_response>1,2) + .5*sum(obs_response==1,2))/nTrials;
    prediction = squeeze(prediction);
    response = squeeze(obs_response);
    response(obs_response>=1) = 1;
    response(obs_response<1) = 0;