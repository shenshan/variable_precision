%{
varprecision.PredictionSubTableIdx (computed) # create index of prediction subtables for real data of Exp6-11
-> varprecision.ParameterSet
lambda_idx :   smallint       # index of lambda, from 1 to length(lambda)  
-----
lambda_value : double  # certain lambda of the corresponding index
%}

classdef PredictionSubTableIdx < dj.Relvar & dj.AutoPopulate
	
    properties 
        popRel = varprecision.ParameterSet & 'exp_id>5'
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            
            lambdas = fetch1(varprecision.ParameterSet & key, 'lambda');
            
            for ii = 1:length(lambdas)
                tuple = key;
                tuple.lambda_idx = ii;
                tuple.lambda_value = lambdas(ii);
                self.insert(tuple);
            end
			
		end
	end

end