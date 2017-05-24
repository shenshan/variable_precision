%{
varprecision.EviFactorAddEach (computed) # compute factorized evidences, difference in evidence between model with a factor versus base
-> varprecision.Data
---
ori_aic                     : double                        # aic evidence for ori dependent variance models
ori_bic                     : double                        # bic evidence for ori dependent variance models
ori_aicc                    : double                        # aicc evidence for ori dependent variance models
ori_llmax                   : double                        # llmax evidence for ori dependent variance models
var_aic                     : double                        # aic evidence for ori independent variance models
var_bic                     : double                        # bic evidence for ori independent variance models
var_aicc                    : double                        # aicc evidence for ori independent variance models
var_llmax                   : double                        # llmax evidence for ori independent variance models
guess_aic                   : double                        # aic evidence for guessing models
guess_bic                   : double                        # bic evidence for guessing models
guess_aicc                  : double                        # aicc evidence for guessing models
guess_llmax                 : double                        # llmax evidence for guessing models
dn_aic                      : double                        # aic evidence for decision noise
dn_bic                      : double                        # bic evidence for decision noise
dn_aicc                     : double                        # aicc evidence for decision noise
dn_llmax                    : double                        # llmax evidence for decision noise
total_var_aic               : double                        # aic evidence for total variance
total_var_bic               : double                        # bic evidence for total variance
total_var_aicc              : double                        # aicc evidence for total variance
total_var_llmax             : double                        # llmax evidence for total variance
%}

classdef EviFactorAddEach < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Data
    end
	
    methods(Access=protected)
        
		function makeTuples(self, key)
            [cp_aic, cp_bic, cp_aicc, cp_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "CP"','aic','bic','aicc','llmax');
            [cpg_aic, cpg_bic, cpg_aicc, cpg_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "CPG"','aic','bic','aicc','llmax');
            [cpn_aic, cpn_bic, cpn_aicc, cpn_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "CPN"','aic','bic','aicc','llmax');
            [op_aic, op_bic, op_aicc, op_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "OP"','aic','bic','aicc','llmax');
            [vp_aic, vp_bic, vp_aicc, vp_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "VP"','aic','bic','aicc','llmax');
            [opvp_aic, opvp_bic, opvp_aicc, opvp_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "OPVP"','aic','bic','aicc','llmax');
            
            
            key.guess_aic = cp_aic - cpg_aic;
            key.guess_bic = cp_bic - cpg_bic;
            key.guess_aicc = cp_aicc - cpg_aicc;
            key.guess_llmax = cpg_llmax - cp_llmax;
            key.dn_aic = cp_aic - cpn_aic;
            key.dn_bic = cp_bic - cpn_bic;
            key.dn_aicc = cp_aicc - cpn_aicc;
            key.dn_llmax = cpn_llmax - cp_llmax;
            key.ori_aic = cp_aic - op_aic;
            key.ori_bic = cp_bic - op_bic;
            key.ori_aicc = cp_aicc - op_aicc;
            key.ori_llmax = op_llmax - cp_llmax;
            key.var_aic = cp_aic - vp_aic;
            key.var_bic = cp_bic - vp_bic;
            key.var_aicc = cp_aicc - vp_aicc;
            key.var_llmax = cp_llmax - vp_llmax;
            key.total_var_aic = cp_aic - opvp_aic;
            key.total_var_bic = cp_bic - opvp_bic;
            key.total_var_aicc = cp_aicc - opvp_aicc;
            key.total_var_llmax = opvp_llmax - cp_llmax;
          
            self.insert(key)
		end
	end

end
