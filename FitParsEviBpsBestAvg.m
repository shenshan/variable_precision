%{
varprecision.FitParsEviBpsBestAvg (computed) # my newest table
-> varprecision.Data
-> varprecision.Model
---
best_int_pnt_idx            : int                           # index of the best initial point
best_run_idx                : int                           # run idx of the best initial point
int_pnt_ids                 : blob                          # initial point ids covered by this tuple
run_ids                     : blob                          # run ids covered by this tuple
p_right_hat=null            : double                        # estimated p_right
lambda_hat                  : blob                          # estimated lambda
theta_hat=null              : double                        # estimated theta, NaN if not exist
guess_hat=null              : double                        # estimated guess, NaN if not exist
beta_hat=null               : double                        # estimated beta, NaN if not exist
sigma_dn_hat=null           : double                        # estimated decision noise, NaN if not existed
llmax                       : double                        # recomputed maximum likelihood
bic                         : double                        # recomputed bayesian information criterion
aic                         : double                        # recomputed alkeik information criterion
aicc                        : double                        # recomputed aicc
%}


classdef FitParsEviBpsBestAvg < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = (varprecision.Data*varprecision.Model) & varprecision.FitParsEviBpsRun
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            tuple = key;
            tuples = fetch(varprecision.FitParsEviBpsRunAvg & tuple);
            [key.int_pnt_ids,key.run_ids] = fetchn(varprecision.FitParsEviBpsRunAvg & tuple,'int_point_id','run_idx');
            
            keys_run = fetch(varprecision.FitParsEviBpsRun & tuples, '*');
          
            llmaxMat = fetchn(varprecision.FitParsEviBpsRunAvg & tuples, 'llmax_mean');
            [key.llmax, idx] = max(llmaxMat);
            
            key.best_int_pnt_idx = keys_run(idx).int_point_id;
            key.best_run_idx = keys_run(idx).run_idx;
            key.p_right_hat = keys_run(idx).p_right_hat;
            key.lambda_hat = keys_run(idx).lambda_hat;
            key.theta_hat = keys_run(idx).theta_hat;
            key.beta_hat = keys_run(idx).beta_hat;
            key.guess_hat = keys_run(idx).guess_hat;
            key.sigma_dn_hat = keys_run(idx).sigma_dn_hat;
         
            nTrials = fetch1(varprecision.Data & key, 'ntrials');
            npars = fetch1(varprecision.Model & key, 'npars');
            sub = 0;
            if ~isempty(strfind(key.subj_initial,'_ss_'))
                sub = 1;
            end
            if sub == 1
                npars = npars - 3;
            end
            key.bic = -key.llmax + 0.5*npars*log(nTrials);
            key.aic = -key.llmax + npars;
            key.aicc = key.aic + npars*(npars+1)/(nTrials-npars-1);
            
            
			self.insert(key)
		end
	end

end
