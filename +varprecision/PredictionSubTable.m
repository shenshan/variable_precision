%{
varprecision.PredictionSubTable (computed) # compute prediction sub table for experiments 6-11
->varprecision.PredictionSubTableIdx
->varprecision.Data
->varprecision.JbarKappaMap
-----
prediction_mat_sub :  longblob   # length of each dimension is the length of the parameters, the values in the row other than lambda_idx are zeros.

%}

classdef PredictionSubTable < dj.Relvar

    methods

		function makeTuples(self, key)
            self.insert(key)
        end
    end
end
