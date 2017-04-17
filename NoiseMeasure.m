%{
varprecision.NoiseMeasure (computed) # measure noise of LL computation
->varprecision.Data
->varprecision.Model
->varprecision.NoiseMeasureRun
-----
nrun   : int     # number of runs
ll_mat : longblob # all log likelihoods that have benn computed
ll_mat_mean : double # mean log likelihood
ll_mat_std  : double # standard deviation of ll
ll_mat_range : double # range of ll
trial_num_sim : int    # number of simulation trials
run_host: varchar(256) # computer name of this run
run_time: double    # time per ll run, in secs
%}

classdef NoiseMeasure < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = (varprecision.Data * varprecision.Model * varprecision.NoiseMeasureRun) & varprecision.FitParsEviBpsBest
    end
	methods(Access=protected)

		function makeTuples(self, key)
            tic
            [~,key.run_host] = system('hostname');
			[p_right,lambda,theta,beta,guess,sigma_dn] = fetch1(varprecision.FitParsEviBpsBest & key,'p_right_hat','lambda_hat','theta_hat','beta_hat','guess_hat','sigma_dn_hat');
            switch key.model_name
                case 'CP'
                    params = [p_right,lambda];
                case 'CPN'
                    params = [p_right,lambda,sigma_dn];
                case 'CPG'
                    params = [p_right,lambda,guess];
                case 'CPGN'
                    params = [p_right,lambda,guess,sigma_dn];
                case 'VP'
                    params = [p_right,lambda,theta];
                case 'VPN'
                    params = [p_right,lambda,theta,sigma_dn];
                case 'VPG'
                    params = [p_right,lambda,theta,guess];
                case 'VPGN'
                    params = [p_right,lambda,theta,guess,sigma_dn];
                case 'OP'
                    params = [p_right,lambda,beta];
                case 'OPN'
                    params = [p_right,lambda,beta,sigma_dn];
                case 'OPG'
                    params = [p_right,lambda,beta,guess];
                case 'OPGN'
                    params = [p_right,lambda,beta,guess,sigma_dn];
                case 'OPVP'
                    params = [p_right,lambda,theta,beta];
                case 'OPVPN'
                    params = [p_right,lambda,theta,beta,sigma_dn];
                case 'OPVPG'
                    params = [p_right,lambda,theta,beta,guess];
                case 'OPVPGN'
                    params = [p_right,lambda,theta,beta,guess,sigma_dn];
            end
            [key.nrun,key.trial_num_sim] = fetch1(varprecision.NoiseMeasureRun & key, 'nruns','run_trial_num_sim');
            
            ll_mat = zeros(1,key.nrun);
            for ii = 1:key.nrun
                ll_mat(ii) = -varprecision.decisionrule_bps.loglikelihood(params,key);
            end
            key.ll_mat_mean = mean(ll_mat);
            key.ll_mat_std = std(ll_mat);
            key.ll_mat_range = range(ll_mat);
            key.ll_mat = ll_mat;
            key.run_time = toc/key.nrun;
            
			self.insert(key)
            datestr(now)
		end
	end

end