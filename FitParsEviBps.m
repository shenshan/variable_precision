%{
varprecision.FitParsEviBps (computed) # compute fit parameters and maximum log likelihood with bps algorithm
-> varprecision.Data
-> varprecision.Model
-----
p_right_hat : double    # estimated p_right
lambda_hat  : blob      # estimated lambda
theta_hat=null   : double    # estimated theta, NaN if not exist
guess_hat=null   : double    # estimated guess, NaN if not exist
llmax       : double    # maximum likelihood
bic         : double     # bayesian information criterion
aic         : double     # alkeik information criterion
aicc        : double     # aicc
%}

classdef FitParsEviBps < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.Data * varprecision.Model & varprecision.ParamsRange
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            
            [x0,lb,ub,plb,pub] = fetch1(varprecision.ParamsRange & key, 'start_point','lower_bound','upper_bound','plb','pub');

            [pars,llmax] = bps(@(params)varprecision.decisionrule_bps.loglikelihood(params,key),x0,lb,ub,plb,pub);
            
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
            end
            
            nTrials = fetch1(varprecision.Data & key, 'ntrials');
            npars = fetch1(varprecision.Model & key, 'npars');
            key.bic = llmax + 0.5*npars*log(nTrials);
            key.aic = llmax + npars;
            key.aicc = key.aic + npars*(npars+1)/(nTrials-npars-1);
            key.llmax = -llmax;
            
			self.insert(key)
		end
	end

end