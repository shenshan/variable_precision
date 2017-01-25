%{
varprecision.FitPredictionBpsBest (computed) # compute fit predictions based on fit parameters found by bps method
-> varprecision.FitParsEviBpsBest
-----
prediction   : longblob          # prediction for each trial, a binary vector with the same length of the stimuli
prediction_plot : longblob      # prediction p_right, ready for plot
%}

classdef FitPredictionBpsBest < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.FitParsEviBpsBest
    end
    
	methods(Access=protected)

		function makeTuples(self, key)
            
            fit_pars = fetch(varprecision.FitParsEviBpsBest & key,'*');
            
            switch fit_pars.model_name
                case 'CP'
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat];
                case 'CPG'
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.guess_hat];
                case 'VP'
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.theta_hat];
                case 'VPG'
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.theta_hat, fit_pars.guess_hat];
                case {'XP','OP'}
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.beta_hat];
                case {'XPG','OPG'}
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.beta_hat, fit_pars.guess_hat];
                case {'XPVP','OPVP'}
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.theta_hat, fit_pars.beta_hat];
                case {'XPVPG','OPVPG'}
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.theta_hat, fit_pars.beta_hat, fit_pars.guess_hat];
                case 'CPN'
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.sigma_dn_hat];
                case 'CPGN'
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.guess_hat, fit_pars.sigma_dn_hat];
                case 'VPN'
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.theta_hat, fit_pars.sigma_dn_hat];
                case 'VPGN'
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.theta_hat, fit_pars.guess_hat, fit_pars.sigma_dn_hat];
                case {'XPN','OPN'}
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.beta_hat, fit_pars.sigma_dn_hat];
                case {'XPGN','OPGN'}
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.beta_hat, fit_pars.guess_hat, fit_pars.sigma_dn_hat];
                case {'XPVPN','OPVPN'}
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.theta_hat, fit_pars.beta_hat, fit_pars.sigma_dn_hat];
                case {'XPVPGN','OPVPGN'}
                    params = [fit_pars.p_right_hat, fit_pars.lambda_hat, fit_pars.theta_hat, fit_pars.beta_hat, fit_pars.guess_hat, fit_pars.sigma_dn_hat];
            end
            
            fit_pars.trial_num_sim = 5000;
            
            [~,~,key.prediction] = varprecision.decisionrule_bps.loglikelihood(params, fit_pars);
                
            if ~ismember(key.exp_id,[10,11])
                
                prediction = key.prediction;
                stims = fetch1(varprecision.DataStats & key, 'stims');
                [stimuli,set_size] = fetch1(varprecision.Data & key, 'stimuli','set_size');
                
                if key.exp_id==8
                    target_stimuli = stimuli(:,1) - stimuli(:,2);
                else
                    target_stimuli = stimuli(:,1);
                end
                idx = interp1(stims,1:length(stims),target_stimuli,'nearest','extrap');
                setsizes = unique(set_size);

                if length(setsizes)==1
                    key.prediction_plot = zeros(size(stims));

                    for ii = 1:length(stims)
                        prediction_sub = prediction(idx==ii);
                        key.prediction_plot(ii) = mean(prediction_sub);
                    end
                else

                    key.prediction_plot = zeros(length(setsizes),length(stims));

                    for jj = 1:length(setsizes)
                       idx_ss = idx(set_size==setsizes(jj));
                       prediction_ss = prediction(set_size==setsizes(jj));
                       for ii = 1:length(stims)
                           prediction_sub = prediction_ss(idx_ss==ii);
                           key.prediction_plot(jj,ii) = mean(prediction_sub);
                       end
                    end
                end
            else
                key.prediction_plot = 0;
            end

            self.insert(key);
        end
        
    end
    
end