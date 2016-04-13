%{
varprecision.LogLikelihoodMatAll (computed) # table that stores the log likeihood matrix, that is, for individual parameter combination, log joint probability
# of reports on all trials, for all experiments
->varprecision.PrecomputedTable
->varprecision.DataStats
-----
ll_mat_path     : longblob     # log likelihood matrix for all combination of parameters, length of each dimention is the length of the parameters

%}

classdef LogLikelihoodMatAll < dj.Relvar
	methods

		function makeTuples(self, key)
		
			self.insert(key)
		end
	end

end