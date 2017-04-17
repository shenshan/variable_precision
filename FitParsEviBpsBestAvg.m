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
            
            keys_run = fetch(varprecision.FitParsEviBpsRun & tuples, '*');
            
            key.n_repeats = 20;
            key.n_trials = 2000;
            
            tuple.trial_num_sim = key.n_trials;
            
            llmaxMat = zeros(length(keys_run),key.n_repeats);
            for ii = 1:length(keys_run)
                switch tuple.model_name
                    case 'CP'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat];
                    case 'CPN'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).sigma_dn_hat];
                    case 'CPG'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).guess_hat];
                    case 'CPGN'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).guess_hat,keys_run(ii).sigma_dn_hat];
                    case 'VP'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).theta_hat];
                    case 'VPN'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).theta_hat, keys_run(ii).sigma_dn_hat];
                    case 'VPG'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).theta_hat,keys_run(ii).guess_hat];
                    case 'VPGN'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).theta_hat,keys_run(ii).guess_hat,keys_run(ii).sigma_dn_hat];
                    case 'OP'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).beta_hat];
                    case 'OPN'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).beta_hat,keys_run(ii).sigma_dn_hat];
                    case 'OPG'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).beta_hat,keys_run(ii).guess_hat];
                    case 'OPGN'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).beta_hat,keys_run(ii).guess_hat,keys_run(ii).sigma_dn_hat];
                    case 'OPVP'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).theta_hat,keys_run(ii).beta_hat];
                    case 'OPVPN'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).theta_hat,keys_run(ii).beta_hat,keys_run(ii).sigma_dn_hat];
                    case 'OPVPG'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).theta_hat,keys_run(ii).beta_hat,keys_run(ii).guess_hat];
                    case 'OPVPGN'
                        params = [keys_run(ii).p_right_hat,keys_run(ii).lambda_hat,keys_run(ii).theta_hat,keys_run(ii).beta_hat,keys_run(ii).guess_hat,keys_run(ii).sigma_dn_hat];
                end
                for jj = 1:key.n_repeats
                    llmaxMat(ii,jj) = varprecision.decisionrule_bps.loglikelihood(params,tuple);
                end
            end
            
            llmaxMat = mean(llmaxMat,2);
            [llmax,idx] = max(llmaxMat);
            key.llmax = llmax;
            
            key.best_int_pnt_idx = keys_run(idx).int_point_id;
            key.best_run_idx = keys_run(idx).run_idx;
            key.llmax_original = keys_run(idx).llmax;
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
            key.bic = llmax + 0.5*npars*log(nTrials);
            key.aic = llmax + npars;
            key.aicc = key.aic + npars*(npars+1)/(nTrials-npars-1);
            key.llmax = -llmax;
            
			self.insert(key)
		end
	end

end