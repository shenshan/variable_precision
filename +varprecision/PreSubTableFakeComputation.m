%{
varprecision.PreSubTableFakeComputation (computed) # Compute prediction sub tables for fake data test
->varprecision.PredictionSubTableIdx
->varprecision.JbarKappaMap
-----

%}

classdef PreSubTableFakeComputation < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = (varprecision.PredictionSubTableIdx & 'model_name in ("CP","VP","OP","XP")' & 'exp_id>5') * varprecision.JbarKappaMap
    end
	methods(Access=protected)

		function makeTuples(self, key)
            
            % load data
            setsizes = fetch1(varprecision.Experiment & key, 'setsize');
            subj = randKey(varprecision.Recording & key);
            [stimuli,set_size] = fetch1(varprecision.Data & key & subj, 'stimuli','set_size');
            
            if key.exp_id~=9
                stimuli = stimuli*pi/180;
            end
            
            lambda = fetch1(varprecision.PredictionSubTableIdx & key,'lambda_value');
            
            tuple = key;
            
            if ismember(key.model_name, {'CP','VP','OP','XP'})
                tuple.model_name = [key.model_name 'G'];
            end
            
            pars = fetch(varprecision.ParameterSet & tuple, '*');
            [kmap,jmap] = fetch1(varprecision.JbarKappaMap & key, 'kmap','jmap');
            pars.pre = 0;
            pars.trial_num_sim = 1000;
            exp_id = pars.exp_id;
            if exp_id == 7
                exp_id = exp_id - 1;
            elseif exp_id == 9
                pars.sigma_s = fetch1(varprecision.Experiment & key, 'sigma_s');
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
                    predtable_temp = zeros(length(stimuli),length(pars.p_right)); 
                    
                    if key.exp_id == 9
                        noiseMat = normrnd(0,1/sqrt(pars.lambda),[setsizes,pars.trial_num_sim]);
                    else
                        noiseMat = circ_vmrnd(zeros(setsizes,pars.trial_num_sim),pars.lambda)/2;
                    end
                    for ii = 1:length(stimuli)
                        xMat = repmat(stimuli(ii,:),pars.trial_num_sim,1)' + noiseMat;
                        predtable_temp(ii,:) = f_dr(xMat,pars);
                    end
                               
                    predtable = self.adjustPredTable(predtable_temp,key.model_name,pars);
                    predtable_G = self.adjustPredTable(predtable_temp,tuple.model_name,pars);
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
 
                    predtable = zeros(length(stimuli),length(pars.p_right),length(pars.theta));
                    predtable_G = zeros(length(stimuli),length(pars.p_right),length(pars.theta),length(pars.guess));

                    for ii = 1:length(pars.theta)                     
                        predtable_temp = zeros(length(stimuli),length(pars.p_right));
                        pars.lambdaMat = gamrnd(lambda/pars.theta(ii), pars.theta(ii), [setsizes, pars.trial_num_sim]);
                        
                        if  key.exp_id == 9
                            noiseMat = normrnd(0,1./sqrt(pars.lambdaMat));
                        else
                            pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                            noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
                        end
                        
                        for jj = 1:length(stimuli)
                            xMat = repmat(stimuli(jj,:),pars.trial_num_sim,1)'+noiseMat;
                            predtable_temp(jj,:) = f_dr(xMat,pars);
                        end
                        
                        predtable(:,:,ii) = self.adjustPredTable(predtable_temp,key.model_name,pars);
                        predtable_G(:,:,ii,:) = self.adjustPredTable(predtable_temp,tuple.model_name,pars);

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
                                pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
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
            elseif ismember(key.model_name,{'OP','XP'})
                sigma_baseline = 1/sqrt(lambda)*180/pi;
                if length(setsizes)==1
 
                    predtable = zeros(length(stimuli),length(pars.p_right),length(pars.theta));
                    predtable_G = zeros(length(stimuli),length(pars.p_right),length(pars.theta),length(pars.guess));

                    for ii = 1:length(pars.theta)                     
                        predtable_temp = zeros(length(stimuli),length(pars.p_right));           
                        for jj = 1:length(stimuli)
                            sigma = sigma_baseline*(1 + pars.theta(ii)*abs(sin(2*stimuli(jj,:))))/180*pi;

                            pars.lambdaMat = 1./sigma.^2;
                            pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                            pars.lambdaMat = repmat(pars.lambdaMat,pars.trial_num_sim,1)';
                            noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
                            
                            xMat = repmat(stimuli(jj,:),pars.trial_num_sim,1)' + noiseMat;
                            
                            if strcmp(key.model_name,'XP')
                                sigma = sigma_baseline*(1 + pars.theta(ii)*abs(sin(2*xMat)))/180*pi;
                                pars.lambdaMat = 1./sigma.^2;
                                pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                            end
                            predtable_temp(jj,:) = f_dr(xMat,pars);
                        end
                        
                        predtable(:,:,ii) = self.adjustPredTable(predtable_temp,key.model_name,pars);
                        predtable_G(:,:,ii,:) = self.adjustPredTable(predtable_temp,tuple.model_name,pars);

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
                            for kk = 1:length(stimuli_sub)
                                sigma = sigma_baseline*(1+pars.theta(ii)*abs(sin(2*stimuli_sub(kk,1:setsize))))/180*pi;
                                pars.lambdaMat = 1./sigma.^2;
                                pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                                pars.lambdaMat = repmat(pars.lambdaMat,pars.trial_num_sim,1)';
                                noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
                                
                                xMat = repmat(stimuli_sub(kk,1:setsize),pars.trial_num_sim,1)' + noiseMat;
                                if strcmp(key.model_name,'XP')
                                    sigma = sigma_baseline*(1 + pars.theta(ii)*abs(sin(2*xMat)))/180*pi;
                                    pars.lambdaMat = 1./sigma.^2;
                                    pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                                end
                                predtable_temp(:,kk) = f_dr(xMat,pars);
                            end
                            predtable(jj,:,ii) = self.adjustPredTable(predtable_temp,key.model_name,response_sub,pars);
                            predtable_G(jj,:,ii,:) = self.adjustPredTable(predtable_temp,tuple.model_name,response_sub,pars);                            
                            
                        end
                    end              
                end
                
            end
            
            self.insert(key)
            
            save_dir = ['~/Dropbox/VR/+varprecision/results/fake_table/exp' num2str(key.exp_id) '/'];
            if ~exist(save_dir,'dir')
                mkdir(save_dir)
            end
            
            dir_table = [save_dir num2str(key.model_name) '_' num2str(key.lambda_idx)];
            save(dir_table,'predtable')
            predtable = predtable_G;
            dir_table_G = [save_dir num2str(tuple.model_name) '_' num2str(tuple.lambda_idx)];
            save(dir_table_G,'predtable')
            
            key.pretable_sub_dir = dir_table;
            tuple.pretable_sub_dir = dir_table_G;
			makeTuples(varprecision.PreSubTableFake,key)
            makeTuples(varprecision.PreSubTableFake,tuple)
            
		end
    end
    methods(Static)
        function predtable = adjustPredTable(predtable_temp,model_name,pars)
                % this helper function adjusts the prediction table by adding guessing,
                % correcting numerical errors

                if ismember(model_name, {'CP','VP','OP','XP'})
                        predtable = varprecision.utils.correctNumErr(predtable_temp,pars.trial_num_sim);
                        
                elseif ismember(model_name,{'CPG','VPG','OPG','XPG'})
                        predtable = varprecision.utils.computePredGuessing(predtable_temp,pars.guess);
                        predtable = varprecision.utils.correctNumErr(predtable,pars.trial_num_sim);
                end         
                
        end
    end

end