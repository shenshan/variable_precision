%{
varprecision.FakeData (computed) # table to generate and save fake data
->varprecision.FakeDataParams
-----
fakepath   : varchar(256)
%}

classdef FakeData < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.FakeDataParams
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            
            exp_id = key.exp_id;
            if ismember(exp_id, [3,5,7])
                exp_id = exp_id-1;
            end
            f_dr = eval(['@varprecision.decisionrule.exp' num2str(exp_id)]);
            
            model = fetch1(varprecision.Subject & key,'model_gene');
            pars = fetch(varprecision.FakeDataParams & key, '*');
            [pars.setsizes, pars.sigma_s, path] = fetch1(varprecision.Experiment & key, 'setsize', 'sigma_s','data_path');
            nTrials = 3000;
            pars.pre = 0;
            pars.model_name = model;
            
            if length(pars.setsizes)==1
                [target_stimuli,stimuli] = varprecision.utils.generateFakeStimuli(pars.exp_id,pars.setsizes,nTrials);
                if ismember(model,{'VP','VPG'})
                    pars.lambdaMat = gamrnd(pars.lambda/pars.theta, pars.theta,[pars.setsizes,nTrials]);
                    xMat = stimuli' + normrnd(0,1./sqrt(pars.lambdaMat));
                else
                    xMat = stimuli' + normrnd(0,1/sqrt(pars.lambda),[pars.setsizes,nTrials]);
                end
                
                [~,response] = f_dr(xMat,pars);
                if ismember(model,{'CPG','VPG'})
                    response = varprecision.utils.addLapseTrials(response, pars.guess);
                end
                data = [target_stimuli,response'];
            else
                stimuliMat = [];
                responseMat = [];
                setsizeMat = [];
                ntrials = nTrials/length(pars.setsizes);
                for iSetsize = pars.setsizes
                    setsize = pars.setsizes(iSetsize);
                    pars2 = pars;
                    pars2.lambda = pars.lambda(iSetsize);
                    [target_stimuli,stimuli] = varprecision.utils.generateFakeStimuli(pars.exp_id,setsize,ntrials,max(pars.setsizes));
                    if ismember(model,{'VP','VPG'})
                        pars2.lambdaMat = gamrnd(pars2.lambda/pars2.theta, pars2.theta,[setsize,ntrials]);
                        xMat = stimuli' + normrnd(0,1./sqrt(pars2.lambdaMat));
                    else
                        xMat = stimuli' + normrnd(0,1/sqrt(pars2.lambda),[setsize,ntrials]);
                    end               
                    [~,response] = f_dr(xMat,pars2);
                    setsizeMat = [setsizeMat;repmat(setsize,ntrials,1)];
                    stimuliMat = [stimuliMat;target_stimuli];
                    responseMat = [responseMat;response'];
                end
                if ismember(model,{'CPG','VPG'})
                    responseMat = varprecision.utils.addLapseTrials(responseMat, pars.guess);
                end
                data = [stimuliMat,responseMat,setsizeMat];
            end
            
            % save data locally
            path = [path '_fake' ];
            
            if ~exist(path,'dir')
                mkdir(path)
            end
            save([path '/' key.subj_initial '.mat'],'data')
            
            key.fakepath = path;
            self.insert(key)
		end
	end

end