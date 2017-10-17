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
    
    std_s = pars.sigma_s;
    lambda = pars.lambda;
    
    factor_code_CP = {'Base','G','D','GD'};
    
    idx_temp = 1:nItems;
    term2 = zeros(size(x));
    term3 = zeros(size(x));
    
    if ismember(pars.factor_code, factor_code_CP)
        sigma = 1/sqrt(pars.lambda);
        for ii = 1:nItems
            temp = x(idx_temp~=ii,:);            
            term2(ii,:) = mean(temp).^2/(sigma^2/(nItems-1) + std_s^2);
            term3(ii,:) = var(temp,1)*(nItems-1)*lambda;
        end
        term1 = x.^2/(sigma^2 + std_s^2);
        x_c = x*pars.lambda/sqrt(2*(pars.lambda+lambda_s));
        prefactor = 1;
    else
        sigmaMat = 1./sqrt(pars.lambdaMat);
        prefactor = zeros(size(x));
        for ii = 1:nItems
            x_temp = x(idx_temp~=ii,:);
            lambda_temp = pars.lambdaMat(idx_temp~=ii,:);
            prefactor(ii,:) = sqrt(1./(sum(lambda_temp) + lambda_s));
            x_avg = sum(x_temp.*lambda_temp)./sum(lambda_temp);
            x2_avg = sum(x_temp.^2.*lambda_temp)./sum(lambda_temp);
            term2(ii,:) = (x_avg).^2./(1./sum(lambda_temp)+std_s^2);
            term3(ii,:) = sum(bsxfun(@times,lambda_temp,(x2_avg - x_avg.^2)));
        end
        term1 = x.^2./(sigmaMat.^2 + std_s^2);
        prefactor = prefactor.*sqrt(1./pars.lambdaMat + lambda_s);
        x_c = x.*pars.lambdaMat./sqrt(2*(pars.lambdaMat+lambda_s));
    end
    
    switch pars.rule
        case 'Opt'
            f = prefactor.*exp(-(term1+term2+term3)/2);
            term_r = squeeze(sum((1+erf(x_c)).*f));
            term_l = squeeze(sum((1-erf(x_c)).*f));
        case 'Sum'
            obs_response = sum(x);
        case 'Max'
            [~,idx] = max(abs(x));
            idx = sub2ind(size(x), idx, 1:nTrials);
            obs_response = x(idx);
        case 'Min'
            [~,idx] = min(abs(x));
            idx = sub2ind(size(x), idx, 1:nTrials);
            obs_response = x(idx);
        case 'Var'
            corr_x = zeros(size(x));
            idx_temp = 1:nItems;
            for jj = 1:nItems
                temp = x(idx_temp~=jj,:);
                corr_x(jj,:) = std(temp);        
            end
            [~,idx] = min(corr_x);
            idx = sub2ind(size(x), idx, 1:nTrials);	
            obs_response = x(idx);
        case 'Sign'
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
        case 'Max2'
            [~,idx] = min(abs(term2));
            idx = sub2ind(size(x),idx,1:nTrials);
            obs_response = x(idx);
        case 'Max12'      
            [~,idx] = min(term1+term2);
            idx = sub2ind(size(x), idx, 1:nTrials);	
            obs_response = x(idx);
        case 'Max13'
            [~,idx] = min(term1+term3);
            idx = sub2ind(size(x), idx, 1:nTrials);	
            obs_response = x(idx);
        case 'Max23'
            [~,idx] = min(term2+term3);
            idx = sub2ind(size(x), idx, 1:nTrials);	
            obs_response = x(idx);
        case 'Max123'
            [~,idx] = min(term1+term2+term3);
            idx = sub2ind(size(x), idx, 1:nTrials);	
            obs_response = x(idx);
        case 'SumErf'
            term_r = squeeze(sum(1+erf(x_c).*prefactor));
            term_l = squeeze(sum(1-erf(x_c).*prefactor));
        case 'SumErf1'
            f = prefactor.*exp(-term1/2);
            term_r = squeeze(sum((1+erf(x_c)).*f));
            term_l = squeeze(sum((1-erf(x_c)).*f));
        case 'SumErf2'
            f = prefactor.*exp(-term2/2);
            term_r = squeeze(sum((1+erf(x_c)).*f));
            term_l = squeeze(sum((1-erf(x_c)).*f));
        case 'SumErf3'
            f = prefactor.*exp(-term3/2);
            term_r = squeeze(sum((1+erf(x_c)).*f));
            term_l = squeeze(sum((1-erf(x_c)).*f));
        case 'SumErf12'
            f = prefactor.*exp(-(term1+term2)/2);
            term_r = squeeze(sum((1+erf(x_c)).*f));
            term_l = squeeze(sum((1-erf(x_c)).*f));
        case 'SumErf13'
            f = prefactor.*exp(-(term1+term3)/2);
            term_r = squeeze(sum((1+erf(x_c)).*f));
            term_l = squeeze(sum((1-erf(x_c)).*f));
        case 'SumErf23'
            f = prefactor.*exp(-(term2+term3)/2);
            term_r = squeeze(sum((1+erf(x_c)).*f));
            term_l = squeeze(sum((1-erf(x_c)).*f));
        case 'SumX1'
            obs_response = sum(x.*exp(-term1/2));
        case 'SumX2'
            obs_response = sum(x.*exp(-term2/2));
        case 'SumX3'
            obs_response = sum(x.*exp(-term3/2));
        case 'SumX12'
            obs_response = sum(x.*exp(-(term1+term2)/2));
        case 'SumX13'
            obs_response = sum(x.*exp(-(term1+term3)/2));
        case 'SumX23'
            obs_response = sum(x.*exp(-(term2+term3)/2));
        case 'SumX123'
            obs_response = sum(x.*exp(-(term1+term2+term3)/2));
            
    end
   
    if ismember(pars.model_type,{'opt','SumErf'})
        p_right_adj = repmat(permute(pars.p_right,[3,1,2]),[nStimuli,nTrials,1]);
        obs_response = log(bsxfun(@times,repmat(term_r,[1,1,length(pars.p_right)]),p_right_adj)./bsxfun(@times,repmat(term_l,[1,1,length(pars.p_right)]),(1-p_right_adj)));
    end
    
    if ~isempty(strfind(pars.factor_code,'D'))
        obs_response = normrnd(obs_response,pars.sigma_dn);
    end
    
    prediction = (sum(obs_response>0,2) + .5*sum(obs_response==0,2))/nTrials;
    prediction = squeeze(prediction);
    response = obs_response;
    response(obs_response>=0) = 1;
    response(obs_response<0) = -1;