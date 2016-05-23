%{
varprecision.PredictionSubTable (computed) # compute prediction sub table for experiments 6-11
->varprecision.PredictionSubTableIdx
->varprecision.Data
-----
prediction_mat_sub :  longblob   # length of each dimension is the length of the parameters, the values in the row other than lambda_idx are zeros.

%}

classdef PredictionSubTable < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.PredictionSubTableIdx * (varprecision.Data & (varprecision.Subject & 'subj_type="real"'))
    end
	
    methods(Access=protected)

		function makeTuples(self, key)
            
            % load data
            setsizes = fetch1(varprecision.Experiment & key, 'setsize');
            [stimuli,response,set_size] = fetch1(varprecision.Data & key, 'stimuli','response','set_size');
            stimuli = stimuli*pi/180;
            lambda = fetch1(varprecision.PredictionSubTableIdx & key,'lambda_value');
            pars = fetch(varprecision.ParameterSet & key, '*');
            pars.pre = 0;
            pars.trial_num_sim = 1000;
            exp_id = pars.exp_id;
            if exp_id == 7
                exp_id = exp_id - 1;
            end
            pars.lambda = lambda;
            gaussModelIdx = [1,2,3,4,5,9];
            % decision rule function that will be called
            f_dr = eval(['@varprecision.decisionrule.exp' num2str(exp_id)]);
            
            if ismember(key.model_name,{'CP','CPG'})
                
                if length(setsizes)==1
                    predtable_temp = zeros(length(pars.p_right),length(stimuli)); 
                    if ismember(key.exp_id,gaussModelIdx)
                        noiseMat = normrnd(0,1/sqrt(pars.lambda),[setsizes,pars.trial_num_sim]);
                    else
                        noiseMat = circ_vmrnd(zeros(setsizes,pars.trial_num_sim),1/sqrt(pars.lambda))/2;
                    end
                    for ii = 1:length(stimuli)
                        xMat = repmat(stimuli(ii,:),trial_num_sim,1)' + noiseMat;
                        predtable_temp(:,ii) = f_dr(xMat,pars);
                    end
                               
                    predtable = self.adjustPredTable(predtable_temp,key.model_name,response,pars);
                else
                   if strcmp(key.model_name,'CP')
                        predtable = zeros(length(setsizes),length(pars.p_right));
                    else
                        predtable = zeros(length(setsizes),length(pars.p_right),length(pars.guess));
                    end
                    for ii = 1:length(setsizes)
                        setsize = setsizes(ii);
                        stimuli_sub = stimuli(set_size==setsize,:);
                        response_sub = response(set_size==setsize);
                        predtable_temp = zeros(length(pars.p_right),length(stimuli_sub));
                        if ismember(key.exp_id,gaussModelIdx)
                            noiseMat = normrnd(0,1/sqrt(lambda),[setsize,pars.trial_num_sim]);
                        else
                            noiseMat = circ_vmrnd(zeros(setsize,pars.trial_num_sim),pars.lambda)/2;
                        end
                        for jj = 1:length(stimuli_sub)
                            xMat = repmat(stimuli_sub(jj,1:setsize),pars.trial_num_sim,1)' + noiseMat;
                            predtable_temp(:,jj) = f_dr(xMat,pars);
                        end
                       if strcmp(key.model_name,'CP')
                            predtable(ii,:) = self.adjustPredTable(predtable_temp,key.model_name,response_sub,pars);
                        else
                            predtable(ii,:,:) = self.adjustPredTable(predtable_temp,key.model_name,response_sub,pars);
                        end
                    end
                    
                end
                 
            elseif ismember(key.model_name,{'VP','VPG'})
                
                if length(setsizes)==1
                    if strcmp(key.model_name,'VP')
                        predtable = zeros(length(pars.p_right),length(pars.theta));
                    else
                        predtable = zeros(length(pars.p_right),length(pars.theta),length(pars.guess));
                    end
                    for ii = 1:length(pars.theta)                        
                        predtable_temp = zeros(length(pars.p_right,length(stimuli)));
                        pars.lambdaMat = gamrnd(lambda/pars.theta(ii), pars.theta(ii), [setsizes, pars.trial_num_sim]);
                        if ismember(key.exp_id,gaussModelIdx)
                            noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
                        else
                            noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
                        end
                        for jj = 1:length(stimuli)
                            xMat = repmat(stimuli(jj,:),trial_num_sim,1)'+noiseMat;
                            predtable_temp(:,jj) = f_dr(xMat,pars);
                        end
                        if strcmp(key.model_name,'VP')
                            predtable(ii,:) = self.adjustPredTable(predtable_temp,key.model_name,response,pars);
                        else
                            predtable(ii,:,:) = self.adjustPredTable(predtable_temp,key.model_name,response,pars);
                        end
                    end
                else
                    if strcmp(key.model_name,'VP')
                        predtable = zeros(length(setsizes),length(pars.p_right),length(pars.theta));
                    else
                        predtable = zeros(length(setsizes),length(pars.p_right),length(pars.theta),length(pars.guess));
                    end
                   
                    for ii = 1:length(pars.theta)  
                        for jj = 1:length(setsizes)
                            setsize = setsizes(jj);
                            stimuli_sub = stimuli(set_size==setsize,:);
                            response_sub = response(set_size==setsize);
                            predtable_temp = zeros(length(pars.p_right),length(stimuli_sub));
                            pars.lambdaMat = gamrnd(lambda/pars.theta(ii), pars.theta(ii), [setsize, pars.trial_num_sim]);
                            if ismember(key.exp_id,gaussModelIdx)
                                noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
                            else
                                noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
                            end
                            for kk = 1:length(stimuli_sub)
                                xMat = repmat(stimuli_sub(kk,1:setsize),pars.trial_num_sim,1)'+noiseMat;
                                predtable_temp(:,kk) = f_dr(xMat,pars);
                            end
                            if strcmp(key.model_name,'VP')
                                predtable(jj,:,ii) = self.adjustPredTable(predtable_temp,key.model_name,response_sub,pars);
                            else
                                predtable(jj,:,ii,:) = self.adjustPredTable(predtable_temp,key.model_name,response_sub,pars);
                            end                            
                        end
                    end
                end
            end
            key.prediction_mat_sub = predtable;
			self.insert(key)
        end
        
       
        
    end
    methods(Static)
        function log_predtable = adjustPredTable(predtable_temp,model_name,response,pars)
            % this helper function adjusts the prediction table by adding guessing,
            % correcting numerical error and adjust predictions of
            % reporting "left"(exp6-9) for "target absent"(exp10 and exp11)
            % taking log of predtable and sum over all trials.
            res = min(unique(response));
            
            if ismember(model_name, {'CP','VP'})
                    predtable_temp = varprecision.utils.correctNumErr(predtable_temp,pars.trial_num_sim);
                    predtable_temp(:,response==res) = 1 - predtable_temp(:,response==res);
            elseif ismember(model_name,{'CPG','VPG'})
                    predtable_temp = varprecision.utils.computePredGuessing(predtable_temp,pars.guess);
                    predtable_temp = varprecision.utils.correctNumErr(predtable_temp,pars.trial_num_sim);
                    predtable_temp(:,response==res,:) = 1 - predtable_temp(:,response==res,:);
            end         
            log_predtable = squeeze(sum(log(predtable_temp),2));

        end
    end

end