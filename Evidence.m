%{
varprecision.Evidence (computed) # compute evidence for each model
-> varprecision.LogLikelihoodMatAll
-----
lml    : double     # log marginal likelihood
bic    : double     # estimated lambda, it would be a vector for multiple set sizes
aic    : double     # estimated theta, null if does not exist
aicc   : double     # esimated guess, null if does not exist
llmax  : int        # index of estimated p_right

%}

classdef Evidence < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.LogLikelihoodMatAll
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
		
            LLMat = fetch1(varprecision.LogLikelihoodMatAll & key, 'll_mat');
            npars = fetch1(varprecision.Model & key, 'npars');
            setsizes = fetch1(varprecision.Experiment & key, 'setsize');
            nTrials = fetch1(varprecision.Data & key, 'ntrials');
                      
            if length(setsizes)==1
               llmax = max(LLMat(:));
               ll = LLMat - llmax;
               lml = llmax + log(sum(exp(ll(:)))) -log(numel(ll));
               bic = -llmax + 0.5*npars*log(nTrials);
               aic = -llmax + npars;
               aicc = aic + npars*(npars+1)/(nTrials-npars-1);
               
            else
                % need to implement non-parametric 
            end
            
            key.llmax = llmax;
            key.lml = lml;
            key.bic = bic;
            key.aic = aic;
            key.aicc = aicc;
			self.insert(key)
		end
	end

end