%{
varprecision.EviFactorAddSimple (computed) # compute factorized evidences, difference in evidence between model with a factor versus not, extract data from table varprecsision.FitParsEviBpsBest
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

classdef EviFactorAddSimple < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Data
    end
	
    methods(Access=protected)
        
		function makeTuples(self, key)
            [cp_aic, cp_bic, cp_aicc, cp_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "CP"','aic','bic','aicc','llmax');
            [cpg_aic, cpg_bic, cpg_aicc, cpg_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "CPG"','aic','bic','aicc','llmax');
            [cpgn_aic, cpgn_bic, cpgn_aicc, cpgn_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "CPGN"','aic','bic','aicc','llmax');
            [opgn_aic, opgn_bic, opgn_aicc, opgn_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "OPGN"','aic','bic','aicc','llmax');
            [opvpgn_aic, opvpgn_bic, opvpgn_aicc, opvpgn_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "OPVPGN"','aic','bic','aicc','llmax');
            
            
            key.guess_aic = cp_aic - cpg_aic;
            key.guess_bic = cp_bic - cpg_bic;
            key.guess_aicc = cp_aicc - cpg_aicc;
            key.guess_llmax = cpg_llmax - cp_llmax;
            key.dn_aic = cpg_aic - cpgn_aic;
            key.dn_bic = cpg_bic - cpgn_bic;
            key.dn_aicc = cpg_aicc - cpgn_aicc;
            key.dn_llmax = cpgn_llmax - cpg_llmax;
            key.ori_aic = cpgn_aic - opgn_aic;
            key.ori_bic = cpgn_bic - opgn_bic;
            key.ori_aicc = cpgn_aicc - opgn_aicc;
            key.ori_llmax = opgn_llmax - cpgn_llmax;
            key.var_aic = opgn_aic - opvpgn_aic;
            key.var_bic = opgn_bic - opvpgn_bic;
            key.var_aicc = opgn_aicc - opvpgn_aicc;
            key.var_llmax = opvpgn_llmax - opgn_llmax;
            key.total_var_aic = cpgn_aic - opvpgn_aic;
            key.total_var_bic = cpgn_bic - opvpgn_bic;
            key.total_var_aicc = cpgn_aicc - opvpgn_aicc;
            key.total_var_llmax = opvpgn_llmax - cpgn_llmax;
          
            self.insert(key)
		end
	end

end
