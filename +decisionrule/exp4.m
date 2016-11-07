function [prediction, response] = exp4(x,pars)
%EXP4 computes prediction of reporting right given noisy
%measurements and model parameters

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
        
        p_right_adj = repmat(permute(pars.p_right,[3,1,2]),[nStimuli,nTrials,1]);
    
    if ismember(pars.model_name,{'CP','CPG'})
        sigma = sqrt(1/pars.lambda);
        f = exp(x.^2*pars.sigma_s^2/2/sigma^2/(sigma^2+pars.sigma_s^2));
        x_c = pars.lambda*x/sqrt(2*(pars.lambda + 1/pars.sigma_s^2));

        term1 = squeeze(sum (f.*(1 + erf(x_c)),1));
        term2 = squeeze(sum (f.*(1 - erf(x_c)),1));

            
    else
        sigmaMat = sqrt(1./pars.lambdaMat);
        logf = x.^2*pars.sigma_s^2/2./sigmaMat.^2./(sigmaMat.^2 + pars.sigma_s^2);
        % subtract constant to avoid numerical problems
        logf_max = max(logf);
        logf = bsxfun(@minus, logf, logf_max);
        f = exp(logf);
        x_c = pars.lambdaMat.*x./sqrt(2*(pars.lambdaMat + 1/pars.sigma_s^2));

        term1 = squeeze(sum(sigmaMat./sqrt(sigmaMat.^2 + pars.sigma_s^2).*f.* (1 + erf(x_c)),1));
        term2 = squeeze(sum(sigmaMat./sqrt(sigmaMat.^2 + pars.sigma_s^2).*f.* (1 - erf(x_c)),1));
            
    end
    
    obs_response = bsxfun(@times,repmat(term1,[1,1,length(pars.p_right)]),p_right_adj) - bsxfun(@times,repmat(term2,[1,1,length(pars.p_right)]),(1-p_right_adj));
    prediction = (sum(obs_response>0,2) + .5*sum(obs_response==0,2))/nTrials;
    prediction = squeeze(prediction);
    response = obs_response;
    response(obs_response>0) = 1;
    response(obs_response<=0) = -1;