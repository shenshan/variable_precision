%{
varprecision.FitParsEviBpsRunAvg (computed) # Compute average llmax for each initial point run
-> varprecision.FitParsEviBpsRun
-----
nrepeats      : smallint      # number of repeats
llmax_mat     : blob          # llmax in each repeat
llmax_mean    : double        # mean of llmax_mat
llmax_std     : double        # standard deviation llmax_mat
llmax_range   : double        # range of llmax_mat
trial_num_sim : int           # number of simulation trials
run_host      : varchar(256)  # computer name of this run
run_time      : double        # computation time of each repeat, in secs
%}

classdef FitParsEviBpsRunAvg < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.FitParsEviBpsRun
    end
    
	methods(Access=protected)

		function makeTuples(self, key)
            tic
            [~,key.run_host] = system('hostname');
			[p_right,lambda,theta,beta,guess,sigma_dn] = fetch1(varprecision.FitParsEviBpsRun & key,'p_right_hat','lambda_hat','theta_hat','beta_hat','guess_hat','sigma_dn_hat');
            
            model_type = fetch1(varprecision.Model & key, 'model_type');
            
            if strcmp(model_type,'opt')                
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
            else
                if ismember(key.model_name,{'GSum','GMax','GMin','GVar','GSign'})
                    params = [lambda, guess];
                else
                    params = [lambda,theta,beta,guess];
                end
            end
            
            key.trial_num_sim = 2000;
            key.nrepeats = 10;
            
            llmax_mat = zeros(1,key.nrepeats);
            for ii = 1:key.nrepeats
                llmax_mat(ii) = -varprecision.decisionrule_bps.loglikelihood(params,key);
            end
            key.llmax_mean = mean(llmax_mat);
            key.llmax_std = std(llmax_mat);
            key.llmax_range = range(llmax_mat);
            key.llmax_mat = llmax_mat;
            key.run_time = toc/key.nrepeats;
            
			self.insert(key)
            datestr(now)
		end
	end

end