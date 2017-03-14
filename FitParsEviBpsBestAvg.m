%{
varprecision.FitParsEviBpsBestAvg (computed) # my newest table
-> varprecision.Data
-> varprecision.Model
---
best_int_pnt_idx            : int                           # index of the best initial point
best_run_idx                : int                           # run idx of the best initial point
int_pnt_ids                 : blob                          # initial point ids covered by this tuple
run_ids                     : blob                          # run ids covered by this tuple
p_right_hat                 : double                        # estimated p_right
lambda_hat                  : blob                          # estimated lambda
theta_hat=null              : double                        # estimated theta, NaN if not exist
guess_hat=null              : double                        # estimated guess, NaN if not exist
beta_hat=null               : double                        # estimated beta, NaN if not exist
sigma_dn_hat=null           : double                        # estimated decision noise, NaN if not existed
llmax_original              : double                        # maximum likelihood in the particular run
llmax                       : double                        # recomputed maximum likelihood
bic                         : double                        # recomputed bayesian information criterion
aic                         : double                        # recomputed alkeik information criterion
aicc                        : double                        # recomputed aicc
n_repeats                   : smallint                      # number of repetitions
n_trials                    : smallint                      # number of simulation trials
%}


classdef FitParsEviBpsBestAvg < dj.Relvar & dj.AutoPopulate
    
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
             key.llmax_original] = fetch1(varprecision.FitParsEviBpsRun & tuples(idx),... 
             'int_point_id','run_idx','p_right_hat','lambda_hat','theta_hat','beta_hat','guess_hat','sigma_dn_hat','llmax');
         
            key.n_repeats = 10;
            key.n_trials = 2000;
            
            tuple.trial_num_sim = key.n_trials;
            
            switch tuple.model_name
                case 'CP'
                    params = [key.p_right_hat,key.lambda_hat];
                case 'CPN'
                    params = [key.p_right_hat,key.lambda_hat,key.sigma_dn_hat];
                case 'CPG'
                    params = [key.p_right_hat,key.lambda_hat,key.guess_hat];
                case 'CPGN'
                    params = [key.p_right_hat,key.lambda_hat,key.guess_hat,key.sigma_dn_hat];
                case 'VP'
                    params = [key.p_right_hat,key.lambda_hat,key.theta_hat];
                case 'VPN'
                    params = [key.p_right_hat,key.lambda_hat,key.sigma_dn_hat];
                case 'VPG'
                    params = [key.p_right_hat,key.lambda_hat,key.theta_hat,key.guess_hat];
                case 'VPGN'
                    params = [key.p_right_hat,key.lambda_hat,key.theta_hat,key.guess_hat,key.sigma_dn_hat];
                case 'OP'
                    params = [key.p_right_hat,key.lambda_hat,key.beta_hat];
                case 'OPN'
                    params = [key.p_right_hat,key.lambda_hat,key.beta_hat,key.sigma_dn_hat];
                case 'OPG'
                    params = [key.p_right_hat,key.lambda_hat,key.beta_hat,key.guess_hat];
                case 'OPGN'
                    params = [key.p_right_hat,key.lambda_hat,key.beta_hat,key.guess_hat,key.sigma_dn_hat];
                case 'OPVP'
                    params = [key.p_right_hat,key.lambda_hat,key.theta_hat,key.beta_hat];
                case 'OPVPN'
                    params = [key.p_right_hat,key.lambda_hat,key.theta_hat,key.beta_hat,key.sigma_dn_hat];
                case 'OPVPG'
                    params = [key.p_right_hat,key.lambda_hat,key.theta_hat,key.beta_hat,key.guess_hat];
                case 'OPVPGN'
                    params = [key.p_right_hat,key.lambda_hat,key.theta_hat,key.beta_hat,key.guess_hat,key.sigma_dn_hat];
            end
                 
            
            llmaxMat = zeros(1,key.n_repeats);
            for ii = 1:key.n_repeats
                llmaxMat(ii) = varprecision.decisionrule_bps.loglikelihood(params,tuple);
            end
            
            llmax = mean(llmaxMat);
            nTrials = fetch1(varprecision.Data & key, 'ntrials');
            npars = fetch1(varprecision.Model & key, 'npars');
            sub = 0;
            if ~isempty(strfind(key.subj_initial,'_ss_'))
                sub = 1;
            end
            if sub == 1
                npars = npars - 3;
            end
            key.bic = llmax + 0.5*npars*log(nTrials);
            key.aic = llmax + npars;
            key.aicc = key.aic + npars*(npars+1)/(nTrials-npars-1);
            key.llmax = -llmax;
            
			self.insert(key)
		end
	end

end