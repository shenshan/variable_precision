%{
varprecision.BmcGroupGV (computed) # bayesian group
-> varprecision.Experiment
-----
alpha: blob # vector 1xnModels, alpha-1 indicates the expressed number of subjects that follows the Kth model.
exp_r: blob # vector 1xnModels, expected probability of a certain model given the grouped subject data, sum up to 1
xp:    blob # vector 1xnModels, exceedance probability, probability of a model is more frequent than all other models, sum up to 1
pxp:   blob # vector 1xnModels, protected exceedance probability, exceedance probability with consideration of the existence of the bestmodel, bor
bor:   float # Bayes Omnibus Risk (probability that model frequencies are equal)
g:     longblob # nSubjects x nModels, matrix of individual posterior probabilities
fpp_g: float # factor posterior of guessing
fpp_v: float # factor posterior of variable precision
%}

classdef BmcGroupGV < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Experiment & 'exp_id<12'
    end
    
	methods(Access=protected)

		function makeTuples(self, key)
           
            subjs = fetch(varprecision.Subject & 'subj_type="real"');
            records = fetch(varprecision.Recording & key & subjs);
            factor_code = {'Base','V','G','GV'};

            lmeMat = zeros(length(records),length(factor_code));

            for ii = 1:length(factor_code);
                model = fetch(varprecision.Model & records & ['factor_code="' factor_code{ii} '"'] & 'model_type="opt"');
                lmeMat(:,ii) = fetchn(varprecision.FitParsEviBpsBestAvg & model,'aic');
            end

            [key.alpha,key.exp_r,key.xp,key.pxp,key.bor,key.g] = spm_BMS_fast(-lmeMat,[],0,0,1,[]);
            
            key.fpp_g = sum(key.exp_r(3:4));
            key.fpp_v = sum(key.exp_r([2,4]));

			self.insert(key)
		end
	end

end