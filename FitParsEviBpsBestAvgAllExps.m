%{
varprecision.FitParsEviBpsBestAvgAllExps (computed) # Evidence of different models of all experiments
->varprecision.ModelGeneral
-----
llmax                       : double                        # overall maximum likelihood of all experiments
bic                         : double                        # overall bayesian information criterion of all experiments
aic                         : double                        # overall alkeik information criterion of all experiments
aicc                        : double                        # overall aicc of all experiments
%}

classdef FitParsEviBpsBestAvgAllExps < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.ModelGeneral
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            
            [llmaxMat, bicMat, aicMat, aiccMat] = fetchn(varprecision.FitParsEviBpsBestAvg & ['model_name="' key.model_name '"'],'llmax','bic','aic','aicc');
            key.llmax = sum(llmaxMat);
            key.bic = sum(bicMat);
            key.aic = sum(aicMat);
            key.aicc = sum(aiccMat);
            
			self.insert(key)
		end
	end

end