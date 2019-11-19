function [prediction, response] = exp12(x,pars)
%EXP12 computes prediction of reporting right given noisy, Gaussian
%measurements and model parameters, this one does not work for pre table

%   function [prediction, response] = exp12(x,pars)
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
    
    j0 = 0.0394;
    
    
    if ismember(pars.model_name, {'CP','CPG','CPN','CPGN'})
        pars.lambdaMat = pars.lambda*ones(size(x));
    end
    
    sigma0 = 1/sqrt(j0);
    sigmaMat = 1./sqrt(pars.lambdaMat);
    sigma_c = sqrt(sigma0^2+sigmaMat.^2);
    
    term = squeeze(1/nItems*sum(sigma_c./sigmaMat.*exp(-0.5*x.^2.*(1./sigmaMat.^2-1./sigma_c.^2)),1));
   
    obs_response = log(bsxfun(@times,repmat(term,[1,1,length(pars.p_right)]),p_right_adj./(1-p_right_adj)));
    
    if ismember(pars.model_name,{'CPN','CPGN','VPN','VPGN','OPN','OPGN','OPVPN','OPVPGN'})
        obs_response = normrnd(obs_response,pars.sigma_dn);
    end
    
    prediction = (sum(obs_response>0,2) + .5*sum(obs_response==0,2))/nTrials;
    prediction = squeeze(prediction);
    response = squeeze(obs_response);
    response(obs_response>=0) = 1;
    response(obs_response<0) = 0;