function [prediction, response] = exp9(x,pars)
%EXP9 computes prediction of reporting right given noisy
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
    nItems = size(x,1);
        
    lambda_s = 1/pars.sigma_s^2;
    
    if ismember(pars.model_name,{'CP','CPG','CPN','CPGN'})
        
        sigma = 1/sqrt(pars.lambda);
        term = zeros(size(x));
        for jj = 1:nItems
            term(jj,:) = ((sum(x)-x(jj,:)).*pars.lambda).^2/((nItems-1)*pars.lambda + lambda_s)/2 - (sum(x.^2) - x(jj,:).^2)*pars.lambda/2;
        end
        f = exp(-x.^2/(sigma^2+pars.sigma_s^2)/2).*exp(term);
        x_c = x*pars.lambda/sqrt(2*(pars.lambda+lambda_s));
        term1 = squeeze(sum((1+erf(x_c)).*f));
        term2 = squeeze(sum((1-erf(x_c)).*f));
            
    elseif ismember(pars.model_name,{'OP','OPG','OPN','OPGN','OPVP','OPVPG','OPVPN','OPVPGN','XP','XPG','XPVP','XPVPG'})
        sigmaMat = sqrt(1./pars.lambdaMat);
        
        term = zeros(size(x));
        prefactor = zeros(size(x));
        temp1 = x.*pars.lambdaMat;
        temp2 = x.^2.*pars.lambdaMat;
        for jj = 1:nItems
            prefactor(jj,:) = sqrt(1./(sum(pars.lambdaMat) - pars.lambdaMat(jj,:) + lambda_s));
            term(jj,:) = (sum(temp1)-temp1(jj,:)).^2./(sum(pars.lambdaMat) - pars.lambdaMat(jj,:) + lambda_s)/2 - (sum(temp2) - temp2(jj,:))/2;
        end
        f = exp(-x.^2./(sigmaMat.^2+pars.sigma_s^2)/2).*exp(term).*prefactor.*sqrt(1./(pars.lambdaMat + lambda_s));
        x_c = x.*pars.lambdaMat./sqrt(2*(pars.lambdaMat+lambda_s));
        term1 = squeeze(sum((1+erf(x_c)).*f));
        term2 = squeeze(sum((1-erf(x_c)).*f));
    elseif ismember(pars.model_name,{'GSum','OPVPGSum'})
        obs_response = sum(x);
    elseif ismember(pars.model_name,{'GMax','OPVPGMax'})
        [~,idx] = max(abs(x));
        idx = sub2ind(size(x), idx, 1:nTrials);
        obs_response = x(idx);
    elseif ismember(pars.model_name,{'GMin','OPVPGMin'})
        [~,idx] = min(abs(x));
        idx = sub2ind(size(x), idx, 1:nTrials);
        obs_response = x(idx);
    elseif ismember(pars.model_name,{'GVar','OPVPGVar'})
        corr_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp = x(idx_temp~=jj,:);
            corr_x(jj,:) = std(temp);        
        end
        [~,idx] = min(corr_x);
        idx = sub2ind(size(x), idx, 1:nTrials);	
        obs_response = x(idx);
    elseif ismember(pars.model_name,{'GSign','OPVPGSign'})
        temp = sign(x);
        sum_x = sum(temp);
        obs_response = zeros(1,length(x));
        % all the measurements have the same sign
        obs_response(sum_x==nItems) = 1;
        obs_response(sum_x==-nItems) = -1;
        % reports the orientation that has the least number of
        % items, this only works for 4 items.
        obs_response(sum_x==2) = -1;
        obs_response(sum_x==-2) = 1; 
    end
    
    if ~ismember(pars.model_name,{'OPVPGSum','OPVPGMax','OPVPGMin','OPVPGVar','OPVPGSign','GSum','GMax','GMin','GVar','GSign'})
        p_right_adj = repmat(permute(pars.p_right,[3,1,2]),[nStimuli,nTrials,1]);
        obs_response = log(bsxfun(@times,repmat(term1,[1,1,length(pars.p_right)]),p_right_adj)./bsxfun(@times,repmat(term2,[1,1,length(pars.p_right)]),(1-p_right_adj)));
    end
    
    if ismember(pars.model_name,{'CPN','CPGN','VPN','VPGN','OPN','OPGN','OPVPN','OPVPGN'})
        obs_response = normrnd(obs_response,pars.sigma_dn);
    end
    
    prediction = (sum(obs_response>0,2) + .5*sum(obs_response==0,2))/nTrials;
    prediction = squeeze(prediction);
    response = obs_response;
    response(obs_response>=0) = 1;
    response(obs_response<0) = -1;