%{
varprecision.FitParsEviBpsRun (computed) # compute fit parameters and maximum log likelihood with bps algorithm
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

classdef FitParsEviBpsRun < dj.Relvar & dj.AutoPopulate
	
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
                
                if strcmp(model_type,'opt')
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
                        case {'OP','XP'}
                            key.beta_hat = pars(3);
                        case {'OPG','XPG'}
                            key.beta_hat = pars(3);
                            key.guess_hat = pars(4);
                        case {'OPVP','XPVP'}
                            key.theta_hat = pars(3);
                            key.beta_hat = pars(4);
                        case {'OPVPG','XPVPG'}
                            key.theta_hat = pars(3);
                            key.beta_hat = pars(4);
                            key.guess_hat = pars(5);
                        case 'CPN'
                            key.sigma_dn_hat = pars(3);
                        case 'CPGN'
                            key.guess_hat = pars(3);
                            key.sigma_dn_hat = pars(4);
                        case 'VPN'
                            key.theta_hat = pars(3);
                            key.sigma_dn_hat = pars(4);
                        case 'VPGN'
                            key.theta_hat = pars(3);
                            key.guess_hat = pars(4);
                            key.sigma_dn_hat = pars(5);
                        case 'OPN'
                            key.beta_hat = pars(3);
                            key.sigma_dn_hat = pars(4);
                        case 'OPGN'
                            key.beta_hat = pars(3);
                            key.guess_hat = pars(4);
                            key.sigma_dn_hat = pars(5);
                        case 'OPVPN'
                            key.theta_hat = pars(3);
                            key.beta_hat = pars(4);
                            key.sigma_dn_hat = pars(5);
                        case 'OPVPGN'
                            key.theta_hat = pars(3);
                            key.beta_hat = pars(4);
                            key.guess_hat = pars(5);
                            key.sigma_dn_hat = pars(6);
                    end
                else
                    key.lambda_hat = pars(1);
                    if strcmp(factor_code,'G')
                        key.guess_hat = pars(2);
                    elseif strcmp(factor_code,'D')
                        key.sigma_dn_hat = pars(2);
                    elseif strcmp(factor_code,'GD')
                        key.guess_hat = pars(2);
                        key.sigma_dn_hat = pars(3);
                    elseif strcmp(factor_code,'O')
                        key.beta_hat = pars(2);
                    elseif strcmp(factor_code,'GO')
                        key.beta_hat = pars(2);
                        key.guess_hat = pars(3);
                    elseif strcmp(factor_code,'DO')
                        key.beta_hat = pars(2);
                        key.sigma_dn_hat = pars(3);
                    elseif strcmp(factor_code,'GDO')
                        key.beta_hat = pars(2);
                        key.guess_hat = pars(3);
                        key.sigma_dn_hat = pars(4);
                    elseif strcmp(factor_code,'V')
                        key.theta_hat = pars(2);
                    elseif strcmp(factor_code,'GV')
                        key.theta_hat = pars(2);
                        key.guess_hat = pars(3);
                    elseif strcmp(factor_code,'DV')
                        key.theta_hat = pars(2);
                        key.sigma_dn_hat = pars(3);
                    elseif strcmp(factor_code,'GDV')
                        key.theta_hat = pars(2);
                        key.guess_hat = pars(3);
                        key.sigma_dn_hat = pars(4);
                    elseif strcmp(factor_code,'OV')
                        key.theta_hat = pars(2);
                        key.beta_hat = pars(3);   
                    elseif strcmp(factor_code,'GOV')
                        key.theta_hat = pars(2);
                        key.beta_hat = pars(3);
                        key.guess_hat = pars(4);
                    elseif strcmp(factor_code,'DOV')
                        key.theta_hat = pars(2);
                        key.beta_hat = pars(3);
                        key.sigma_dn_hat = pars(4);
                    elseif strcmp(factor_code,'GDOV')
                        key.theta_hat = pars(2);
                        key.beta_hat = pars(3);
                        key.guess_hat = pars(4);
                        key.sigma_dn_hat = pars(5);
                    end
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
                    case {'OP','XP'}
                        key.beta_hat = pars(6);
                    case {'OPG','XPG'}
                        key.beta_hat = pars(6);
                        key.guess_hat = pars(7);
                    case {'OPVP','XPVP'}
                        key.theta_hat = pars(6);
                        key.beta_hat = pars(7);
                    case {'OPVPG','XPVPG'}
                        key.theta_hat = pars(6);
                        key.beta_hat = pars(7);
                        key.guess_hat = pars(8);
                    case 'CPN'
                        key.sigma_dn_hat = pars(6);
                    case 'CPGN'
                        key.guess_hat = pars(6);
                        key.sigma_dn_hat = pars(7);
                    case 'VPN'
                        key.theta_hat = pars(6);
                        key.sigma_dn_hat = pars(7);
                    case 'VPGN'
                        key.theta_hat = pars(6);
                        key.guess_hat = pars(7);
                        key.sigma_dn_hat = pars(8);
                    case 'OPN'
                        key.beta_hat = pars(6);
                        key.sigma_dn_hat = pars(7);
                    case 'OPGN'
                        key.beta_hat = pars(6);
                        key.guess_hat = pars(7);
                        key.sigma_dn_hat = pars(8);
                    case 'OPVPN'
                        key.theta_hat = pars(6);
                        key.beta_hat = pars(7);
                        key.sigma_dn_hat = pars(8);
                    case 'OPVPGN'
                        key.theta_hat = pars(6);
                        key.beta_hat = pars(7);
                        key.guess_hat = pars(8);
                        key.sigma_dn_hat = pars(9);
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
