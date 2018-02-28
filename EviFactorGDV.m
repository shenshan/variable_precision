%{
varprecision.EviFactorGDV (computed) # compute factorized evidences, difference in evidence between model with a factor versus not
-> varprecision.Data
-----
var_aic    : double    # aic evidence for ori independent variance
var_bic    : double    # bic evidence for ori independent variance
var_aicc   : double    # aicc evidence for ori independent variance
var_llmax  : double    # llmax evidence for ori independent variance
guess_aic  : double    # aic evidence for guessing
guess_bic  : double    # bic evidence for guessing
guess_aicc : double    # aicc evidence for guessing
guess_llmax: double    # llmax evidence for guessing
dn_aic     : double    # aic evidence for decision noise
dn_bic     : double    # bic evidence for decision noise
dn_aicc    : double    # aicc evidence for decision noise
dn_llmax   : double    # llmax evidence for decision noise
%}

classdef EviFactorGDV < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Data & 'exp_id<12'
    end
	
    methods(Access=protected)
        
		function makeTuples(self, key)
        
            [var_aicMat, var_bicMat, var_aiccMat, var_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("VP","VPN","VPG","VPGN")','aic','bic','aicc','llmax');
            [non_var_aicMat, non_var_bicMat, non_var_aiccMat, non_var_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("CP","CPN","CPG","CPGN")','aic','bic','aicc','llmax');
            [guess_aicMat, guess_bicMat, guess_aiccMat, guess_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("CPG","CPGN","VPG","VPGN")','aic','bic','aicc','llmax');
            [non_guess_aicMat, non_guess_bicMat, non_guess_aiccMat, non_guess_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("CP","CPN","VP","VPN")','aic','bic','aicc','llmax');
            [dn_aicMat, dn_bicMat, dn_aiccMat, dn_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("CPN","CPGN","VPN","VPGN")','aic','bic','aicc','llmax');
            [non_dn_aicMat, non_dn_bicMat, non_dn_aiccMat, non_dn_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & 'model_name in ("CP","CPG","VP","VPG")','aic','bic','aicc','llmax');
            
            % aic 
            min_val = min(min(var_aicMat),min(non_var_aicMat));
            
            res_var_aicMat = var_aicMat - min_val;
            res_non_var_aicMat = non_var_aicMat - min_val;
            
            res_guess_aicMat = guess_aicMat - min_val;
            res_non_guess_aicMat = non_guess_aicMat - min_val;
            
            res_dn_aicMat = dn_aicMat - min_val;
            res_non_dn_aicMat = non_dn_aicMat - min_val;
            
            var_aic_ratio = mean(exp(-res_var_aicMat))/(mean(exp(-res_non_var_aicMat)));
            key.var_aic = var_aic_ratio/(var_aic_ratio+1);
            
            guess_aic_ratio = mean(exp(-res_guess_aicMat))/(mean(exp(-res_non_guess_aicMat)));
            key.guess_aic = guess_aic_ratio/(guess_aic_ratio+1);
            
            dn_aic_ratio = mean(exp(-res_dn_aicMat))/(mean(exp(-res_non_dn_aicMat)));
            key.dn_aic = dn_aic_ratio/(dn_aic_ratio+1);
           
            % bic
            min_val = min(min(var_bicMat),min(non_var_bicMat));
           
            res_var_bicMat = var_bicMat - min_val;
            res_non_var_bicMat = non_var_bicMat - min_val;
            
            res_guess_bicMat = guess_bicMat - min_val;
            res_non_guess_bicMat = non_guess_bicMat - min_val;
            
            res_dn_bicMat = dn_bicMat - min_val;
            res_non_dn_bicMat = non_dn_bicMat - min_val;
            
            var_bic_ratio = mean(exp(-res_var_bicMat))/(mean(exp(-res_non_var_bicMat)));
            key.var_bic = var_bic_ratio/(var_bic_ratio+1);
            
            guess_bic_ratio = mean(exp(-res_guess_bicMat))/(mean(exp(-res_non_guess_bicMat)));
            key.guess_bic = guess_bic_ratio/(guess_bic_ratio+1);
            
            dn_bic_ratio = mean(exp(-res_dn_bicMat))/(mean(exp(-res_non_dn_bicMat)));
            key.dn_bic = dn_bic_ratio/(dn_bic_ratio+1);
            
            % aicc
            min_val = min(min(var_aiccMat),min(non_var_aiccMat));
            
            res_var_aiccMat = var_aiccMat - min_val;
            res_non_var_aiccMat = non_var_aiccMat - min_val;
            
            res_guess_aiccMat = guess_aiccMat - min_val;
            res_non_guess_aiccMat = non_guess_aiccMat - min_val;
            
            res_dn_aiccMat = dn_aiccMat - min_val;
            res_non_dn_aiccMat = non_dn_aiccMat - min_val;
            
            var_aicc_ratio = mean(exp(-res_var_aiccMat))/(mean(exp(-res_non_var_aiccMat)));
            key.var_aicc = var_aicc_ratio/(var_aicc_ratio+1);
            
            guess_aicc_ratio = mean(exp(-res_guess_aiccMat))/(mean(exp(-res_non_guess_aiccMat)));
            key.guess_aicc = guess_aicc_ratio/(guess_aicc_ratio+1);
            
            dn_aicc_ratio = mean(exp(-res_dn_aiccMat))/(mean(exp(-res_non_dn_aiccMat)));
            key.dn_aicc = dn_aicc_ratio/(dn_aicc_ratio+1);
            
            % llmax
            max_val = max(max(var_llmaxMat),max(non_var_llmaxMat));
            
            res_var_llmaxMat = var_llmaxMat - max_val;
            res_non_var_llmaxMat = non_var_llmaxMat - max_val;
            
            res_guess_llmaxMat = guess_llmaxMat - max_val;
            res_non_guess_llmaxMat = non_guess_llmaxMat - max_val;
            
            res_dn_llmaxMat = dn_llmaxMat - max_val;
            res_non_dn_llmaxMat = non_dn_llmaxMat - max_val;
            
            var_llmax_ratio = mean(exp(res_var_llmaxMat))/(mean(exp(res_non_var_llmaxMat)));
            key.var_llmax = var_llmax_ratio/(var_llmax_ratio+1);
            
            guess_llmax_ratio = mean(exp(res_guess_llmaxMat))/(mean(exp(res_non_guess_llmaxMat)));
            key.guess_llmax = guess_llmax_ratio/(guess_llmax_ratio+1);
            
            dn_llmax_ratio = mean(exp(res_dn_llmaxMat))/(mean(exp(res_non_dn_llmaxMat)));
            key.dn_llmax = dn_llmax_ratio/(dn_llmax_ratio+1);
            
            self.insert(key)
		end
	end

end