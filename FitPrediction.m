%{
varprecision.FitPrediction (computed) # compute the fit prediction with the MAP estimated parameters
-> varprecision.FitParametersEvidence
-----
prediction   : longblob          # prediction for each trial for exp6-11, a binary vector with the same length of the stimuli
prediction_plot : longblob      # prdiction p_right, ready for plot

%}


classdef FitPrediction < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.FitParametersEvidence
    end
    
    methods(Access=protected)
		function makeTuples(self, key)
            
            % for exp1-5, check pre-computed table to compute the predictions
			[exp_id,setsizes] = fetch1(varprecision.Experiment & key, 'exp_id','setsize');
            pars = fetch(varprecision.ParameterSet & key, '*');
            fit_pars = fetch(varprecision.FitParametersEvidence & key,'*');
            gaussModelIdx = [1,2,3,4,5,9];

            if ismember(exp_id,1:5)
                pretable = fetch1(varprecision.PrecomputedTable & key,'prediction_table');
                if ismember(pars.model_name,{'CPG','VPG'})
                    pretable = varprecision.utils.computePredGuessing(pretable,pars.guess);
                end
                
                if length(setsizes)==1
                    switch pars.model_name
                        case 'CP'
                            prediction_plot = squeeze(pretable(:,fit_pars.p_right_idx,fit_pars.lambda_idx));
                        case 'CPG'
                            prediction_plot = squeeze(pretable(:,fit_pars.p_right_idx,fit_pars.lambda_idx,fit_pars.guess_idx));
                        case 'VP'
                            prediction_plot = squeeze(pretable(:,fit_pars.p_right_idx,fit_pars.lambda_idx,fit_pars.theta_idx));
                        case 'VPG'
                            prediction_plot = squeeze(pretable(:,fit_pars.p_right_idx,fit_pars.lambda_idx,fit_pars.theta_idx,fit_pars.guess_idx));
                    end
                else
                    prediction_plot = zeros(size(pretable,1),size(pretable,2));
                    switch pars.model_name
                        case 'CP'
                            for ii = 1:length(setsizes)
                                prediction_plot(ii,:) = squeeze(pretable(ii,:,fit_pars.p_right_idx,fit_pars.lambda_idx(ii)));
                            end
                        case 'CPG'
                            for ii = 1:length(setsizes)
                                prediction_plot(ii,:) = squeeze(pretable(ii,:,fit_pars.p_right_idx,fit_pars.lambda_idx(ii),fit_pars.guess_idx));
                            end
                        case 'VP'
                            for ii = 1:length(setsizes)
                                prediction_plot(ii,:) = squeeze(pretable(ii,:,fit_pars.p_right_idx,fit_pars.lambda_idx(ii),fit_pars.theta_idx));
                            end
                        case 'VPG'
                            for ii = 1:length(setsizes)
                                prediction_plot(ii,:) = squeeze(pretable(ii,:,fit_pars.p_right_idx,fit_pars.lambda_idx(ii),fit_pars.theta_idx,fit_pars.guess_idx));
                            end
                    end
                end
                key.prediction = 0;
                key.prediction_plot = prediction_plot;
            
            elseif ismember(exp_id,[10,11]) 
                % for exp6-11, compute the predictions trial by trial 
                [stimuli,set_size] = fetch1(varprecision.Data & key,'stimuli','set_size');
                stimuli = stimuli*pi/180;
                fit_pars.pre = 0;
                fit_pars.p_right = fit_pars.p_right_hat;
                fit_pars.trial_num_sim = 1000;
                fit_pars.theta = fit_pars.theta_hat;

                f_dr = eval(['@varprecision.decisionrule.exp' num2str(key.exp_id)]);
                key.prediction = zeros(1,length(stimuli));
                for ii = 1:length(stimuli)
                    
                    fit_pars.lambda = fit_pars.lambda_hat(setsizes==set_size(ii));
                    if ismember(key.model_name,{'CP','CPG'})
                        if ismember(key.exp_id,gaussModelIdx)
                            noiseMat = normrnd(0,1/sqrt(fit_pars.lambda),[set_size(ii),fit_pars.trial_num_sim]);
                        else
                            noiseMat = circ_vmrnd(zeros(set_size(ii),fit_pars.trial_num_sim),fit_pars.lambda)/2;
                        end
                    elseif ismember(key.model_name,{'VP','VPG'})
                        fit_pars.lambdaMat = gamrnd(fit_pars.lambda/fit_pars.theta, fit_pars.theta, [set_size(ii), fit_pars.trial_num_sim]);
                        if ismember(key.exp_id,gaussModelIdx)
                            noiseMat = normrnd(0,1./sqrt(fit_pars.lambdaMat));
                        else
                            noiseMat = circ_vmrnd(0,fit_pars.lambdaMat)/2;
                        end
                    end
                    x = repmat(stimuli(ii,1:set_size(ii)),fit_pars.trial_num_sim,1)'+noiseMat;
                    key.prediction(ii) = f_dr(x,fit_pars);               
                end
                if ismember(key.model_name,{'CPG','VPG'})
                    key.prediction = key.prediction*(1-fit_pars.guess_hat) + .5*fit_pars.guess_hat;
                end
            else
                % exp 6-9
            end
              
            self.insert(key)
		end
	end

end