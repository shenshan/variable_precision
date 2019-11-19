%{
varprecision.EviFactorRemoveGOV (computed) # lesion of different factors from GOV model
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

classdef EviFactorRemoveGOV < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Data
    end
	
    methods(Access=protected)
        
		function makeTuples(self, key)
            
            [opvp_aic, opvp_bic, opvp_aicc, opvp_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "OPVP"','aic','bic','aicc','llmax');
            [vpg_aic, vpg_bic, vpg_aicc, vpg_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "VPG"','aic','bic','aicc','llmax');
            [opg_aic, opg_bic, opg_aicc, opg_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "OPG"','aic','bic','aicc','llmax');
            [cpg_aic, cpg_bic, cpg_aicc, cpg_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "CPG"','aic','bic','aicc','llmax');
            [opvpg_aic, opvpg_bic, opvpg_aicc, opvpg_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "OPVPG"','aic','bic','aicc','llmax');
            
            key.guess_aic = opvp_aic - opvpg_aic;
            key.guess_bic = opvp_bic - opvpg_bic;
            key.guess_aicc = opvp_aicc - opvpg_aicc;
            key.guess_llmax = opvpg_llmax - opvp_llmax;
           
            key.ori_aic = vpg_aic - opvpg_aic;
            key.ori_bic = vpg_bic - opvpg_bic;
            key.ori_aicc = vpg_aicc - opvpg_aicc;
            key.ori_llmax = opvpg_llmax - vpg_llmax;
            key.var_aic = opg_aic - opvpg_aic;
            key.var_bic = opg_bic - opvpg_bic;
            key.var_aicc = opg_aicc - opvpg_aicc;
            key.var_llmax = opvpg_llmax - opg_llmax;
            key.total_var_aic = cpg_aic - opvpg_aic;
            key.total_var_bic = cpg_bic - opvpg_bic;
            key.total_var_aicc = cpg_aicc - opvpg_aicc;
            key.total_var_llmax = opvpg_llmax - cpg_llmax;
            
            self.insert(key)
		end
	end

end