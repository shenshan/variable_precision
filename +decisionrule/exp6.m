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
    
    if ismember(pars.model_name,{'CP','CPG','CPN','CPGN'})
        term1 = sum(vmproductcdf_trapz_CP(pars.lambda, tKappa, x, 0, pi/2, nItems,30),1);
        term2 = sum(vmproductcdf_trapz_CP(pars.lambda, tKappa, x, -pi/2, 0, nItems,30),1);            
    elseif ismember(pars.model_name,{'VP','VPG','OP','OPG','OPVP','OPVPG','XP','XPG','XPVP','XPVPG','VPN','VPGN','OPN','OPGN','OPVPN','OPVPGN'})
        term1 = sum(vmproductcdf_trapz(pars.lambdaMat, tKappa, x,  0, pi/2, 30,pars.lambdaMat)./besseli0_fast(pars.lambdaMat,1),1);
        term2 = sum(vmproductcdf_trapz(pars.lambdaMat, tKappa, x,  -pi/2, 0, 30,pars.lambdaMat)./besseli0_fast(pars.lambdaMat,1),1);
    elseif strcmp(pars.model_type,'sub')
        [~,idx] = min(abs(x));
        idx = sub2ind(size(x), idx, 1:nTrials);
        obs_response = x(idx);
    end
   
    if strcmp(pars.rule,'opt')
        p_right_adj = repmat(permute(pars.p_right,[3,1,2]),[nStimuli,nTrials,1]);
        obs_response = log(bsxfun(@times,repmat(term1,[1,1,length(pars.p_right)]),p_right_adj)./bsxfun(@times,repmat(term2,[1,1,length(pars.p_right)]),(1-p_right_adj)));
    end

    if ~isempty(strfind(pars.factor_code,'D'))
        obs_response = normrnd(obs_response,pars.sigma_dn);
    end
    
    prediction = (sum(obs_response>0,2) + .5*sum(obs_response==0,2))/nTrials;
    prediction = squeeze(prediction);

    
    response = obs_response;
    response(obs_response>=0) = 1;
    response(obs_response<0) = -1;