%{
varprecision.LogLikelihoodMat (computed) # compute prediction table based on the precomputed tables
->varprecision.PrecomputedTable
->varprecision.DataStats
-----
ll_mat_path     : varchar(256)     # path for log likelihood matrix for all combination of parameters, length of each dimention is the length of the parameters

%}

classdef LogLikelihoodMat < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.PrecomputedTable * varprecision.DataStats;
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            
            % fetch the prediction table, compute table with guessing if needed
            [prediction,trial_num_sim] = fetch1(varprecision.PrecomputedTable & key,'prediction_table','trial_num_sim');
            pars = fetch(varprecision.ParameterSet & key,'*');
            subj_info = fetch(varprecision.Subject & key,'*');
            setsizes = fetch1(varprecision.Experiment & key, 'setsize');
            
            if ismember(key.model_name, {'CPG','VPG'})
                prediction = varprecision.utils.computePredGuessing(prediction,pars.guess);
            end
            
            % reset 0 or 1 to avoid numerical problems
            prediction = varprecision.utils.correctNumErr(prediction,trial_num_sim);
            
            % compute prediction table
            [cnt_l,cnt_r] = fetch1(varprecision.DataStats & key, 'cnt_l','cnt_r');
            
            if length(setsizes)==1
                ll_mat  = squeeze(sum(bsxfun(@times, cnt_r, log(prediction))  + bsxfun(@times, cnt_l, log(1 - prediction))));
            else
                ll_mat = squeeze(sum(bsxfun(@times, cnt_r, log(prediction))  + bsxfun(@times, cnt_l, log(1 - prediction)),2));
            end
            
            ll_mat_path = ['~/Documents/MATLAB/local/+varprecision/results/exp_' num2str(pars.exp_id) '/'];
            
            if ~exist(ll_mat_path,'dir')
                mkdir(ll_mat_path)
            end
            filename = [subj_info.subj_initial '_' pars.model_name '_' num2str(pars.parset_id) '.mat'];
            
            key.ll_mat_path = [ll_mat_path filename];
            save(key.ll_mat_path,'ll_mat');            
            
            self.insert(key)
            makeTuples(varprecision.LogLikelihoodMatAll,key)
		end
	end

end