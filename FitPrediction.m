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
                % multiple set sizes to be done
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
            end
  
            % for exp6-11, compute the predictions trial by trial 
            [stimuli,set_size] = fetch1(varprecision.Data & key,'stimuli','set_size');
            stimuli = stimuli*pi/180;
            pars.pre = 0;
            pars.p_right = pars.p_right_hat;
            pars.lambda = pars.lambda_hat;
            pars.theta = pars.theta_hat;
            pars.guess = pars.guess_hat;
            prediction = zeros(1,length(stimuli));
            for ii = 1:length(stimuli)
                if ismember(key.model_name,{'CP','CPG'})
                    if ismember(key.exp_id,gaussModelIdx)
                        noiseMat = normrnd(0,1/sqrt(pars.lambda),[set_size(ii),pars.trial_num_sim]);
                    else
                        noiseMat = circ_vmrnd(zeros(setsize(ii),pars.trial_num_sim),1/sqrt(pars.lambda))/2;
                    end
                elseif ismember(key.model_name,{'VP','VPG'})
                    pars.lambdaMat = gamrnd(lambda/pars.theta, pars.theta(ii), [setsizes, trial_num_sim]);
                    if ismember(key.exp_id,gaussModelIdx)
                        noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
                    else
                        noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
                    end
                end
                
            end
            
            
            key.prediction_plot = prediction_plot;
            self.insert(key)
		end
	end

end