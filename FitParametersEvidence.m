%{
varprecision.FitParametersEvidence(computed) # extract the parameters that gives the highest likelihood, and compute evidences of all kinds
-> varprecision.LogLikelihoodMatAll
-----
p_right_hat    : double     # estimated p_right
lambda_hat     : blob       # estimated lambda, it would be a vector for multiple set sizes
theta_hat=null : double     # estimated theta, null if does not exist
guess_hat=null : double     # esimated guess, null if does not exist
p_right_idx    : int        # index of estimated p_right
lambda_idx     : blob       # index of estimated lambda, vector for multiple set sizes
theta_idx=0    : int        # index of estimated theta
guess_idx=0    : int        # index of estimated guess
lml    : double     # log marginal likelihood
bic    : double     # estimated lambda, it would be a vector for multiple set sizes
aic    : double     # estimated theta, null if does not exist
aicc   : double     # esimated guess, null if does not exist
llmax  : int        # index of estimated p_right
%}

classdef FitParametersEvidence < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.LogLikelihoodMatAll
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
		
            ll_mat_path = fetch1(varprecision.LogLikelihoodMatAll & key, 'll_mat_path');
            load(ll_mat_path,'ll_mat');
            LLMat = ll_mat;
            pars = fetch(varprecision.ParameterSet & key,'*');
            setsizes = fetch1(varprecision.Experiment & key, 'setsize');
            nTrials = fetch1(varprecision.Data & key, 'ntrials');
            npars = fetch1(varprecision.Model & key, 'npars');
            
                                  
            if length(setsizes)==1
                [~,idx] = max(LLMat(:));
                switch pars.model_name
                    case 'CP'
                        [key.p_right_idx,key.lambda_idx] = ind2sub(size(LLMat),idx);
                        key.p_right_hat  = pars.p_right(key.p_right_idx);
                        key.lambda_hat = pars.lambda(key.lambda_idx);
                    case 'CPG'
                        [key.p_right_idx,key.lambda_idx,key.guess_idx] = ind2sub(size(LLMat),idx);
                        key.p_right_hat  = pars.p_right(key.p_right_idx);
                        key.lambda_hat = pars.lambda(key.lambda_idx);
                        key.guess_hat = pars.guess(key.guess_idx);
                    case 'VP'
                        [key.p_right_idx,key.lambda_idx,key.theta_idx] = ind2sub(size(LLMat),idx);
                        key.p_right_hat  = pars.p_right(key.p_right_idx);
                        key.lambda_hat = pars.lambda(key.lambda_idx);
                        key.theta_hat = pars.theta(key.theta_idx);
                    case 'VPG'
                        [key.p_right_idx,key.lambda_idx,key.theta_idx,key.guess_idx] = ind2sub(size(LLMat),idx);
                        key.p_right_hat  = pars.p_right(key.p_right_idx);
                        key.lambda_hat = pars.lambda(key.lambda_idx);
                        key.theta_hat = pars.theta(key.theta_idx);
                        key.guess_hat = pars.guess(key.guess_idx);
                end
                % compute evidence
                llmax = max(LLMat(:));
                ll = LLMat - llmax;
                lml = llmax + log(sum(exp(ll(:)))) -log(numel(ll));
           
            else
                %% non-parametric fitting for experiments with multiple set sizes
                key.lambda_hat = zeros(1,length(setsizes));
                switch pars.model_name
                    case 'CP'
                        % matrix to save the index of lambda that gives the maximum likelihood given a combination of p_right, theta and guess
                        idxMat = zeros(length(setsizes),length(pars.p_right));
                        % matrix to save the maximum value of likelihood for each combination of p_right, theta and guess
                        maxMat = zeros(size(idxMat));
                        
                        % find the maximum likelihood and the corresponding index of lambda given a combination of the rest of the parameters
                        for ii = 1:length(setsizes)
                            for jj = 1:length(pars.p_right)
                                tempMat = squeeze(LLMat(ii,jj,:));
                                [maxMat(ii,jj),idxMat(ii,jj)] = max(tempMat(:));
                            end
                        end
                        % sum over the set sizes for the maxMat
                        sum_max = squeeze(sum(maxMat));
                        
                        % get the best parameters p_right,theta and guess
                         [llmax, key.p_right_idx] = max(sum_max);
                         key.p_right_hat = pars.p_right(key.p_right_idx);
                        
                        % find the best lambda for each set sizes
                        for ii = 1:length(setsizes)
                            key.lambda_idx(ii) = idxMat(ii,key.p_right_idx);
                        end
                        
                        
                    case 'CPG'
                        
                        idxMat = zeros(length(setsizes),length(pars.p_right),length(pars.guess));
                        maxMat = zeros(size(idxMat));
                        
                        for ii = 1:length(setsizes)
                            for jj = 1:length(pars.p_right)
                                for kk = 1:length(pars.guess)
                                    tempMat = squeeze(LLMat(ii,jj,:,kk));
                                    [maxMat(ii,jj,kk),idxMat(ii,jj,kk)] = max(tempMat(:));
                                end
                            end
                        end
                        
                        sum_max = squeeze(sum(maxMat));
                        
                        [llmax, idx] = max(sum_max(:));
                        [key.p_right_idx,key.guess_idx] = ind2sub(size(sum_max),idx);
                        key.p_right_hat = pars.p_right(key.p_right_idx);
                        key.guess_hat = pars.guess(key.guess_idx);
                        
                        for ii = 1:length(setsizes)
                            key.lambda_idx(ii) = idxMat(ii,key.p_right_idx,key.guess_idx);
                        end
                        
                    case 'VP'
                        
                        idxMat = zeros(length(setsizes),length(pars.p_right),length(pars.theta));
                        maxMat = zeros(size(idxMat));
                        
                        for ii = 1:length(setsizes)
                            for jj = 1:length(pars.p_right)
                                for kk = 1:length(pars.theta)
                                    tempMat = squeeze(LLMat(ii,jj,:,kk));
                                    [maxMat(ii,jj,kk),idxMat(ii,jj,kk)] = max(tempMat(:));
                                end
                            end
                        end
                        
                        sum_max = squeeze(sum(maxMat));
                        
                        [llmax, idx] = max(sum_max(:));
                        [key.p_right_idx,key.theta_idx] = ind2sub(size(sum_max),idx);
                        key.p_right_hat = pars.p_right(key.p_right_idx);
                        key.theta_hat = pars.theta(key.theta_idx);
                        
                        for ii = 1:length(setsizes)
                            key.lambda_idx(ii) = idxMat(ii,key.p_right_idx,key.theta_idx);
                        end
                        
                    case 'VPG'
                        idxMat = zeros(length(setsizes),length(pars.p_right),length(pars.theta),length(pars.guess));
                        maxMat = zeros(size(idxMat));
                        
                        for ii = 1:length(setsizes)
                            for jj = 1:length(pars.p_right)
                                for kk = 1:length(pars.theta)
                                    for ij = 1:length(pars.guess)
                                        tempMat = squeeze(LLMat(ii,jj,:,kk,ij));
                                        [maxMat(ii,jj,kk,ij),idxMat(ii,jj,kk,ij)] = max(tempMat(:));
                                    end
                                end
                            end
                        end
                        
                        sum_max = squeeze(sum(maxMat));
                        [llmax, idx] = max(sum_max(:));
                        [key.p_right_idx,key.theta_idx,key.guess_idx] = ind2sub(size(sum_max),idx);
                        key.p_right_hat = pars.p_right(key.p_right_idx);
                        key.theta_hat = pars.theta(key.theta_idx);
                        key.guess_hat = pars.guess(key.guess_idx);
                        
                        for ii = 1:length(setsizes)
                            key.lambda_idx(ii) = idxMat(ii,key.p_right_idx,key.theta_idx,key.guess_idx);
                        end
                       
                end
                key.lambda_hat = pars.lambda(key.lambda_idx);
                
                %% compute lml
    
                % exponential the matrix, substact something first
                LL_max = max(LLMat(:));               
                LL = LLMat - LL_max;
                exp_LL  = exp(LL);
                % sum over lambda and take the log of the matrix
                LL_sum_lambda = log(squeeze(sum(exp_LL, 3))) + LL_max;
                % sum over set sizes
                LL_sum_ss  = squeeze(sum(LL_sum_lambda , 1)); 
                % substract again
                max_num  = max(LL_sum_ss(:));
                LL_sum_ss  = LL_sum_ss  - max_num;
                % exponential the matrix, sum over the rest of the dimensions and take the log again
                nSets = length(setsizes);
                lml  = max_num  + log(sum(exp(LL_sum_ss(:)))) - log(numel(LL)) - (nSets-1)*log(length(pars.lambda));

            end
            
            key.bic = -llmax + 0.5*npars*log(nTrials);
            key.aic = -llmax + npars;
            key.aicc = key.aic + npars*(npars+1)/(nTrials-npars-1);
            
            key.llmax = llmax;
            key.lml = lml;

			self.insert(key)
		end
	end

end