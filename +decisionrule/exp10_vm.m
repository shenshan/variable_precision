function [prediction, response] = exp10_vm(x,pars)
%EXP10 computes prediction of reporting right given noisy
%measurements and model parameters, this one does not work for pre table

%   function [prediction, response] = exp10(x,pars)
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
    
    sT = 0;
    k0 = 32.8;
    
    if ismember(pars.model_name, {'CP','CPG'})
        pars.lambdaMat = pars.lambda;
    end
    if nItems == 1
        kappa1 = k0;
        kappa0 = sqrt((k0.*cos(2*sT)+pars.lambdaMat.*cos(2*x)).^2 ...
                    + (k0.*sin(2*sT)+pars.lambdaMat.*sin(2*x)).^2);
        term = exp(pars.lambdaMat.*cos(2*(x-sT))+kappa1-kappa0).*besseli0_fast(kappa1,1)./besseli0_fast(kappa0,1);
    else
        kappa1 = sqrt((repmat(sum(pars.lambdaMat.*cos(2*x)),nItems,1) - pars.lambdaMat.*cos(2*x) + k0*cos(2*sT)).^2 ...
                   + ((repmat(sum(pars.lambdaMat.*sin(2*x)),nItems,1) - pars.lambdaMat.*sin(2*x) + k0*sin(2*sT)).^2));
        kappa0 = sqrt((sum(pars.lambdaMat.*cos(2*x)) + k0*cos(2*sT)).^2 ...
                    + (sum(pars.lambdaMat.*sin(2*x)) + k0*sin(2*sT)).^2);
        kappa0 = repmat(kappa0,nItems,1);
        term = sum(exp(pars.lambdaMat.*cos(2*(x-sT))+kappa1-kappa0).*besseli0_fast(kappa1,1)./besseli0_fast(kappa0,1))/nItems;
    end
    
    obs_response = bsxfun(@times,repmat(term,[1,1,length(pars.p_right)]),p_right_adj./(1-p_right_adj));
    prediction = (sum(obs_response>1,2) + .5*sum(obs_response==1,2))/nTrials;
    prediction = squeeze(prediction);
    response = squeeze(obs_response);
    response(obs_response>1) = 1;
    response(obs_response<=1) = 0;
