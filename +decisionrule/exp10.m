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
        pars.lambdaMat = pars.lambda*ones(size(x));
    end
    if nItems == 1
        term = sqrt((pars.lambdaMat+j0)/j0)./exp(.5*x.^2.*pars.lambdaMat.^2./(pars.lambdaMat + j0));
    else
        J_sum_dis = bsxfun(@minus,sum(pars.lambdaMat,1),pars.lambdaMat) + j0;
        xJ_sum_dis = bsxfun(@minus,sum(x.*pars.lambdaMat,1),x.*pars.lambdaMat);

        J_sum = sum(pars.lambdaMat,1) + j0;
        xJ_sum = sum(x.*pars.lambdaMat,1);
        nomi = sum(1./sqrt(J_sum_dis).*exp(0.5.*bsxfun(@minus, xJ_sum_dis.^2./J_sum_dis, xJ_sum.^2./J_sum)),1)/nItems;
        denomi = 1./sqrt(J_sum);
        term = nomi./denomi;
    end
    
    obs_response = bsxfun(@times,repmat(term,[1,1,length(pars.p_right)]),p_right_adj./(1-p_right_adj));
    prediction = (sum(obs_response>1,2) + .5*sum(obs_response==1,2))/nTrials;
    prediction = squeeze(prediction);
    response = squeeze(obs_response);
    response(obs_response>1) = 1;
    response(obs_response<=1) = 0;