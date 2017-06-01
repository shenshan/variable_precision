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
    
    if strcmp(pars.model_type,'sub')
        sigma = 1/sqrt(pars.lambda);
        std_s = pars.sigma_s;
        lambda = pars.lambda;
    end
    
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
            
    elseif ismember(pars.model_name,{'OP','OPG','OPN','OPGN','OPVP','OPVPG','OPVPN','OPVPGN','VP','VPN','VPG','VPGN','XP','XPG','XPVP','XPVPG'})
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
    elseif strcmp(pars.rule,'Sum')
        obs_response = sum(x);
    elseif strcmp(pars.rule,'Max')
        [~,idx] = max(abs(x));
        idx = sub2ind(size(x), idx, 1:nTrials);
        obs_response = x(idx);
    elseif strcmp(pars.rule,'Min')
        [~,idx] = min(abs(x));
        idx = sub2ind(size(x), idx, 1:nTrials);
        obs_response = x(idx);
    elseif strcmp(pars.rule,'Var')
        corr_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp = x(idx_temp~=jj,:);
            corr_x(jj,:) = std(temp);        
        end
        [~,idx] = min(corr_x);
        idx = sub2ind(size(x), idx, 1:nTrials);	
        obs_response = x(idx);
    elseif strcmp(pars.rule,'Sign')
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
    elseif strcmp(pars.rule,'Max2')
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp = x(idx_temp~=jj,:);
            term_x(jj,:) = mean(temp);
        end
        [~,idx] = min(abs(term_x));
        idx = sub2ind(size(x),idx,1:nTrials);
        obs_response = x(idx);
    elseif strcmp(pars.rule,'Max12')
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp1 = x(idx_temp==jj,:);
            temp2 = x(idx_temp~=jj,:);
            term_x(jj,:) = temp1.^2/(sigma^2 + std_s^2) + mean(temp2).^2/(sigma^2/(nItems-1) + std_s^2);
        end
        [~,idx] = min(term_x);
        idx = sub2ind(size(x), idx, 1:nTrials);	
        obs_response = x(idx);
    elseif strcmp(pars.rule,'Max13')
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp1 = x(idx_temp==jj,:);
            temp2 = x(idx_temp~=jj,:);
            term_x(jj,:) = temp1.^2/(sigma^2 + std_s^2) + ...
                var(temp2,1)*(nItems-1)*lambda;
        end
        [~,idx] = min(term_x);
        idx = sub2ind(size(x), idx, 1:nTrials);	
        obs_response = x(idx);
    elseif strcmp(pars.rule,'Max23')
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp = x(idx_temp~=jj,:);
            term_x(jj,:) = mean(temp).^2/(sigma^2/(nItems-1) + std_s^2) + var(temp,1)*(nItems-1)*lambda;
        end
        [~,idx] = min(term_x);
        idx = sub2ind(size(x), idx, 1:nTrials);	
        obs_response = x(idx);
    elseif strcmp(pars.rule,'Max123')
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp1 = x(idx_temp==jj,:);
            temp2 = x(idx_temp~=jj,:);
            term_x(jj,:) = temp1.^2/(sigma^2 + std_s^2) + mean(temp2).^2/(sigma^2/(nItems-1) + std_s^2) + var(temp2,1)*(nItems-1)*lambda;
        end
        [~,idx] = min(term_x);
        idx = sub2ind(size(x), idx, 1:nTrials);	
        obs_response = x(idx); 
    elseif strcmp(pars.rule,'SumErf')
        x_c = x*lambda/(lambda + lambda_s);
        std_c = 1/sqrt(lambda + lambda_s);
        obs_response = sum(1-2*normcdf(0,x_c, std_c));
    elseif strcmp(pars.rule,'SumErf1')
        x_c = x*lambda/(lambda + lambda_s);
        std_c = 1/sqrt(lambda + lambda_s);
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp1 = x(idx_temp==jj,:);
            term_x(jj,:) = temp1.^2/(sigma^2 + std_s^2);
        end
        obs_response = sum(exp(-term_x/2).*(1-2*normcdf(0,x_c,std_c)));
    elseif strcmp(pars.rule,'SumErf2')
         x_c = x*lambda/(lambda + lambda_s);
        std_c = 1/sqrt(lambda + lambda_s);
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp2 = x(idx_temp~=jj,:);
            term_x(jj,:) = mean(temp2).^2/(sigma^2/(nItems-1) + std_s^2);
        end
        obs_response = sum(exp(-term_x/2).*(1-2*normcdf(0,x_c,std_c)));
    elseif strcmp(pars.rule,'SumErf3')
        x_c = x*lambda/(lambda + lambda_s);
        std_c = 1/sqrt(lambda + lambda_s);
        corr_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp = x(idx_temp~=jj,:);
            corr_x(jj,:) = var(temp,1)*(nItems-1)*lambda;
        end
        obs_response = sum(exp(-corr_x/2).*(1-2*normcdf(0,x_c,std_c)));
    elseif strcmp(pars.rule,'SumErf12')
        x_c = x*lambda/(lambda + lambda_s);
        std_c = 1/sqrt(lambda + lambda_s);
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp1 = x(idx_temp==jj,:);
            temp2 = x(idx_temp~=jj,:);
            term_x(jj,:) = temp1.^2/(sigma^2 + std_s^2) + mean(temp2).^2/(sigma^2/(nItems-1) + std_s^2);
        end
        obs_response = sum(exp(-term_x/2).*(1-2*normcdf(0,x_c,std_c)));
    elseif strcmp(pars.rule,'SumErf13')
        x_c = x*lambda/(lambda + lambda_s);
        std_c = 1/sqrt(lambda + lambda_s);
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp1 = x(idx_temp==jj,:);
            temp2 = x(idx_temp~=jj,:);
            term_x(jj,:) = temp1.^2/(sigma^2 + std_s^2) + ...
                var(temp2,1)*(nItems-1)*lambda;
        end
        obs_response = sum(exp(-term_x/2).*(1-2*normcdf(0,x_c,std_c)));
    elseif strcmp(pars.rule,'SumErf23')
        x_c = x*lambda/(lambda + lambda_s);
        std_c = 1/sqrt(lambda + lambda_s);
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp = x(idx_temp~=jj,:);
            term_x(jj,:) = mean(temp).^2/(sigma^2/(nItems-1) + std_s^2) + var(temp,1)*(nItems-1)*lambda;
        end
        obs_response = sum(exp(-term_x/2).*(1-2*normcdf(0,x_c,std_c)));
    elseif strcmp(pars.rule,'SumX1')
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp1 = x(idx_temp==jj,:);
            term_x(jj,:) = temp1.^2/(sigma^2 + std_s^2);
        end
        obs_response = sum(x.*exp(-term_x/2));
    elseif strcmp(pars.rule,'SumX2')
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp2 = x(idx_temp~=jj,:);
            term_x(jj,:) = mean(temp2).^2/(sigma^2/(nItems-1) + std_s^2);
        end
        obs_response = sum(x.*exp(-term_x/2));
    elseif strcmp(pars.rule,'SumX3')
        corr_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp = x(idx_temp~=jj,:);
            corr_x(jj,:) = var(temp,1)*(nItems-1)*lambda;
        end
        obs_response = sum(x.*exp(-corr_x/2));
    elseif strcmp(pars.rule,'SumX12')
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp1 = x(idx_temp==jj,:);
            temp2 = x(idx_temp~=jj,:);
            term_x(jj,:) = temp1.^2/(sigma^2 + std_s^2) + mean(temp2).^2/(sigma^2/(nItems-1) + std_s^2);
        end
        obs_response = sum(x.*exp(-term_x/2));
    elseif strcmp(pars.rule,'SumX13')
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp1 = x(idx_temp==jj,:);
            temp2 = x(idx_temp~=jj,:);
            term_x(jj,:) = temp1.^2/(sigma^2 + std_s^2) + ...
                var(temp2,1)*(nItems-1)*lambda;
        end
        obs_response = sum(x.*exp(-term_x/2));
    elseif strcmp(pars.rule,'SumX23')
        term_x = zeros(size(x));
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp = x(idx_temp~=jj,:);
            term_x(jj,:) = mean(temp).^2/(sigma^2/(nItems-1) + std_s^2) + var(temp,1)*(nItems-1)*lambda;
        end
        obs_response = sum(x.*exp(-term_x/2));
    elseif strcmp(pars.rule,'SumX123')
        term = zeros(size(x)); % compute weight
        idx_temp = 1:nItems;
        for jj = 1:nItems
            temp1 = x(idx_temp==jj,:);
            temp2 = x(idx_temp~=jj,:);
            term(jj,:) = temp1.^2/(sigma^2 + std_s^2) + mean(temp2).^2/(sigma^2/(nItems-1) + std_s^2) + var(temp2,1)*(nItems-1)*lambda;
        end
        obs_response = sum(x.*exp(-term/2));
    end
    
    if strcmp(pars.model_type,'opt')
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