%{
varprecision.EviFactorRemoveGV (computed) # lesion of different factors from GV model
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
%}

classdef EviFactorRemoveGV < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Data
    end
	
    methods(Access=protected)
        
		function makeTuples(self, key)
            
            [vp_aic, vp_bic, vp_aicc, vp_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "VP"','aic','bic','aicc','llmax');
            [cpg_aic, cpg_bic, cpg_aicc, cpg_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "CPG"','aic','bic','aicc','llmax');
            [vpg_aic, vpg_bic, vpg_aicc, vpg_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "VPG"','aic','bic','aicc','llmax');
            
            key.guess_aic = vp_aic - vpg_aic;
            key.guess_bic = vp_bic - vpg_bic;
            key.guess_aicc = vp_aicc - vpg_aicc;
            key.guess_llmax = vpg_llmax - vp_llmax;
            
            key.var_aic = cpg_aic - vpg_aic;
            key.var_bic = cpg_bic - vpg_bic;
            key.var_aicc = cpg_aicc - vpg_aicc;
            key.var_llmax = vpg_llmax - cpg_llmax;
            
            self.insert(key)
		end
	end

end