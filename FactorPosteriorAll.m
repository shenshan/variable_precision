%{
varprecision.FactorPosteriorAll (computed) # my newest table
-> varprecision.Experiment
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

classdef FactorPosteriorAll < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.Experiment
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            
            model_group_G = fetch(varprecision.Model & key & 'model_name in ("CPG","CPGN","VPG","VPGN","OPG","OPGN","OPVPG","OPVPGN")');
            model_group_nG = fetch(varprecision.Model & key & 'model_name in ("CP","CPN","VP","VPN","OP","OPN","OPVP","OPVPN")');
            model_group_N = fetch(varprecision.Model & key & 'model_name in ("CPN","CPGN","VPN","VPGN","OPN","OPGN","OPVPN","OPVPGN")');
            model_group_nN = fetch(varprecision.Model & key &'model_name in ("CP","CPG","VP","VPG","OP","OPG","OPVP","OPVPG")');
            model_group_O = fetch(varprecision.Model & key & 'model_name in ("OP","OPN","OPG","OPGN","OPVP","OPVPN","OPVPG","OPVPGN")');
            model_group_nO = fetch(varprecision.Model & key & 'model_name in ("CP","CPN","CPG","CPGN","VP","VPN","VPG","VPGN")'); 
            model_group_V = fetch(varprecision.Model & key & 'model_name in ("VP","VPN","VPG","VPGN","OPVP","OPVPN","OPVPG","OPVPGN")'); 
            model_group_nV = fetch(varprecision.Model & key & 'model_name in ("CP","CPN","CPG","CPGN","OP","OPN","OPG","OPGN")'); 
            model_group_OV = fetch(varprecision.Model & key & 'model_name in ("OPVP","OPVPN","OPVPG","OPVPGN")'); 
            model_group_nOV = fetch(varprecision.Model & key & 'model_name in ("CP","CPN","CPG","CPGN")');
            
            G_aicMat = cell(1,length(model_group_G));
            nG_aicMat = cell(1,length(model_group_nG));
            G_bicMat = cell(1,length(model_group_G));
            nG_bicMat = cell(1,length(model_group_nG));
            G_aiccMat = cell(1,length(model_group_G));
            nG_aiccMat = cell(1,length(model_group_nG));
            G_llmaxMat = cell(1,length(model_group_G));
            nG_llmaxMat = cell(1,length(model_group_nG));
            
            N_aicMat = cell(1,length(model_group_N));
            nN_aicMat = cell(1,length(model_group_nN));
            N_bicMat = cell(1,length(model_group_N));
            nN_bicMat = cell(1,length(model_group_nN));
            N_aiccMat = cell(1,length(model_group_N));
            nN_aiccMat = cell(1,length(model_group_nN));
            N_llmaxMat = cell(1,length(model_group_N));
            nN_llmaxMat = cell(1,length(model_group_nN));
            
            O_aicMat = cell(1,length(model_group_O));
            nO_aicMat = cell(1,length(model_group_nO));
            O_bicMat = cell(1,length(model_group_O));
            nO_bicMat = cell(1,length(model_group_nO));
            O_aiccMat = cell(1,length(model_group_O));
            nO_aiccMat = cell(1,length(model_group_nO));
            O_llmaxMat = cell(1,length(model_group_O));
            nO_llmaxMat = cell(1,length(model_group_nO));
            
            V_aicMat = cell(1,length(model_group_V));
            nV_aicMat = cell(1,length(model_group_nV));
            V_bicMat = cell(1,length(model_group_V));
            nV_bicMat = cell(1,length(model_group_nV));
            V_aiccMat = cell(1,length(model_group_V));
            nV_aiccMat = cell(1,length(model_group_nV));
            V_llmaxMat = cell(1,length(model_group_V));
            nV_llmaxMat = cell(1,length(model_group_nV));
            
            OV_aicMat = cell(1,length(model_group_OV));
            nOV_aicMat = cell(1,length(model_group_nOV));
            OV_bicMat = cell(1,length(model_group_OV));
            nOV_bicMat = cell(1,length(model_group_nOV));
            OV_aiccMat = cell(1,length(model_group_OV));
            nOV_aiccMat = cell(1,length(model_group_nOV));
            OV_llmaxMat = cell(1,length(model_group_OV));
            nOV_llmaxMat = cell(1,length(model_group_nOV));
            
            for ii = 1:length(model_group_G)
                iModel = model_group_G(ii);
                [G_aicMat{ii}, G_bicMat{ii},G_aiccMat{ii},G_llmaxMat{ii}] = fetchn(varprecision.FitParsEviBpsBestAvg & key & iModel, 'aic','bic','aicc','llmax');          
            end
            for ii = 1:length(model_group_nG)
                iModel = model_group_nG(ii);
                [nG_aicMat{ii}, nG_bicMat{ii},nG_aiccMat{ii},nG_llmaxMat{ii}] = fetchn(varprecision.FitParsEviBpsBestAvg & key & iModel, 'aic','bic','aicc','llmax');          
            end
            for ii = 1:length(model_group_N)
                iModel = model_group_N(ii);
                [N_aicMat{ii}, N_bicMat{ii},N_aiccMat{ii},N_llmaxMat{ii}] = fetchn(varprecision.FitParsEviBpsBestAvg & key & iModel, 'aic','bic','aicc','llmax');          
            end
            for ii = 1:length(model_group_nN)
                iModel = model_group_nN(ii);
                [nN_aicMat{ii}, nN_bicMat{ii},nN_aiccMat{ii},nN_llmaxMat{ii}] = fetchn(varprecision.FitParsEviBpsBestAvg & key & iModel, 'aic','bic','aicc','llmax');          
            end
            for ii = 1:length(model_group_O)
                iModel = model_group_O(ii);
                [O_aicMat{ii}, O_bicMat{ii},O_aiccMat{ii},O_llmaxMat{ii}] = fetchn(varprecision.FitParsEviBpsBestAvg & key & iModel, 'aic','bic','aicc','llmax');          
            end
            for ii = 1:length(model_group_nO)
                iModel = model_group_nO(ii);
                [nO_aicMat{ii}, nO_bicMat{ii},nO_aiccMat{ii},nO_llmaxMat{ii}] = fetchn(varprecision.FitParsEviBpsBestAvg & key & iModel, 'aic','bic','aicc','llmax');          
            end
            for ii = 1:length(model_group_V)
                iModel = model_group_V(ii);
                [V_aicMat{ii}, V_bicMat{ii},V_aiccMat{ii},V_llmaxMat{ii}] = fetchn(varprecision.FitParsEviBpsBestAvg & key & iModel, 'aic','bic','aicc','llmax');          
            end
            for ii = 1:length(model_group_nV)
                iModel = model_group_nV(ii);
                [nV_aicMat{ii}, nV_bicMat{ii},nV_aiccMat{ii},nV_llmaxMat{ii}] = fetchn(varprecision.FitParsEviBpsBestAvg & key & iModel, 'aic','bic','aicc','llmax');          
            end
            for ii = 1:length(model_group_OV)
                iModel = model_group_OV(ii);
                [OV_aicMat{ii}, OV_bicMat{ii},OV_aiccMat{ii},OV_llmaxMat{ii}] = fetchn(varprecision.FitParsEviBpsBestAvg & key & iModel, 'aic','bic','aicc','llmax');          
            end
            for ii = 1:length(model_group_nOV)
                iModel = model_group_nOV(ii);
                [nOV_aicMat{ii}, nOV_bicMat{ii},nOV_aiccMat{ii},nOV_llmaxMat{ii}] = fetchn(varprecision.FitParsEviBpsBestAvg & key & iModel, 'aic','bic','aicc','llmax');          
            end
            
            G_aic = cellfun(@sum,G_aicMat,'Un',1);
            nG_aic = cellfun(@sum,nG_aicMat,'Un',1);
            G_bic = cellfun(@sum,G_bicMat,'Un',1);
            nG_bic = cellfun(@sum,nG_bicMat,'Un',1);
            G_aicc = cellfun(@sum,G_aiccMat,'Un',1);
            nG_aicc = cellfun(@sum,nG_aiccMat,'Un',1);
            G_llmax = cellfun(@sum,G_llmaxMat,'Un',1);
            nG_llmax = cellfun(@sum,nG_llmaxMat,'Un',1);
            
            N_aic = cellfun(@sum,N_aicMat,'Un',1);
            nN_aic = cellfun(@sum,nN_aicMat,'Un',1);
            N_bic = cellfun(@sum,N_bicMat,'Un',1);
            nN_bic = cellfun(@sum,nN_bicMat,'Un',1);
            N_aicc = cellfun(@sum,N_aiccMat,'Un',1);
            nN_aicc = cellfun(@sum,nN_aiccMat,'Un',1);
            N_llmax = cellfun(@sum,N_llmaxMat,'Un',1);
            nN_llmax = cellfun(@sum,nN_llmaxMat,'Un',1);
            
            O_aic = cellfun(@sum,O_aicMat,'Un',1);
            nO_aic = cellfun(@sum,nO_aicMat,'Un',1);
            O_bic = cellfun(@sum,O_bicMat,'Un',1);
            nO_bic = cellfun(@sum,nO_bicMat,'Un',1);
            O_aicc = cellfun(@sum,O_aiccMat,'Un',1);
            nO_aicc = cellfun(@sum,nO_aiccMat,'Un',1);
            O_llmax = cellfun(@sum,O_llmaxMat,'Un',1);
            nO_llmax = cellfun(@sum,nO_llmaxMat,'Un',1);
            
            V_aic = cellfun(@sum,V_aicMat,'Un',1);
            nV_aic = cellfun(@sum,nV_aicMat,'Un',1);
            V_bic = cellfun(@sum,V_bicMat,'Un',1);
            nV_bic = cellfun(@sum,nV_bicMat,'Un',1);
            V_aicc = cellfun(@sum,V_aiccMat,'Un',1);
            nV_aicc = cellfun(@sum,nV_aiccMat,'Un',1);
            V_llmax = cellfun(@sum,V_llmaxMat,'Un',1);
            nV_llmax = cellfun(@sum,nV_llmaxMat,'Un',1);
            
            OV_aic = cellfun(@sum,OV_aicMat,'Un',1);
            nOV_aic = cellfun(@sum,nOV_aicMat,'Un',1);
            OV_bic = cellfun(@sum,OV_bicMat,'Un',1);
            nOV_bic = cellfun(@sum,nOV_bicMat,'Un',1);
            OV_aicc = cellfun(@sum,OV_aiccMat,'Un',1);
            nOV_aicc = cellfun(@sum,nOV_aiccMat,'Un',1);
            OV_llmax = cellfun(@sum,OV_llmaxMat,'Un',1);
            nOV_llmax = cellfun(@sum,nOV_llmaxMat,'Un',1);
            
            min_G_aic = min(min(G_aic),min(nG_aic));
            G_aic_ratio = mean(exp(-G_aic + min_G_aic))/mean(exp(-nG_aic+min_G_aic));
            key.guess_aic = G_aic_ratio/(G_aic_ratio+1);
            
            min_G_bic = min(min(G_bic),min(nG_bic));
            G_bic_ratio = mean(exp(-G_bic + min_G_bic))/mean(exp(-nG_bic+min_G_bic));
            key.guess_bic = G_bic_ratio/(G_bic_ratio+1);
           
            min_G_aicc = min(min(G_aicc),min(nG_aicc));
            G_aicc_ratio = mean(exp(-G_aicc + min_G_aicc))/mean(exp(-nG_aicc+min_G_aicc));
            key.guess_aicc = G_aicc_ratio/(G_aicc_ratio+1);
            
            max_G_llmax = max(max(G_llmax),max(nG_llmax));
            G_llmax_ratio = mean(exp(G_llmax - max_G_llmax))/mean(exp(nG_llmax - max_G_llmax));
            key.guess_llmax = G_llmax_ratio/(G_llmax_ratio+1);
            
            min_N_aic = min(min(N_aic),min(nN_aic));
            N_aic_ratio = mean(exp(-N_aic + min_N_aic))/mean(exp(-nN_aic+min_N_aic));
            key.dn_aic = N_aic_ratio/(N_aic_ratio+1);
            
            min_N_bic = min(min(N_bic),min(nN_bic));
            N_bic_ratio = mean(exp(-N_bic + min_N_bic))/mean(exp(-nN_bic+min_N_bic));
            key.dn_bic = N_bic_ratio/(N_bic_ratio+1);
           
            min_N_aicc = min(min(N_aicc),min(nN_aicc));
            N_aicc_ratio = mean(exp(-N_aicc + min_N_aicc))/mean(exp(-nN_aicc+min_N_aicc));
            key.dn_aicc = N_aicc_ratio/(N_aicc_ratio+1);
            
            max_N_llmax = max(max(N_llmax),max(nN_llmax));
            N_llmax_ratio = mean(exp(N_llmax - max_N_llmax))/mean(exp(nN_llmax - max_N_llmax));
            key.dn_llmax = N_llmax_ratio/(N_llmax_ratio+1);
            
            min_O_aic = min(min(O_aic),min(nO_aic));
            O_aic_ratio = mean(exp(-O_aic + min_O_aic))/mean(exp(-nO_aic+min_O_aic));
            key.ori_aic = O_aic_ratio/(O_aic_ratio+1);
            
            min_O_bic = min(min(O_bic),min(nO_bic));
            O_bic_ratio = mean(exp(-O_bic + min_O_bic))/mean(exp(-nO_bic+min_O_bic));
            key.ori_bic = O_bic_ratio/(O_bic_ratio+1);
           
            min_O_aicc = min(min(O_aicc),min(nO_aicc));
            O_aicc_ratio = mean(exp(-O_aicc + min_O_aicc))/mean(exp(-nO_aicc+min_O_aicc));
            key.ori_aicc = O_aicc_ratio/(O_aicc_ratio+1);
            
            max_O_llmax = max(max(O_llmax),max(nO_llmax));
            O_llmax_ratio = mean(exp(O_llmax - max_O_llmax))/mean(exp(nO_llmax - max_O_llmax));
            key.ori_llmax = O_llmax_ratio/(O_llmax_ratio+1);
            
            min_V_aic = min(min(V_aic),min(nV_aic));
            V_aic_ratio = mean(exp(-V_aic + min_V_aic))/mean(exp(-nV_aic+min_V_aic));
            key.var_aic = V_aic_ratio/(V_aic_ratio+1);
            
            min_V_bic = min(min(V_bic),min(nV_bic));
            V_bic_ratio = mean(exp(-V_bic + min_V_bic))/mean(exp(-nV_bic+min_V_bic));
            key.var_bic = V_bic_ratio/(V_bic_ratio+1);
           
            min_V_aicc = min(min(V_aicc),min(nV_aicc));
            V_aicc_ratio = mean(exp(-V_aicc + min_V_aicc))/mean(exp(-nV_aicc+min_V_aicc));
            key.var_aicc = V_aicc_ratio/(V_aicc_ratio+1);
            
            max_V_llmax = max(max(V_llmax),max(nV_llmax));
            V_llmax_ratio = mean(exp(V_llmax - max_V_llmax))/mean(exp(nV_llmax - max_V_llmax));
            key.var_llmax = V_llmax_ratio/(V_llmax_ratio+1);
            
            min_OV_aic = min(min(OV_aic),min(nOV_aic));
            OV_aic_ratio = mean(exp(-OV_aic + min_OV_aic))/mean(exp(-nOV_aic+min_OV_aic));
            key.total_var_aic = OV_aic_ratio/(OV_aic_ratio+1);
            
            min_OV_bic = min(min(OV_bic),min(nOV_bic));
            OV_bic_ratio = mean(exp(-OV_bic + min_OV_bic))/mean(exp(-nOV_bic+min_OV_bic));
            key.total_var_bic = OV_bic_ratio/(OV_bic_ratio+1);
           
            min_OV_aicc = min(min(OV_aicc),min(nOV_aicc));
            OV_aicc_ratio = mean(exp(-OV_aicc + min_OV_aicc))/mean(exp(-nOV_aicc+min_OV_aicc));
            key.total_var_aicc = OV_aicc_ratio/(OV_aicc_ratio+1);
            
            max_OV_llmax = max(max(OV_llmax),max(nOV_llmax));
            OV_llmax_ratio = mean(exp(OV_llmax - max_OV_llmax))/mean(exp(nOV_llmax - max_OV_llmax));
            key.total_var_llmax = OV_llmax_ratio/(OV_llmax_ratio+1);
            
  

            self.insert(key)
		end
	end

end