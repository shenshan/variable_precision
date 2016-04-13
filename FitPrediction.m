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
            end
  
            % for exp6-11, compute the predictions trial by trial --to be done
            key.prediction = 0;
            key.prediction_plot = prediction_plot;
            self.insert(key)
		end
	end

end