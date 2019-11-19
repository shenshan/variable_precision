%{
varprecision.EviFactorRemoveGDV (computed) # lesion of different factors from GDV model
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

classdef EviFactorRemoveGDV < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Data
    end
	
    methods(Access=protected)
        
		function makeTuples(self, key)
            
            [vpn_aic, vpn_bic, vpn_aicc, vpn_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "VPN"','aic','bic','aicc','llmax');
            [vpg_aic, vpg_bic, vpg_aicc, vpg_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "VPG"','aic','bic','aicc','llmax');
            [cpgn_aic, cpgn_bic, cpgn_aicc, cpgn_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "CPGN"','aic','bic','aicc','llmax');
            [vpgn_aic, vpgn_bic, vpgn_aicc, vpgn_llmax] = fetch1(varprecision.FitParsEviBpsBestAvg & key & 'model_name = "OPVPGN"','aic','bic','aicc','llmax');
            
            key.guess_aic = vpn_aic - vpgn_aic;
            key.guess_bic = vpn_bic - vpgn_bic;
            key.guess_aicc = vpn_aicc - vpgn_aicc;
            key.guess_llmax = vpgn_llmax - vpn_llmax;
            
            key.dn_aic = vpg_aic - vpgn_aic;
            key.dn_bic = vpg_bic - vpgn_bic;
            key.dn_aicc = vpg_aicc - vpgn_aicc;
            key.dn_llmax = vpgn_llmax - vpg_llmax;
            
            key.var_aic = cpgn_aic - vpgn_aic;
            key.var_bic = cpgn_bic - vpgn_bic;
            key.var_aicc = cpgn_aicc - vpgn_aicc;
            key.var_llmax = vpgn_llmax - cpgn_llmax;
            
            
            self.insert(key)
		end
	end

end