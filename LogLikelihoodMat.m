%{
varprecision.LogLikelihoodMat (computed) # compute prediction table based on the precomputed tables
->varprecision.PrecomputedTable
->varprecision.DataStats
-----
ll_mat     : longblob     # log likelihood matrix for all combination of parameters, length of each dimention is the length of the parameters

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
            setsizes = fetch1(varprecision.Experiment & key, 'setsize');
            if strcmp(key.model_name,'CPG') 
                if length(setsizes)==1
                    guess_adj = repmat(permute(pars.guess,[1,3,4,2]),[size(prediction),1]);
                else
                    guess_adj = repmat(permute(pars.guess,[1,3,4,5,2]),[size(prediction),1]);
                end
                prediction = bsxfun(@times,prediction,1-guess_adj) + 0.5*guess_adj;
            elseif strcmp(key.model_name,'VPG')
                if length(setsizes)==1
                    guess_adj = repmat(permute(pars.guess,[1,3,4,5,2]),[size(prediction),1]);
                else
                    guess_adj = repmat(permute(pars.guess,[1,3,4,5,6,2]),[size(prediction),1]);
                end
                prediction = bsxfun(@times,prediction,1-guess_adj) + 0.5*guess_adj;
            end
            
            % reset 0 or 1 to avoid numerical problems
            prediction(prediction==1) = 1-1/trial_num_sim;
            prediction(prediction==0) = 1/trial_num_sim;
            
            % compute prediction table
            [cnt_l,cnt_r] = fetch1(varprecision.DataStats & key, 'cnt_l','cnt_r');
            
            if length(setsizes)==1
                ll_mat  = squeeze(sum(bsxfun(@times, cnt_r, log(prediction))  + bsxfun(@times, cnt_l, log(1 - prediction))));
            else
                ll_mat  = squeeze(sum(sum((bsxfun(@times, cnt_r, log(prediction))  + bsxfun(@times, cnt_l, log(1 - prediction))))));
            end
            
            key.ll_mat = single(ll_mat);
            
            self.insert(key)
            makeTuples(varprecision.LogLikelihoodMatAll,key)
		end
	end

end