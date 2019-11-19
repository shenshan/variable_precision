%{
# compute performance of each model for each trial
-> varprecision.FitPredictionBpsBestAvg
-----
performance  : longblob       # performance for each trial, with the same length as the stimuli
%}

classdef PerformanceModel < dj.Computed
	
    properties
        popRel = varprecision.FitPredictionBpsBest & varprecision.Performance
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            
            prediction = fetch1(varprecision.FitPredictionBpsBestAvg & key, 'prediction');
			
            [performance_data, response] = fetch1(varprecision.Performance & key, 'performance','response');
            
            prediction(response<1) = 1 - prediction(response<1);
            
            prediction(performance_data==0) = 1 - prediction(performance_data==0);
            
            key.performance = prediction;
            
            self.insert(key)
		end
	end

end