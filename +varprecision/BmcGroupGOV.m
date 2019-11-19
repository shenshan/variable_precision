%{
varprecision.BmcGroupGOV (computed) # BMC group analysis, for models containing G, O, V
-> varprecision.Experiment
-----
alpha: blob # vector 1xnModels, alpha-1 indicates the expressed number of subjects that follows the Kth model.
exp_r: blob # vector 1xnModels, expected probability of a certain model given the grouped subject data, sum up to 1
xp:    blob # vector 1xnModels, exceedance probability, probability of a model is more frequent than all other models, sum up to 1
pxp:   blob # vector 1xnModels, protected exceedance probability, exceedance probability with consideration of the existence of the bestmodel, bor
bor:   float # Bayes Omnibus Risk (probability that model frequencies are equal)
g:     longblob # nSubjects x nModels, matrix of individual posterior probabilities
alpha_ov: blob # vector 1xnModels, only consider models with OV, or without OV.
exp_r_ov: blob # vector 1xnModels, expected probability of a certain model given the grouped subject data, sum up to 1
xp_ov:    blob # vector 1xnModels, exceedance probability, probability of a model is more frequent than all other models, sum up to 1
pxp_ov:   blob # vector 1xnModels, protected exceedance probability, exceedance probability with consideration of the existence of the bestmodel, bor
bor_ov:   float # Bayes Omnibus Risk (probability that model frequencies are equal)
g_ov:     longblob # nSubjects x nModels, matrix of individual posterior probabilities
fpp_g: float # factor posterior of guessing
fpp_o: float # factor posterior of orientation dependent variability
fpp_v: float # factor posterior of variable precision
fpp_ov: float # factor posterior of variable precision
%}

classdef BmcGroupGOV < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Experiment & 'exp_id<12'
    end
    
	methods(Access=protected)

		function makeTuples(self, key)
           
            subjs = fetch(varprecision.Subject & 'subj_type="real"');
            records = fetch(varprecision.Recording & key & subjs);
            factor_code = {'Base','V','G','GV','O','GO','OV','GOV'};

            lmeMat = zeros(length(records),length(factor_code));

            for ii = 1:length(factor_code);
                model = fetch(varprecision.Model & records & ['factor_code="' factor_code{ii} '"'] & 'model_type="opt"');
                lmeMat(:,ii) = fetchn(varprecision.FitParsEviBpsBestAvg & model,'aic');
            end

            [key.alpha,key.exp_r,key.xp,key.pxp,key.bor,key.g] = spm_BMS_fast(-lmeMat,[],0,0,1,[]);
            
            factor_code_OV = {'Base','G','OV','GOV'};
            lmeMat_OV = zeros(length(records),length(factor_code_OV));

            for ii = 1:length(factor_code_OV);
                model = fetch(varprecision.Model & records & ['factor_code="' factor_code_OV{ii} '"'] & 'model_type="opt"');
                lmeMat_OV(:,ii) = fetchn(varprecision.FitParsEviBpsBestAvg & model,'aic');
            end

            [key.alpha_ov,key.exp_r_ov,key.xp_ov,key.pxp_ov,key.bor_ov,key.g_ov] = spm_BMS_fast(-lmeMat_OV,[],0,0,1,[]);
            
            key.fpp_g = sum(key.exp_r([3,4,6,8]));
            key.fpp_o = sum(key.exp_r([5,6,7,8]));
            key.fpp_v = sum(key.exp_r(2:2:8));
            
            key.fpp_ov = sum(key.exp_r_ov(3:4));

			self.insert(key)
		end
	end

end