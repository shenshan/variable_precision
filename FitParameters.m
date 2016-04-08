%{
varprecision.FitParameters (computed) # extract the parameters that gives the highest likelihood
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

%}

classdef FitParameters < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.LogLikelihoodMatAll
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
		
            LLMat = fetch1(varprecision.LogLikelihoodMatAll & key, 'll_mat');
            pars = fetch(varprecision.ParameterSet & key,'*');
            setsizes = fetch1(varprecision.Experiment & key, 'setsize');
            
            [~,idx] = max(LLMat(:));
                       
            if length(setsizes)==1
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
            else
                % need to implement non-parametric estimation of fit
                % parameters
            end
            
            
			self.insert(key)
		end
	end

end