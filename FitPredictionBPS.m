%{
varprecision.FitPredictionBps (computed) # compute fit predictions based on fit parameters found by bps method
-> varprecision.FitParsEviBps
-----
prediction   : longblob          # prediction for each trial, a binary vector with the same length of the stimuli
prediction_plot : longblob      # prediction p_right, ready for plot
%}

classdef FitPredictionBps < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.FitParsEviBps
    end
    
	methods(Access=protected)

		function makeTuples(self, key)
            
            exp_id = key.exp_id;
            if ismember(exp_id,[3,5,7])
                exp_id = exp_id - 1;
            end
            [stimuli,set_size] = fetch1(varprecision.Data & key,'stimuli','set_size');
            setsizes = fetch1(varprecision.Experiment & key, 'setsize');
            
            fit_pars = fetch(varprecision.FitParsEviBps & key,'*');
            gaussModelIdx = [1,2,3,4,5,9];
            target_stimuli = stimuli(:,1);
            % to be deleted
                if ismember(key.exp_id, [2,4,6,9])
                    set_size = ones(length(stimuli),1)*4;
                elseif key.exp_id == 1
                    set_size = ones(length(stimuli),1);
                end
            %
            if ismember(key.exp_id, [6,7,8,10,11])
                [jmap,kmap] = fetch1(varprecision.JbarKappaMap  & 'jkmap_id = 2' & key,'jmap','kmap');
                stimuli = stimuli*pi/180;
            else
                fit_pars.sigma_s = fetch1(varprecision.Experiment & key, 'sigma_s');
            end


            fit_pars.pre = 0;
            fit_pars.p_right = fit_pars.p_right_hat;
            fit_pars.trial_num_sim = 1000;
            fit_pars.theta = fit_pars.theta_hat;

            f_dr = eval(['@varprecision.decisionrule.exp' num2str(exp_id)]);
            key.prediction = zeros(1,length(stimuli));
            for ii = 1:length(stimuli)

                fit_pars.lambda = fit_pars.lambda_hat(setsizes==set_size(ii));
                lambda = fit_pars.lambda_hat(setsizes==set_size(ii));
                if ismember(key.model_name,{'CP','CPG'})
                    if ismember(key.exp_id,gaussModelIdx)
                        noiseMat = normrnd(0,1/sqrt(fit_pars.lambda),[set_size(ii),fit_pars.trial_num_sim]);
                    else
                        fit_pars.lambda = fit_pars.lambda * 180^2/pi^2/4;
                        fit_pars.lambda = varprecision.utils.mapJK(fit_pars.lambda,jmap,kmap);
                        noiseMat = circ_vmrnd(zeros(set_size(ii),fit_pars.trial_num_sim),fit_pars.lambda)/2;
                    end
                elseif ismember(key.model_name,{'VP','VPG'})
                    fit_pars.lambdaMat = gamrnd(fit_pars.lambda/fit_pars.theta, fit_pars.theta, [set_size(ii), fit_pars.trial_num_sim]);
                    
                    if ismember(key.exp_id,gaussModelIdx)
                        noiseMat = normrnd(0,1./sqrt(fit_pars.lambdaMat));
                    else
                        fit_pars.lambdaMat = fit_pars.lambdaMat * 180^2/pi^2/4;
                        fit_pars.lambdaMat = varprecision.utils.mapJK(fit_pars.lambdaMat,jmap,kmap);
                        noiseMat = circ_vmrnd(0,fit_pars.lambdaMat)/2;
                    end
                elseif ismember(key.model_name,{'XP','XPG','XPVP','XPVPG'})
                    fit_pars.beta_hat = fetch1(varprecision.FitParsXP & key, 'beta_hat');
                    sigma_baseline = 1/sqrt(lambda);
                    sigma = sigma_baseline*(1 + fit_pars.beta_hat*abs(sin(2*stimuli(ii,1:set_size(ii)))));
                    fit_pars.lambdaMat = 1./sigma.^2;
                    if ismember(key.model_name, {'XP','XPG'})
                        fit_pars.lambdaMat = fit_pars.lambdaMat*180^2/pi^2/4;
                        fit_pars.lambdaMat = varprecision.utils.mapJK(fit_pars.lambdaMat,jmap,kmap);
                        fit_pars.lambdaMat = repmat(fit_pars.lambdaMat,fit_pars.trial_num_sim,1)';  
                    else
                        fit_pars.lambdaMat = repmat(fit_pars.lambdaMat, fit_pars.trial_num_sim,1)';
                        fit_pars.lambdaMat = gamrnd(fit_pars.lambdaMat/fit_pars.theta,fit_pars.theta);
                        fit_pars.lambdaMat = fit_pars.lambdaMat*180^2/pi^2/4;
                        fit_pars.lambdaMat = varprecision.utils.mapJK(fit_pars.lambdaMat,jmap,kmap);                       
                    end
                    noiseMat = circ_vmrnd(0,fit_pars.lambdaMat)/2;
                end
                x = repmat(stimuli(ii,1:set_size(ii)),fit_pars.trial_num_sim,1)'+noiseMat;
                if ismember(key.model_name,{'XP','XPG'})
                    sigma = sigma_baseline*(1 + fit_pars.beta_hat*abs(sin(2*x)))/180*pi;
                    fit_pars.lambdaMat = 1./sigma.^2/4;
                    fit_pars.lambdaMat = varprecision.utils.mapJK(fit_pars.lambdaMat, jmap, kmap);
                elseif ismember(key.model_name,{'XPVP','XPVPG'})
                    sigma = sigma_baseline*(1 + fit_pars.beta_hat*abs(sin(2*x)));
                    fit_pars.lambdaMat = 1./sigma.^2;
                    fit_pars.lambdaMat = gamrnd(fit_pars.lambdaMat/fit_pars.theta,fit_pars.theta);
                    fit_pars.lambdaMat = fit_pars.lambdaMat*180^2/pi^2/4;
                    fit_pars.lambdaMat = varprecision.utils.mapJK(fit_pars.lambdaMat,jmap,kmap);
                end
                key.prediction(ii) = f_dr(x,fit_pars);
            end
            if ismember(key.model_name,{'CPG','VPG','XPG','XPVPG'})
                key.prediction = key.prediction*(1-fit_pars.guess_hat) + .5*fit_pars.guess_hat;
            end
            
            prediction = key.prediction;
                
            if ismember(key.exp_id,[6,7,9])
                stims = fetch1(varprecision.DataStats & key, 'stims');

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