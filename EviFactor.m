%{
varprecision.EviFactor (computed) # compute factorized evidences, difference in evidence between model with a factor versus not
-> varprecision.Data
-----
ori_aic    : double    # mean aic evidence for ori dependent variance models
ori_bic    : double    # mean bic evidence for ori dependent variance models
ori_aicc   : double    # mean aicc evidence for ori dependent variance models
ori_llmax  : double    # mean llmax evidence for ori dependent variance models
var_aic    : double    # mean aic evidence for ori independent variance models
var_bic    : double    # mean bic evidence for ori independent variance models
var_aicc   : double    # mean aicc evidence for ori independent variance models
var_llmax  : double    # mean llmax evidence for ori independent variance models
guess_aic  : double    # mean aic evidence for guessing models
guess_bic  : double    # mean bic evidence for guessing models
guess_aicc : double    # mean aicc evidence for guessing models
guess_llmax: double    # mean llmax evidence for guessing models
%}

classdef EviFactor < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Data
    end
	
    methods(Access=protected)
        
		function makeTuples(self, key)
            [ori_aicMat, ori_bicMat, ori_aiccMat, ori_llmaxMat] = fetchn(varprecision.FitParsEviBpsBest & key & 'model_name in ("OP","OPG","OPVP","OPVPG")','aic','bic','aicc','llmax');
            [non_ori_aicMat, non_ori_bicMat, non_ori_aiccMat, non_ori_llmaxMat] = fetchn(varprecision.FitParsEviBpsBest & key & 'model_name in ("CP","CPG","VP","VPG")','aic','bic','aicc','llmax');
            [var_aicMat, var_bicMat, var_aiccMat, var_llmaxMat] = fetchn(varprecision.FitParsEviBpsBest & key & 'model_name in ("VP","VPG","OPVP","OPVPG")','aic','bic','aicc','llmax');
            [non_var_aicMat, non_var_bicMat, non_var_aiccMat, non_var_llmaxMat] = fetchn(varprecision.FitParsEviBpsBest & key & 'model_name in ("CP","CPG","OP","OPG")','aic','bic','aicc','llmax');
            [guess_aicMat, guess_bicMat, guess_aiccMat, guess_llmaxMat] = fetchn(varprecision.FitParsEviBpsBest & key & 'model_name in ("CPG","VPG","OPG","OPVPG")','aic','bic','aicc','llmax');
            [non_guess_aicMat, non_guess_bicMat, non_guess_aiccMat, non_guess_llmaxMat] = fetchn(varprecision.FitParsEviBpsBest & key & 'model_name in ("CP","VP","OP","OPVP")','aic','bic','aicc','llmax');
            
            
            min_val = min(min(ori_aicMat),min(non_ori_aicMat));
            res_ori_aicMat = ori_aicMat - min_val;
            res_non_ori_aicMat = non_ori_aicMat - min_val;
            
            res_var_aicMat = var_aicMat - min_val;
            res_non_var_aicMat = non_var_aicMat - min_val;
            
            res_guess_aicMat = guess_aicMat - min_val;
            res_non_guess_aicMat = non_guess_aicMat - min_val;
            
            key.ori_aic = log(mean(exp(-res_ori_aicMat))) - log(mean(exp(-res_non_ori_aicMat)));
            key.ori_bic = mean(ori_bicMat) - mean(non_ori_bicMat);
            key.ori_aicc = mean(ori_aiccMat) - mean(non_ori_aiccMat);
            key.ori_llmax = mean(ori_llmaxMat) - mean(non_ori_llmaxMat);
            key.var_aic = log(mean(exp(-res_var_aicMat))) - log(mean(exp(-res_non_var_aicMat)));
            key.var_bic = mean(var_bicMat) - mean(non_var_bicMat);
            key.var_aicc = mean(var_aiccMat) - mean(non_var_aiccMat);
            key.var_llmax = mean(var_llmaxMat) - mean(non_var_llmaxMat);
            key.guess_aic = log(mean(exp(-res_guess_aicMat))) - log(mean(exp(-res_non_guess_aicMat)));
            key.guess_bic = mean(guess_bicMat) - mean(non_guess_bicMat);
            key.guess_aicc = mean(guess_aiccMat) - mean(non_guess_aiccMat);
            key.guess_llmax = mean(guess_llmaxMat) - mean(non_guess_llmaxMat);
            
            self.insert(key)
		end
	end

end