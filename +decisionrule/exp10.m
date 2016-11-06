function [prediction, response] = exp10(x,pars)
%EXP10 computes prediction of reporting right given noisy, Gaussian
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
    
    j0 = 0.0394;
    
    
    if ismember(pars.model_name, {'CP','CPG'})
        pars.lambdaMat = pars.lambda;
    end
    if nItems == 1
        term = sqrt(pars.lambdaMat/j0)./exp(x.^2.*pars.lambdaMat./(pars.lambdaMat + j0));
    else
        J_sum_dis = bsxfun(@minus,sum(pars.lambdaMat),pars.lambdaMat) + j0;
        x2J_sum_dis = bsxfun(@minus,sum(x.^2.*pars.lambdaMat),x.^2.*pars.lambdaMat);
        
        J_sum = sum(pars.lambdaMat)+j0;
        x2J_sum = sum(x.^2.*pars.lambdaMat);
        nomi = sum(1./sqrt(J_sum_dis).*exp(x2J_sum_dis./J_sum_dis))/nItems;
        denomi = 1./sqrt(J_sum).*exp(x2J_sum./J_sum);
        term = nomi./denomi;
    end
    
    obs_response = bsxfun(@times,repmat(term,[1,1,length(pars.p_right)]),p_right_adj./(1-p_right_adj));
    prediction = (sum(obs_response>1,2) + .5*sum(obs_response==1,2))/nTrials;
    prediction = squeeze(prediction);
    response = squeeze(obs_response);
    response(obs_response>1) = 1;
    response(obs_response<=1) = 0;