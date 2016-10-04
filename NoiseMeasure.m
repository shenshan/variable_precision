%{
varprecision.NoiseMeasure (computed) # measure noise of LL computation
->varprecision.Data
->varprecision.Model
meaure_idx  : int     # measure index
-----
nrun   : int     # number of runs
ll_mat : double  # all log likelihoods that have benn computed
ll_mat_mean : double # mean log likelihood
ll_mat_std  : double # standard deviation of ll
ll_mat_range : double # range of ll
trial_num_sim : int    # number of simulation trials
run_host: varchar(256) # computer name of this run
run_time: double    # time of this run, in secs
%}

classdef NoiseMeasure < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = (varprecision.Data * varprecision.Model) & varprecision.FitParsEviBpsBest
    end
	methods(Access=protected)

		function makeTuples(self, key)
            tic
            key.measure_idx = 1;
            [~,key.run_host] = system('hostname');
			[p_right,lambda,theta,beta,guess] = fetch1(varprecision.FitParsEviBpsBest & key,'p_right_hat','lambda_hat','theta_hat','beta_hat','guess_hat');
            switch key.model_name
                case 'CP'
                    params = [p_right,lambda];
                case 'CPG'
                    params = [p_right,lambda,guess];
                case 'VP'
                    params = [p_right,lambda,theta];
                case 'VPG'
                    params = [p_right,lambda,theta,guess];
                case 'XP'
                    params = [p_right,lambda,beta];
                case 'XPG'
                    params = [p_right,lambda,beta,guess];
                case 'XPVP'
                    params = [p_right,lambda,theta,beta];
                case 'XPVPG'
                    params = [p_right,lambda,theta,beta,guess];
            end
            key.nrun = 20;
            key.trial_num_sim = 1000;
            ll_mat = zeros(1,key.nrun);
            for ii = 1:key.nrun
                ll_mat(ii) = -varprecision.decisionrule_bps.loglikelihood(params,key);
            end
            key.ll_mat_mean = mean(ll_mat);
            key.ll_mat_std = std(ll_mat);
            key.ll_mat = ll_mat;
            key.run_time = toc;
			self.insert(key)
            datestr(now)
		end
	end

end