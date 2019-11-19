%{
varprecision.FactorPosteriorAllModelsGOV (computed) # my newest table
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

%}

classdef FactorPosteriorAllModelsGOV < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Data & 'exp_id in (6,7,9)'
    end
	
    methods(Access=protected)
        
		function makeTuples(self, key)
            
            models = fetch(varprecision.Model & key & 'factor_code not in ("Unknown")' & 'rule not in ("Sign")' & 'model_type not in ("SumX")');
            models_ori = fetch(varprecision.Model & key & 'factor_code in ("O","OV","GO","GOV")' & models);
            models_non_ori = fetch(varprecision.Model & key & 'factor_code in ("Base","G","V","GV")' & models);
            models_var = fetch(varprecision.Model & key & 'factor_code in ("V","GV","OV","GOV")' & models);
            models_non_var = fetch(varprecision.Model & key & 'factor_code in ("Base","G","O","GO")' & models);
            models_guess = fetch(varprecision.Model & key & 'factor_code in ("G","GO","GV","GOV")' & models);
            models_non_guess = fetch(varprecision.Model & key & 'factor_code in ("Base","V","O","OV")' & models);
            models_total_var = fetch(varprecision.Model & key & 'factor_code in ("OV","GOV")' & models);
            models_non_total_var = fetch(varprecision.Model & key & 'factor_code in ("Base","G")' & 'factor_code not like "%V"' & models);
            
            [ori_aicMat, ori_bicMat, ori_aiccMat, ori_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & models_ori,'aic','bic','aicc','llmax');
            [non_ori_aicMat, non_ori_bicMat, non_ori_aiccMat, non_ori_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & models_non_ori,'aic','bic','aicc','llmax');
            [var_aicMat, var_bicMat, var_aiccMat, var_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & models_var,'aic','bic','aicc','llmax');
            [non_var_aicMat, non_var_bicMat, non_var_aiccMat, non_var_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & models_non_var,'aic','bic','aicc','llmax');
            [guess_aicMat, guess_bicMat, guess_aiccMat, guess_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & models_guess,'aic','bic','aicc','llmax');
            [non_guess_aicMat, non_guess_bicMat, non_guess_aiccMat, non_guess_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & models_non_guess,'aic','bic','aicc','llmax');
            [total_var_aicMat, total_var_bicMat, total_var_aiccMat, total_var_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & models_total_var,'aic','bic','aicc','llmax');
            [non_total_var_aicMat, non_total_var_bicMat, non_total_var_aiccMat, non_total_var_llmaxMat] = fetchn(varprecision.FitParsEviBpsBestAvg & key & models_non_total_var,'aic','bic','aicc','llmax');
            
            
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
            
            dn_aicc_ratio = mean(exp(-res_dn_aiccMat))/(mean(exp(-res_non_dn_aiccMat)));
            key.dn_aicc = dn_aicc_ratio/(dn_aicc_ratio+1);
            
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
            
            self.insert(key)
		end
	end

end