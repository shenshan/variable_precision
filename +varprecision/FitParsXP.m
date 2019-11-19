%{
varprecision.FitParsXP (computed) # This is a sub register table to save fit paramters of XP models 
-> varprecision.FitParsEviBps
-----
beta_hat : double    # best fitting beta. alpha*(1+beta*cos(2*x))
%}

classdef FitParsXP < dj.Relvar
	methods

		function makeTuples(self, key, beta_hat)
            key.beta_hat = beta_hat;
			self.insert(key)
		end
	end

end