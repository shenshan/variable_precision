%{
varprecision.EviFactorGOV (computed) # compute factorized evidences, difference in evidence between model with a factor versus not
-> varprecision.Data
-----
ori_aic    : double    # aic evidence for ori dependent variance
ori_bic    : double    # bic evidence for ori dependent variance
ori_aicc   : double    # aicc evidence for ori dependent variance
ori_llmax  : double    # llmax evidence for ori dependent variance
var_aic    : double    # aic evidence for ori independent variance
var_bic    : double    # bic evidence for ori independent variance
var_aicc   : double    # aicc evidence for ori independent variance
var_llmax  : double    # llmax evidence for ori independent variance
guess_aic  : double    # aic evidence for guessing
guess_bic  : double    # bic evidence for guessing
guess_aicc : double    # aicc evidence for guessing
guess_llmax: double    # llmax evidence for guessing
total_var_aic   : double  # aic evidence for total variance
total_var_bic   : double  # bic evidence for total variance
total_var_aicc  : double  # aicc evidence for total variance
total_var_llmax : double  # llmax evidence for total variance
g_lfpr_aic    : float   # guessing evidence ratio computed with AIC
g_lfpr_bic    : float   # guessing evidence ratio computed with BIC
g_lfpr_aicc    : float   # guessing evidence ratio computed with AICc
g_lfpr_llmax    : float   # guessing evidence ratio computed with llmax
o_lfpr_aic    : float   # Oblique evidence ratio computed with AIC
o_lfpr_bic    : float   # Oblique evidence ratio computed with BIC
o_lfpr_aicc    : float   # Oblique evidence ratio computed with AICc
o_lfpr_llmax    : float   # Oblique evidence ratio computed with llmax
v_lfpr_aic    : float   # VP evidence ratio computed with AIC
v_lfpr_bic    : float   # VP evidence ratio computed with BIC
v_lfpr_aicc    : float   # VP evidence ratio computed with AICc
v_lfpr_llmax    : float   # VP evidence ratio computed with llmax
ov_lfpr_aic    : float   # OV evidence ratio computed with AIC
ov_lfpr_bic    : float   # OV evidence ratio computed with BIC
ov_lfpr_aicc    : float   # OV evidence ratio computed with AICc
ov_lfpr_llmax    : float   # OV evidence ratio computed with llmax
%}

