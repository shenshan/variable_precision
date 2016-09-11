%{
varprecision.FitPredictionBPS (computed) # my newest table
# add primary key here
-----
# add additional attributes
%}

classdef FitPredictionBPS < dj.Relvar
	methods

		function makeTuples(self, key)
		%!!! compute missing fields for key here
			self.insert(key)
		end
	end

end