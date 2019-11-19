%{
varprecision.TradeOffMarginals (computed) # compute marginal likelihood of parameters for trade off analysis
-> varprecision.TradeOffTest
margin_dim      : tinyint                # dimension of the parameters
---
ll_sum                      : longblob                      # log marginals sum
ll_max                      : longblob                      # log marginals max
%}

classdef TradeOffMarginals < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.TradeOffTest & varprecision.TradeOffTestLikelihoodPars
    end
	methods(Access=protected)

		function makeTuples(self, key)
            
            nsteps = fetch1(varprecision.TradeOffTest & key, 'nsteps');
            
            ll_all = fetchn(varprecision.TradeOffTestLikelihoodPars & key, 'll');
            ll_all = -ll_all;
            pars_idx_vec = fetchn(varprecision.TradeOffTestPars & key, 'pars_idx_vec');
            pars_idx_vec = varprecision.utils.decell(pars_idx_vec);
            
            for ii = 1:length(nsteps)
                if nsteps(ii) == 1
                    continue
                end
                pars_idx_vec_rel = pars_idx_vec(ii,:);
                key.margin_dim = ii;
                ll_sum = zeros(1,nsteps(ii));
                ll_max = zeros(1,nsteps(ii));
                for jj = 1:nsteps(ii)
                    llMat = ll_all(pars_idx_vec_rel==jj);
                    ll_sum(jj) = log(sum(exp(llMat(:) - max(llMat(:))))) + max(llMat(:)) - numel(llMat);
                    ll_max(jj) = max(llMat(:));
                end
                
                key.ll_sum = ll_sum;
                key.ll_max = ll_max;
                self.insert(key);
      
            end
			
		end
	end

end
