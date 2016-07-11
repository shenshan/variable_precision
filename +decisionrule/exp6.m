function [prediction, response] = exp6(x,pars)
%EXP6 computes prediction of reporting right given noisy
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
    tKappa = 10; 
    p_right_adj = repmat(permute(pars.p_right,[3,1,2]),[nStimuli,nTrials,1]);
    
    if ismember(pars.model_name,{'CP','CPG'})
        
%         entire_int = sum(pi*besseli0_fast(sqrt(pars.lambda^2 + tKappa^2 + 2*tKappa*pars.lambda*cos(2*x))),1);
        term1 = sum(vmproductcdf_trapz_CP(kappa(kk), tKappa, x, 0, pi/2, nItems,30),1);
        term2 = sum(vmproductcdf_trapz_CP(kappa(kk), tKappa, x, -pi/2, 0, nItems,30),1);
%         term2 = entire_int - temp1;
            
    elseif ismember(pars.model_name,{'VP','VPG'})
%         entire_int = sum(pi*besseli0_fast(sqrt(pars.lambdaMat.^2 + tKappa^2 + 2*tKappa*pars.lambdaMat.*cos(2*x))),1);
%         disp(['besseli time: ' num2str(toc) ' sec'])
%         tic
        term1 = sum(vmproductcdf_trapz(pars.lambdaMat, tKappa, x,  0, pi/2, 30),1);
        term2 = sum(vmproductcdf_trapz(pars.lambdaMat, tKappa, x,  -pi/2, 0, 30),1);
%         disp(['vmcdf time: ' num2str(toc) ' sec'])
%         term2 = entire_int - term1;
    end
    
    obs_response = bsxfun(@times,repmat(term1,[1,1,length(pars.p_right)]),p_right_adj) - bsxfun(@times,repmat(term2,[1,1,length(pars.p_right)]),(1-p_right_adj));
    prediction = (sum(obs_response>0,2) + .5*sum(obs_response==0,2))/nTrials;
    prediction = squeeze(prediction);

    
    response = obs_response;
    response(obs_response>0) = 1;
    response(obs_response<=0) = -1;