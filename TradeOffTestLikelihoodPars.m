%{
varprecision.TradeOffTestLikelihoodPars (computed) # compute log likelihood of a certain combination of parameters
-> varprecision.TradeOffTestPars
---
ll                          : double                        # log likelihood table for this combination of paramters
%}

classdef TradeOffTestLikelihoodPars < dj.Relvar & dj.AutoPopulate
	properties
        popRel = varprecision.TradeOffTestPars
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
			pars_vec = fetch1(varprecision.TradeOffTestPars & key,'test_pars');
            params = [0.5,pars_vec];
            
            tuple.exp_id = key.exp_id;
            tuple.test_id = key.test_id;
            tuple.model_name = key.test_model;
            tuple.trial_num_sim = fetch1(varprecision.TradeOffTest & key, 'ntrials');
            tuple.trade_off = 1;
            
            key.ll = varprecision.decisionrule_bps.loglikelihood(params,tuple);
			self.insert(key)
		end
	end

end
