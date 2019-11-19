%{
varprecision.FitParsEviBpsBest (computed) # select the best bps run with maximum llmax
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
llmax                       : double                        # maximum likelihood
bic                         : double                        # bayesian information criterion
aic                         : double                        # alkeik information criterion
aicc                        : double                        # aicc
sigma_dn_hat=null           : double                        # estimated decision noise, NaN if not existed
%}

classdef FitParsEviBpsBest < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = (varprecision.Data*varprecision.Model) & varprecision.FitParsEviBpsRun
    end
	methods(Access=protected)

		function makeTuples(self, key)
			
            tuple = key;
            tuples = fetch(varprecision.FitParsEviBpsRun & tuple);
            [key.int_pnt_ids,key.run_ids] = fetchn(varprecision.FitParsEviBpsRun & tuple,'int_point_id','run_idx');
            
            llmaxMat = fetchn(varprecision.FitParsEviBpsRun & tuples, 'llmax');
            [key.llmax,idx] = max(llmaxMat);
            
            [key.best_int_pnt_idx,key.best_run_idx,...
             key.p_right_hat,key.lambda_hat,key.theta_hat,key.beta_hat,key.guess_hat,key.sigma_dn_hat,...
             key.llmax,key.bic,key.aic,key.aicc] = fetch1(varprecision.FitParsEviBpsRun & tuples(idx),... 
             'int_point_id','run_idx','p_right_hat','lambda_hat','theta_hat','beta_hat','guess_hat','sigma_dn_hat','llmax','bic','aic','aicc');

			self.insert(key)
		end
	end

end
