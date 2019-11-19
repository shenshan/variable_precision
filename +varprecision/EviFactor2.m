%{
varprecision.EviFactor2 (computed) # compute factorized evidences, difference in evidence between model with a factor versus not, lesion of different factors from the best model.
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
dn_aic     : double    # aic evidence for decision noise
dn_bic     : double    # bic evidence for decision noise
dn_aicc    : double    # aicc evidence for decision noise
dn_llmax   : double    # llmax evidence for decision noise
total_var_aic   : double  # aic evidence for total variance
total_var_bic   : double  # bic evidence for total variance
total_var_aicc  : double  # aicc evidence for total variance
total_var_llmax : double  # llmax evidence for total variance
%}

classdef EviFactor2 < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Data
    end
	
    methods(Access=protected)
        
		function makeTuples(self, key)
            
            [vpgn_aic, vpgn_bic, vpgn_aicc, vpgn_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "VPGN"','aic','bic','aicc','llmax');
            [opgn_aic, opgn_bic, opgn_aicc, opgn_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "OPGN"','aic','bic','aicc','llmax');
            [opvpn_aic, opvpn_bic, opvpn_aicc, opvpn_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "OPVPN"','aic','bic','aicc','llmax');
            [opvpg_aic, opvpg_bic, opvpg_aicc, opvpg_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "OPVPG"','aic','bic','aicc','llmax');
            [cpgn_aic, cpgn_bic, cpgn_aicc, cpgn_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "CPGN"','aic','bic','aicc','llmax');
            [opvpgn_aic, opvpgn_bic, opvpgn_aicc, opvpgn_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "OPVPGN"','aic','bic','aicc','llmax');
            
            key.guess_aic = opvpn_aic - opvpgn_aic;
            key.guess_bic = opvpn_bic - opvpgn_bic;
            key.guess_aicc = opvpn_aicc - opvpgn_aicc;
            key.guess_llmax = opvpgn_llmax - opvpn_llmax;
            key.dn_aic = opvpg_aic - opvpgn_aic;
            key.dn_bic = opvpg_bic - opvpgn_bic;
            key.dn_aicc = opvpg_aicc - opvpgn_aicc;
            key.dn_llmax = opvpgn_llmax - opvpg_llmax;
            key.ori_aic = vpgn_aic - opvpgn_aic;
            key.ori_bic = vpgn_bic - opvpgn_bic;
            key.ori_aicc = vpgn_aicc - opvpgn_aicc;
            key.ori_llmax = opvpgn_llmax - vpgn_llmax;
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