%{
varprecision.EviFactorAdd (computed) # compute factorized evidences, difference in evidence between model with a factor versus not
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

classdef EviFactorAdd < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Data
    end
	
    methods(Access=protected)
        
		function makeTuples(self, key)
            [cp_aic, cp_bic, cp_aicc, cp_llmax] = fetch1(varprecision.FitParsEviBpsBest & key & 'model_name = "CP"','aic','bic','aicc','llmax');
            [cpg_aic, cpg_bic, cpg_aicc, cpg_llmax] = fetch1(varprecision.FitParsEviBpsBest & key & 'model_name = "CPG"','aic','bic','aicc','llmax');
            [opg_aic, opg_bic, opg_aicc, opg_llmax] = fetch1(varprecision.FitParsEviBpsBest & key & 'model_name = "OPG"','aic','bic','aicc','llmax');
            [opvpg_aic, opvpg_bic, opvpg_aicc, opvpg_llmax] = fetch1(varprecision.FitParsEviBpsBest & key & 'model_name = "OPVPG"','aic','bic','aicc','llmax');
            
            
            key.guess_aic = cp_aic - cpg_aic;
            key.guess_bic = cp_bic - cpg_bic;
            key.guess_aicc = cp_aicc - cpg_aicc;
            key.guess_llmax = cpg_llmax - cp_llmax;
            key.ori_aic = cpg_aic - opg_aic;
            key.ori_bic = cpg_bic - opg_bic;
            key.ori_aicc = cpg_aicc - opg_aicc;
            key.ori_llmax = opg_llmax - cpg_llmax;
            key.var_aic = opg_aic - opvpg_aic;
            key.var_bic = opg_bic - opvpg_bic;
            key.var_aicc = opg_aicc - opvpg_aicc;
            key.var_llmax = opvpg_llmax - opg_llmax;
          
            self.insert(key)
		end
	end

end