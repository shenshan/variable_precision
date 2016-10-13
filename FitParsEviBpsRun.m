%{
varprecision.FitParsEviBpsRun (computed) # compute fit parameters and maximum log likelihood with bps algorithm
-> varprecision.RunBps
-----
p_right_hat : double    # estimated p_right
lambda_hat  : blob      # estimated lambda
theta_hat=null   : double    # estimated theta, NaN if not exist
guess_hat=null   : double    # estimated guess, NaN if not exist
beta_hat=null    : double    # estimated beta, NaN if not exist
llmax       : double    # maximum likelihood
bic         : double     # bayesian information criterion
aic         : double     # alkeik information criterion
aicc        : double     # aicc
%}

classdef FitParsEviBpsRun < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.RunBps
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            
            tuple = key;
            [lb,ub,plb,pub] = fetch1(varprecision.ParamsRange & key,'lower_bound','upper_bound','plb','pub');
            x0 = fetch1(varprecision.InitialPoint & key, 'initial_point');           
            tuple.trial_num_sim = fetch1(varprecision.RunBps & key, 'trial_num_sim');
            
            [pars,llmax] = bps(@(params)varprecision.decisionrule_bps.loglikelihood(params,tuple),x0,lb,ub,plb,pub);
            
            setsizes = fetch1(varprecision.Experiment & key, 'setsize');
            
            if length(setsizes)==1
                key.p_right_hat = pars(1);
                key.lambda_hat = pars(2);

                switch key.model_name
                    case 'CPG'
                        key.guess_hat = pars(3);
                    case 'VP'
                        key.theta_hat = pars(3);
                    case 'VPG'
                        key.theta_hat = pars(3);
                        key.guess_hat = pars(4);
                    case 'XP'
                        key.beta_hat = pars(3);
                    case 'XPG'
                        key.beta_hat = pars(3);
                        key.guess_hat = pars(4);
                    case 'XPVP'
                        key.theta_hat = pars(3);
                        key.beta_hat = pars(4);
                    case 'XPVPG'
                        key.theta_hat = pars(3);
                        key.beta_hat = pars(4);
                        key.guess_hat = pars(5);
                end
            else
                key.p_right_hat = pars(1);
                key.lambda_hat = pars(2:5);

                switch key.model_name
                    case 'CPG'
                        key.guess_hat = pars(6);
                    case 'VP'
                        key.theta_hat = pars(6);
                    case 'VPG'
                        key.theta_hat = pars(6);
                        key.guess_hat = pars(7);
                    case 'XP'
                        key.beta_hat = pars(6);
                    case 'XPG'
                        key.beta_hat = pars(6);
                        key.guess_hat = pars(7);
                    case 'XPVP'
                        key.theta_hat = pars(6);
                        key.beta_hat = pars(7);
                    case 'XPVPG'
                        key.theta_hat = pars(6);
                        key.beta_hat = pars(7);
                        key.guess_hat = pars(8);
                end
            end
            
            nTrials = fetch1(varprecision.Data & key, 'ntrials');
            npars = fetch1(varprecision.Model & key, 'npars');
            key.bic = llmax + 0.5*npars*log(nTrials);
            key.aic = llmax + npars;
            key.aicc = key.aic + npars*(npars+1)/(nTrials-npars-1);
            key.llmax = -llmax;
            
			self.insert(key)
            datestr(now)
        
		end
	end

end