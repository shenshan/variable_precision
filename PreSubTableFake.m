%{
varprecision.PreSubTableFake (computed) # compute precomputed subtables for fake data test, exp 6-11
->varprecision.PredictionSubTableIdx
->varprecision.JbarKappaMap
-----
pretable_sub_dir     : blob  # directory to save the precomputed sub table
%}

classdef PreSubTableFake < dj.Relvar
	
    methods      
		function makeTuples(self, key)

			self.insert(key)
		end
	end

end