function [prediction, response] = exp8(x,pars)
%EXP8 computes prediction of reporting right given noisy
%measurements and model parameters, this one does not work for pre table

%   function [prediction, response] = exp8(x,pars)
%   x is the noisy sensory measurements, could be a vector (N_items x 1) or
%   a matrix (N_items x N_trials) or (N_items x N_stimuli x N_trials)
%   pars is the parameters used in this model, usually composed of the
%   following fields: pars.model 'CP', 'VP', pars.lambda,
%   pars.p_right. pars.lambda is scalar for CP model, pars.lambdaMat is matrix for VP model,
%   and pars.p_right is a vector
%   pars.pre indicates whether it is to generate a pre-computed table.
    
    nTrials = size(x, 2);
    x = x(1,:) - x(2,:);
    
    Js = 1/9.06^2;
        
    if ismember(pars.model_name,{'CP','CPG','CPN','CPGN'})
        JL = pars.lambda;
        JR = pars.lambda;
    else
        JL = pars.lambdaMat(1,:);
        JR = pars.lambdaMat(2,:);
    end
        Jc = 1./(1./JL+1./JR);
        erf_x = erf(x.*Jc./sqrt(Jc+Js));
        term1 = 1+erf_x;
        term2 = 1-erf_x;
    
    obs_response = term1*pars.p_right./term2*(1-pars.p_right);
    
    if ismember(pars.model_name,{'CPN','CPGN','VPN','VPGN','OPN','OPGN','OPVPN','OPVPGN'})
        obs_response = normrnd(obs_response,pars.sigma_dn);
    end
    
    prediction = (sum(obs_response>1) + .5*sum(obs_response==1))/nTrials;
   
    response = obs_response;
    response(obs_response>=1) = 1;
    response(obs_response<1) = -1;

