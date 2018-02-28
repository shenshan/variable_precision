%{
varprecision.EviRules (computed) # compute LFLR for all rules
->varprecision.Rule
->varprecision.Data
-----
# add additional attributes
%}

classdef EviRules < dj.Relvar & dj.AutoPopulate
	methods

		function makeTuples(self, key)
		%!!! compute missing fields for key here
			%self.insert(key)
		end
	end

end