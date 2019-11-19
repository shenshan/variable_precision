%{
varprecision.TradeOffTestPars (computed) # parameters
-> varprecision.TradeOffTestSet
pars_idx        : smallint               # parameter idx
---
pars_idx_vec                : blob                          # parameter idx as a vector
test_pars                   : blob                          # vector of test parameters
%}

classdef TradeOffTestPars < dj.Relvar
	
    methods

		function makeTuples(self, key) 
			self.insert(key)
		end
	end

end
