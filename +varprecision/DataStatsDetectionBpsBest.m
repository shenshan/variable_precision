%{
varprecision.DataStatsDetectionBpsBest(computed) # compute data statistics and prediction statistics for detection tasks, ready for plotting
->varprecision.FitPredictionBpsBest
-----
data_pres_setsize     : longblob    # p_present of data on target present trials, as a function of set size
model_pres_setsize    : longblob    # p_present of model on target present trials, as a function of set size
data_abs_setsize      : longblob    # p_present of data on target absent trials, as a function of set size
model_abs_setsize     : longblob    # p_present of model on target absent trials, as a function of set size
data_pres_bin         : longblob    # p_present of data on target present trials, as a function of bins
model_pres_bin        : longblob    # p_present of model on target present trials, as a function of bins
data_abs_bin          : longblob    # p_present of data on target absent trials, as a function of bins
model_abs_bin         : longblob    # p_present of model on target absen trials, as a function of bins
bins                  : longblob    # in degs
min_diff              : longblob    # minimal difference between target and distractor orientations
%}

classdef DataStatsDetectionBpsBest < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.FitPredictionBpsBest & 'exp_id in (10,11,12)'
    end
    methods(Access=protected)

		function makeTuples(self, key)
            
            % bins roughly matched the figures in Helga 2013 paper.
            if key.exp_id==10
                bins = linspace(0,12,6);                
            elseif key.exp_id == 11
                bins = linspace(0,24,7);
            else
                bins = linspace(0,5.5,6);
            end
            bins = mean([bins(1:length(bins)-1);bins(2:length(bins))]);
            
            [stimuli,response,set_size] = fetch1(varprecision.Data & key, 'stimuli','response','set_size');
            
            prediction = fetch1(varprecision.FitPredictionBpsBest & key, 'prediction');
            key.min_diff = varprecision.utils.getMinDiff(stimuli);
             
            idx = interp1(bins,1:length(bins),key.min_diff,'nearest','extrap');
            setsizes = unique(set_size);
            C = any(stimuli'==0);
            
            key.data_pres_setsize = zeros(length(setsizes),1);
            key.data_abs_setsize = zeros(length(setsizes),1);
            key.model_pres_setsize = zeros(length(setsizes),1);
            key.model_abs_setsize = zeros(length(setsizes),1);
            key.data_pres_bin = zeros(length(setsizes),length(bins));
            key.data_abs_bin = zeros(length(setsizes),length(bins));
            key.model_pres_bin = zeros(length(setsizes),length(bins));
            key.model_abs_bin = zeros(length(setsizes),length(bins));
            
            for ii = 1:length(setsizes)
                setsize = setsizes(ii);
                res_sub = response(set_size==setsize);
                C_sub = C(set_size==setsize);
                pred_sub = prediction(set_size==setsize);
                idx_sub = idx(set_size==setsize);
                
                res_pres = res_sub(C_sub==1);
                res_abs = res_sub(C_sub==0);

                pred_pres = pred_sub(C_sub==1);
                pred_abs = pred_sub(C_sub==0);

                idx_pres = idx_sub(C_sub==1);
                idx_abs = idx_sub(C_sub==0);

                key.data_pres_setsize(ii) = mean(res_pres);
                key.data_abs_setsize(ii) = mean(res_abs);

                key.model_pres_setsize(ii) = mean(pred_pres);
                key.model_abs_setsize(ii) = mean(pred_abs);
                
                

                for jj = 1:length(bins)
                    res_pres_rel = res_pres(idx_pres==jj);
                    res_abs_rel = res_abs(idx_abs==jj);
                    pred_pres_rel = pred_pres(idx_pres==jj);
                    pred_abs_rel = pred_abs(idx_abs==jj);
                    
                    key.data_pres_bin(ii,jj) = mean(res_pres_rel);
                    key.data_abs_bin(ii,jj) = mean(res_abs_rel);
                    key.model_pres_bin(ii,jj) = mean(pred_pres_rel);
                    key.model_abs_bin(ii,jj) = mean(pred_abs_rel);

                end
            end

            key.bins = bins;
			self.insert(key)
		end
	end

end