classdef EviFactorGOV < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Data & 'exp_id<12'
    end
	
    methods(Access=protected)
        
		function makeTuples(self, key)
            [ori_aicMat, ori_bicMat, ori_aiccMat, ori_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("OP","OPG","OPVP","OPVPG")','aic','bic','aicc','llmax');
            [non_ori_aicMat, non_ori_bicMat, non_ori_aiccMat, non_ori_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("CP","CPG","VP","VPG")','aic','bic','aicc','llmax');
            [var_aicMat, var_bicMat, var_aiccMat, var_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("VP","VPG","OPVP","OPVPG")','aic','bic','aicc','llmax');
            [non_var_aicMat, non_var_bicMat, non_var_aiccMat, non_var_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("CP","CPG","OP","OPG")','aic','bic','aicc','llmax');
            [guess_aicMat, guess_bicMat, guess_aiccMat, guess_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("CPG","VPG","OPG","OPVPG")','aic','bic','aicc','llmax');
            [non_guess_aicMat, non_guess_bicMat, non_guess_aiccMat, non_guess_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("CP","VP","OP","OPVP")','aic','bic','aicc','llmax');
            [total_var_aicMat, total_var_bicMat, total_var_aiccMat, total_var_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("OPVP","OPVPG")','aic','bic','aicc','llmax');
            [non_total_var_aicMat, non_total_var_bicMat, non_total_var_aiccMat, non_total_var_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("CP","CPG")','aic','bic','aicc','llmax');
            
            
            % aic 
            min_val = min(min(ori_aicMat),min(non_ori_aicMat));
            res_ori_aicMat = ori_aicMat - min_val;
            res_non_ori_aicMat = non_ori_aicMat - min_val;
            
            res_var_aicMat = var_aicMat - min_val;
            res_non_var_aicMat = non_var_aicMat - min_val;
            
            res_guess_aicMat = guess_aicMat - min_val;
            res_non_guess_aicMat = non_guess_aicMat - min_val;
            
            res_total_var_aicMat = total_var_aicMat - min_val;
            res_non_total_var_aicMat = non_total_var_aicMat - min_val;
            
            ori_aic_ratio = mean(exp(-res_ori_aicMat))/(mean(exp(-res_non_ori_aicMat)));
            key.ori_aic = ori_aic_ratio/(ori_aic_ratio+1);
            
            var_aic_ratio = mean(exp(-res_var_aicMat))/(mean(exp(-res_non_var_aicMat)));
            key.var_aic = var_aic_ratio/(var_aic_ratio+1);
            
            guess_aic_ratio = mean(exp(-res_guess_aicMat))/(mean(exp(-res_non_guess_aicMat)));
            key.guess_aic = guess_aic_ratio/(guess_aic_ratio+1);
            
            total_var_aic_ratio = mean(exp(-res_total_var_aicMat))/(mean(exp(-res_non_total_var_aicMat)));
            key.total_var_aic = total_var_aic_ratio/(total_var_aic_ratio+1);
            
            
            % bic
            min_val = min(min(ori_bicMat),min(non_ori_bicMat));
            res_ori_bicMat = ori_bicMat - min_val;
            res_non_ori_bicMat = non_ori_bicMat - min_val;
            
            res_var_bicMat = var_bicMat - min_val;
            res_non_var_bicMat = non_var_bicMat - min_val;
            
            res_guess_bicMat = guess_bicMat - min_val;
            res_non_guess_bicMat = non_guess_bicMat - min_val;
            
            res_total_var_bicMat = total_var_bicMat - min_val;
            res_non_total_var_bicMat = non_total_var_bicMat - min_val;
            
            ori_bic_ratio = mean(exp(-res_ori_bicMat))/(mean(exp(-res_non_ori_bicMat)));
            key.ori_bic = ori_bic_ratio/(ori_bic_ratio+1);
            
            var_bic_ratio = mean(exp(-res_var_bicMat))/(mean(exp(-res_non_var_bicMat)));
            key.var_bic = var_bic_ratio/(var_bic_ratio+1);
            
            guess_bic_ratio = mean(exp(-res_guess_bicMat))/(mean(exp(-res_non_guess_bicMat)));
            key.guess_bic = guess_bic_ratio/(guess_bic_ratio+1);
            
            total_var_bic_ratio = mean(exp(-res_total_var_bicMat))/(mean(exp(-res_non_total_var_bicMat)));
            key.total_var_bic = total_var_bic_ratio/(total_var_bic_ratio+1);
            
            % aicc
            min_val = min(min(ori_aiccMat),min(non_ori_aiccMat));
            res_ori_aiccMat = ori_aiccMat - min_val;
            res_non_ori_aiccMat = non_ori_aiccMat - min_val;
            
            res_var_aiccMat = var_aiccMat - min_val;
            res_non_var_aiccMat = non_var_aiccMat - min_val;
            
            res_guess_aiccMat = guess_aiccMat - min_val;
            res_non_guess_aiccMat = non_guess_aiccMat - min_val;
            
            res_total_var_aiccMat = total_var_aiccMat - min_val;
            res_non_total_var_aiccMat = non_total_var_aiccMat - min_val;
            
            ori_aicc_ratio = mean(exp(-res_ori_aiccMat))/(mean(exp(-res_non_ori_aiccMat)));
            key.ori_aicc = ori_aicc_ratio/(ori_aicc_ratio+1);
            
            var_aicc_ratio = mean(exp(-res_var_aiccMat))/(mean(exp(-res_non_var_aiccMat)));
            key.var_aicc = var_aicc_ratio/(var_aicc_ratio+1);
            
            guess_aicc_ratio = mean(exp(-res_guess_aiccMat))/(mean(exp(-res_non_guess_aiccMat)));
            key.guess_aicc = guess_aicc_ratio/(guess_aicc_ratio+1);
           
            total_var_aicc_ratio = mean(exp(-res_total_var_aiccMat))/(mean(exp(-res_non_total_var_aiccMat)));
            key.total_var_aicc = total_var_aicc_ratio/(total_var_aicc_ratio+1);
            
            % llmax
            max_val = max(max(ori_llmaxMat),max(non_ori_llmaxMat));
            res_ori_llmaxMat = ori_llmaxMat - max_val;
            res_non_ori_llmaxMat = non_ori_llmaxMat - max_val;
            
            res_var_llmaxMat = var_llmaxMat - max_val;
            res_non_var_llmaxMat = non_var_llmaxMat - max_val;
            
            res_guess_llmaxMat = guess_llmaxMat - max_val;
            res_non_guess_llmaxMat = non_guess_llmaxMat - max_val;
            
            res_total_var_llmaxMat = total_var_llmaxMat - max_val;
            res_non_total_var_llmaxMat = non_total_var_llmaxMat - max_val;
            
            ori_llmax_ratio = mean(exp(res_ori_llmaxMat))/(mean(exp(res_non_ori_llmaxMat)));
            key.ori_llmax = ori_llmax_ratio/(ori_llmax_ratio+1);
            
            var_llmax_ratio = mean(exp(res_var_llmaxMat))/(mean(exp(res_non_var_llmaxMat)));
            key.var_llmax = var_llmax_ratio/(var_llmax_ratio+1);
            
            guess_llmax_ratio = mean(exp(res_guess_llmaxMat))/(mean(exp(res_non_guess_llmaxMat)));
            key.guess_llmax = guess_llmax_ratio/(guess_llmax_ratio+1);
            
            total_var_llmax_ratio = mean(exp(res_total_var_llmaxMat))/(mean(exp(res_non_total_var_llmaxMat)));
            key.total_var_llmax = total_var_llmax_ratio/(total_var_llmax_ratio+1);
            
            key.g_lfpr_aic = log(guess_aic_ratio);
            key.g_lfpr_bic = log(guess_bic_ratio);
            key.g_lfpr_aicc = log(guess_aicc_ratio);
            key.g_lfpr_llmax = log(guess_llmax_ratio);
            key.o_lfpr_aic = log(ori_aic_ratio);
            key.o_lfpr_bic = log(ori_bic_ratio);
            key.o_lfpr_aicc = log(ori_aicc_ratio);
            key.o_lfpr_llmax = log(ori_llmax_ratio);
            key.v_lfpr_aic = log(var_aic_ratio);
            key.v_lfpr_bic = log(var_bic_ratio);
            key.v_lfpr_aicc = log(var_aicc_ratio);
            key.v_lfpr_llmax = log(var_llmax_ratio);
            key.ov_lfpr_aic = log(total_var_aic_ratio);
            key.ov_lfpr_bic = log(total_var_bic_ratio);
            key.ov_lfpr_aicc = log(total_var_aicc_ratio);
            key.ov_lfpr_llmax = log(total_var_llmax_ratio);
            
            self.insert(key)
		end
	end

end