%{
# compute fit parameters and maximum log likelihood with bps algorithm
-> varprecision.RunBps
---
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

classdef FitParsEviBpsRun < dj.Computed
	
    properties
        popRel = varprecision.RunBps
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            
            tuple = key;
            [lb,ub,plb,pub] = fetch1(varprecision.ParamsRange & key,'lower_bound','upper_bound','plb','pub');
            [model_type,factor_code] = fetch1(varprecision.Model & key, 'model_type','factor_code');
            sub = 0;
            if ~isempty(strfind(key.subj_initial,'_ss_'))
                sub = 1;
                if strcmp(key.model_name,'CP')
                    idx = 1:2;
                else
                    idx = [1,2,6:length(lb)];
                end
                lb = lb(idx);
                ub = ub(idx);
                plb = plb(idx);
                pub = pub(idx);
            end
            x0 = fetch1(varprecision.InitialPoint & key, 'initial_point');           
            tuple.trial_num_sim = fetch1(varprecision.RunBps & key, 'trial_num_sim');
            
            [pars,llmax] = bps(@(pars)varprecision.decisionrule_bps.loglikelihood(pars,tuple),x0,lb,ub,plb,pub);
            
            setsizes = unique(fetch1(varprecision.Data & key, 'set_size'));
            
            if length(setsizes)==1
                
                if ismember(model_type,{'opt','SumErf'})
                    key.p_right_hat = pars(1);
                    key.lambda_hat = pars(2);

                    switch factor_code
                        case 'G'
                            key.guess_hat = pars(3);
                        case 'V'
                            key.theta_hat = pars(3);
                        case 'GV'
                            key.theta_hat = pars(3);
                            key.guess_hat = pars(4);
                        case 'O'
                            key.beta_hat = pars(3);
                        case 'GO'
                            key.beta_hat = pars(3);
                            key.guess_hat = pars(4);
                        case 'OV'
                            key.theta_hat = pars(3);
                            key.beta_hat = pars(4);
                        case 'GOV'
                            key.theta_hat = pars(3);
                            key.beta_hat = pars(4);
                            key.guess_hat = pars(5);
                        case 'D'
                            key.sigma_dn_hat = pars(3);
                        case 'GD'
                            key.guess_hat = pars(3);
                            key.sigma_dn_hat = pars(4);
                        case 'DV'
                            key.theta_hat = pars(3);
                            key.sigma_dn_hat = pars(4);
                        case 'GDV'
                            key.theta_hat = pars(3);
                            key.guess_hat = pars(4);
                            key.sigma_dn_hat = pars(5);
                        case 'DO'
                            key.beta_hat = pars(3);
                            key.sigma_dn_hat = pars(4);
                        case 'GDO'
                            key.beta_hat = pars(3);
                            key.guess_hat = pars(4);
                            key.sigma_dn_hat = pars(5);
                        case 'DOV'
                            key.theta_hat = pars(3);
                            key.beta_hat = pars(4);
                            key.sigma_dn_hat = pars(5);
                        case 'GDOV'
                            key.theta_hat = pars(3);
                            key.beta_hat = pars(4);
                            key.guess_hat = pars(5);
                            key.sigma_dn_hat = pars(6);
                    end
                else
                    key.lambda_hat = pars(1);
                    switch factor_code
                        case 'G'
                            key.guess_hat = pars(2);
                        case 'D'
                            key.sigma_dn_hat = pars(2);
                        case 'GD'
                            key.guess_hat = pars(2);
                            key.sigma_dn_hat = pars(3);
                        case 'O'
                            key.beta_hat = pars(2);
                        case 'GO'
                            key.beta_hat = pars(2);
                            key.guess_hat = pars(3);
                        case 'DO'
                            key.beta_hat = pars(2);
                            key.sigma_dn_hat = pars(3);
                        case 'GDO'
                            key.beta_hat = pars(2);
                            key.guess_hat = pars(3);
                            key.sigma_dn_hat = pars(4);
                        case 'V'
                            key.theta_hat = pars(2);
                        case 'GV'
                            key.theta_hat = pars(2);
                            key.guess_hat = pars(3);
                        case 'DV'
                            key.theta_hat = pars(2);
                            key.sigma_dn_hat = pars(3);
                        case 'GDV'
                            key.theta_hat = pars(2);
                            key.guess_hat = pars(3);
                            key.sigma_dn_hat = pars(4);
                        case 'OV'
                            key.theta_hat = pars(2);
                            key.beta_hat = pars(3);   
                        case 'GOV'
                            key.theta_hat = pars(2);
                            key.beta_hat = pars(3);
                            key.guess_hat = pars(4);
                        case 'DOV'
                            key.theta_hat = pars(2);
                            key.beta_hat = pars(3);
                            key.sigma_dn_hat = pars(4);
                        case 'GDOV'
                            key.theta_hat = pars(2);
                            key.beta_hat = pars(3);
                            key.guess_hat = pars(4);
                            key.sigma_dn_hat = pars(5);
                    end
                end
            else
                if ismember(model_type,{'opt','SumErf'})
                    key.p_right_hat = pars(1);
                    key.lambda_hat = pars(2:5);

                    switch factor_code
                        case 'G'
                            key.guess_hat = pars(6);
                        case 'V'
                            key.theta_hat = pars(6);
                        case 'GV'
                            key.theta_hat = pars(6);
                            key.guess_hat = pars(7);
                        case 'O'
                            key.beta_hat = pars(6);
                        case 'GO'
                            key.beta_hat = pars(6);
                            key.guess_hat = pars(7);
                        case 'OV'
                            key.theta_hat = pars(6);
                            key.beta_hat = pars(7);
                        case 'GOV'
                            key.theta_hat = pars(6);
                            key.beta_hat = pars(7);
                            key.guess_hat = pars(8);
                        case 'D'
                            key.sigma_dn_hat = pars(6);
                        case 'GD'
                            key.guess_hat = pars(6);
                            key.sigma_dn_hat = pars(7);
                        case 'DV'
                            key.theta_hat = pars(6);
                            key.sigma_dn_hat = pars(7);
                        case 'GDV'
                            key.theta_hat = pars(6);
                            key.guess_hat = pars(7);
                            key.sigma_dn_hat = pars(8);
                        case 'DO'
                            key.beta_hat = pars(6);
                            key.sigma_dn_hat = pars(7);
                        case 'GDO'
                            key.beta_hat = pars(6);
                            key.guess_hat = pars(7);
                            key.sigma_dn_hat = pars(8);
                        case 'DOV'
                            key.theta_hat = pars(6);
                            key.beta_hat = pars(7);
                            key.sigma_dn_hat = pars(8);
                        case 'GDOV'
                            key.theta_hat = pars(6);
                            key.beta_hat = pars(7);
                            key.guess_hat = pars(8);
                            key.sigma_dn_hat = pars(9);
                    end
                else
                    key.lambda_hat = pars(1:4);
                    switch factor_code
                        case 'G'
                            key.guess_hat = pars(5);
                        case 'V'
                            key.theta_hat = pars(5);
                        case 'GV'
                            key.theta_hat = pars(5);
                            key.guess_hat = pars(6);
                        case 'O'
                            key.beta_hat = pars(5);
                        case 'GO'
                            key.beta_hat = pars(5);
                            key.guess_hat = pars(6);
                        case 'OV'
                            key.theta_hat = pars(5);
                            key.beta_hat = pars(6);
                        case 'GOV'
                            key.theta_hat = pars(5);
                            key.beta_hat = pars(6);
                            key.guess_hat = pars(7);
                        case 'D'
                            key.sigma_dn_hat = pars(5);
                        case 'GD'
                            key.guess_hat = pars(5);
                            key.sigma_dn_hat = pars(6);
                        case 'DV'
                            key.theta_hat = pars(5);
                            key.sigma_dn_hat = pars(6);
                        case 'GDV'
                            key.theta_hat = pars(5);
                            key.guess_hat = pars(6);
                            key.sigma_dn_hat = pars(7);
                        case 'DO'
                            key.beta_hat = pars(5);
                            key.sigma_dn_hat = pars(6);
                        case 'GDO'
                            key.beta_hat = pars(5);
                            key.guess_hat = pars(6);
                            key.sigma_dn_hat = pars(7);
                        case 'DOV'
                            key.theta_hat = pars(5);
                            key.beta_hat = pars(6);
                            key.sigma_dn_hat = pars(7);
                        case 'GDOV'
                            key.theta_hat = pars(5);
                            key.beta_hat = pars(6);
                            key.guess_hat = pars(7);
                            key.sigma_dn_hat = pars(8);
                    end
                end
                
            end
            
            nTrials = fetch1(varprecision.Data & key, 'ntrials');
            npars = fetch1(varprecision.Model & key, 'npars');
            if sub == 1
                npars = npars - 3;
            end
            key.bic = llmax + 0.5*npars*log(nTrials);
            key.aic = llmax + npars;
            key.aicc = key.aic + npars*(npars+1)/(nTrials-npars-1);
            key.llmax = -llmax;
            
			self.insert(key)
            datestr(now)
        
		end
	end

end
