%{
varprecision.LogLikelihoodMatCombined(computed) # combine prediction subtables
-> varprecision.Data
-> varprecision.ParameterSet
-> varprecision.JbarKappaMap
-----
ll_mat_path     : longblob     # log likelihood matrix for all combination of parameters, length of each dimention is the length of the parameters
%}

classdef LogLikelihoodMatCombined < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.Data * varprecision.ParameterSet * varprecision.JbarKappaMap & varprecision.PredictionSubTable
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            % return without inserting tuples if not all sub tables are populated
            lambda = fetch1(varprecision.ParameterSet & key,'lambda');           
            keys = fetch(varprecision.PredictionSubTable & key);
            if length(lambda)~=length(keys)
                return
            end
            setsizes = fetch(varprecision.Experiment & key, 'setsize');
            pred_sub_tables = fetchn(varprecision.PredictionSubTable & key, 'prediction_mat_sub');
            ll_mat = varprecision.utils.decell(pred_sub_tables);
            sz = size(ll_mat);
            if length(setsizes)==1
                ll_mat = permute(ll_mat,[1,length(sz),2:length(sz)-1]);
            else
                ll_mat = permute(ll_mat,[1:2,length(sz),3:length(sz)-1]);
            end
            ll_mat_path = ['~/Dropbox/VR/+varprecision/results/exp_' num2str(key.exp_id) '/'];
            
            if ~exist(ll_mat_path,'dir')
                mkdir(ll_mat_path)
            end
            filename = [key.subj_initial '_' key.model_name '_' num2str(key.parset_id) '.mat'];
            
            key.ll_mat_path = [ll_mat_path filename];
            save(key.ll_mat_path,'ll_mat');            
            
            self.insert(key)
            makeTuples(varprecision.LogLikelihoodMatAll,key)
            
		end
	end

end