%{
varprecision.PredSubTableComputation (computed) # Compute prediction subtable, the results are inserted into another table varpreciison.PredicitionSubTable
->varprecision.PredictionSubTableIdx
->varprecision.Data
->varprecision.JbarKappaMap
---

%}

classdef PredSubTableComputation < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = (varprecision.PredictionSubTableIdx & 'model_name in ("CP","VP")') * (varprecision.Data & (varprecision.Subject & 'subj_type="real"')) * varprecision.JbarKappaMap
    end
	
    methods(Access=protected)

		function makeTuples(self, key)
            
            % load data
            setsizes = fetch1(varprecision.Experiment & key, 'setsize');
            [stimuli,response,set_size] = fetch1(varprecision.Data & key, 'stimuli','response','set_size');
            stimuli = stimuli*pi/180;
            lambda = fetch1(varprecision.PredictionSubTableIdx & key,'lambda_value');
            
            tuple = key;
            if strcmp(key.model_name, 'CP')
                tuple.model_name = 'CPG';
            elseif strcmp(key.model_name, 'VP')
                tuple.model_name = 'VPG';
            end
            
            pars = fetch(varprecision.ParameterSet & tuple, '*');
            [kmap,jmap] = fetch1(varprecision.JbarKappaMap & key, 'kmap','jmap');
            pars.pre = 0;
            pars.trial_num_sim = 1000;
            exp_id = pars.exp_id;
            if exp_id == 7
                exp_id = exp_id - 1;
            end
            if exp_id == 6
                pars.bessel_kT = besseli0_fast(10);
            end
            pars.lambda = lambda;
            
            if  key.exp_id == 9 && key.jkmap_id == 2
                return
            end
            
            % decision rule function that will be called
            f_dr = eval(['@varprecision.decisionrule.exp' num2str(exp_id)]);
             
            if strcmp(key.model_name,'CP')
                
                pars.lambda = interp1(jmap,kmap,pars.lambda);
                
                if length(setsizes)==1
                    predtable_temp = zeros(length(pars.p_right),length(stimuli)); 
                    
                    if key.exp_id == 9
                        noiseMat = normrnd(0,1/sqrt(pars.lambda),[setsizes,pars.trial_num_sim]);
                    else
                        noiseMat = circ_vmrnd(zeros(setsizes,pars.trial_num_sim),1/sqrt(pars.lambda))/2;
                    end
                    for ii = 1:length(stimuli)
                        xMat = repmat(stimuli(ii,:),pars.trial_num_sim,1)' + noiseMat;
                        predtable_temp(:,ii) = f_dr(xMat,pars);
                    end
                               
                    predtable = self.adjustPredTable(predtable_temp,key.model_name,response,pars);
                    predtable_G = self.adjustPredTable(predtable_temp,tuple.model_name,response,pars);
                else
                    predtable = zeros(length(setsizes),length(pars.p_right));
                    predtable_G = zeros(length(setsizes),length(pars.p_right),length(pars.guess));
                    
                    for ii = 1:length(setsizes)
                        setsize = setsizes(ii);
                        stimuli_sub = stimuli(set_size==setsize,:);
                        response_sub = response(set_size==setsize);
                        predtable_temp = zeros(length(pars.p_right),length(stimuli_sub));
                        if  key.exp_id == 9
                            noiseMat = normrnd(0,1/sqrt(lambda),[setsize,pars.trial_num_sim]);
                        else
                            noiseMat = circ_vmrnd(zeros(setsize,pars.trial_num_sim),pars.lambda)/2;
                        end
                        for jj = 1:length(stimuli_sub)
                            xMat = repmat(stimuli_sub(jj,1:setsize),pars.trial_num_sim,1)' + noiseMat;
                            predtable_temp(:,jj) = f_dr(xMat,pars);
                        end
                        predtable(ii,:) = self.adjustPredTable(predtable_temp,key.model_name,response_sub,pars);
                        predtable_G(ii,:,:) = self.adjustPredTable(predtable_temp,tuple.model_name,response_sub,pars);
                    end
                    
                end
                 
            elseif strcmp(key.model_name,'VP')
                
                if length(setsizes)==1
 
                    predtable = zeros(length(pars.p_right),length(pars.theta));
                    predtable_G = zeros(length(pars.p_right),length(pars.theta),length(pars.guess));

                    for ii = 1:length(pars.theta)                     
                        predtable_temp = zeros(length(pars.p_right),length(stimuli));
                        pars.lambdaMat = gamrnd(lambda/pars.theta(ii), pars.theta(ii), [setsizes, pars.trial_num_sim]);
                        
                        if  key.exp_id == 9
                            noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
                        else
                            pars.lambdaMat = min(max(jmap),pars.lambdaMat);
                            pars.lambdaMat = interp1(jmap,kmap,pars.lambdaMat);
                            noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
                        end
                        
                        for jj = 1:length(stimuli)
                            xMat = repmat(stimuli(jj,:),pars.trial_num_sim,1)'+noiseMat;
                            predtable_temp(:,jj) = f_dr(xMat,pars);
                        end
                        
                        predtable(:,ii) = self.adjustPredTable(predtable_temp,key.model_name,response,pars);
                        predtable_G(:,ii,:) = self.adjustPredTable(predtable_temp,tuple.model_name,response,pars);

                    end
                else
                    predtable = zeros(length(setsizes),length(pars.p_right),length(pars.theta));
                    predtable_G = zeros(length(setsizes),length(pars.p_right),length(pars.theta),length(pars.guess));
                 
                    for ii = 1:length(pars.theta)  
                        for jj = 1:length(setsizes)
                            setsize = setsizes(jj);
                            stimuli_sub = stimuli(set_size==setsize,:);
                            response_sub = response(set_size==setsize);
                            predtable_temp = zeros(length(pars.p_right),length(stimuli_sub));
                            pars.lambdaMat = gamrnd(lambda/pars.theta(ii), pars.theta(ii), [setsize, pars.trial_num_sim]);
                            if  key.exp_id == 9
                                noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));      
                            else
                                pars.lambdaMat = min(max(jmap),pars.lambdaMat);
                                pars.lambdaMat = interp1(jmap,kmap,pars.lambdaMat);
                                noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
                            end
                            for kk = 1:length(stimuli_sub)
                                xMat = repmat(stimuli_sub(kk,1:setsize),pars.trial_num_sim,1)'+noiseMat;
                                predtable_temp(:,kk) = f_dr(xMat,pars);
                            end
                            predtable(jj,:,ii) = self.adjustPredTable(predtable_temp,key.model_name,response_sub,pars);
                            predtable_G(jj,:,ii,:) = self.adjustPredTable(predtable_temp,tuple.model_name,response_sub,pars);                            
                            
                        end
                    end
                end
            end
            
            self.insert(key)
            
            key.prediction_mat_sub = predtable;
            tuple.prediction_mat_sub = predtable_G;
			makeTuples(varprecision.PredictionSubTable,key)
            makeTuples(varprecision.PredictionSubTable,tuple)
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