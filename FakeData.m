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
            
            exps_gauss = [1:5,8:10];
            [jmap,kmap] = fetch1(varprecision.JbarKappaMap & 'jkmap_id=2','jmap','kmap');
            
            if length(pars.setsizes)==1
                [target_stimuli,stimuli,set_size] = varprecision.utils.generateFakeStimuli(pars.exp_id,pars.setsizes,nTrials);
                if ismember(model,{'VP','VPG'})
                    pars.lambdaMat = gamrnd(pars.lambda/pars.theta, pars.theta,[pars.setsizes,nTrials]);
                    if ismember(key.exp_id, exps_gauss)
                        xMat = stimuli' + normrnd(0,1./sqrt(pars.lambdaMat));
                    else
                        pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                        xMat = stimuli' + circ_vmrnd(0,pars.lambdaMat)/2;
                    end
                elseif ismember(model,{'XP','XPG'})
                    sigma_baseline = 1/sqrt(pars.lambda)*180/pi; 
                    sigma = sigma_baseline*(1 + pars.theta*abs(sin(2*stimuli)))/180*pi;

                    pars.lambdaMat = 1./sigma.^2;
                    pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                    noiseMat = circ_vmrnd(0,pars.lambdaMat)/2;
                    
                    xMat = stimuli' + noiseMat';
                    sigma = sigma_baseline*(1 + pars.theta*abs(sin(2*xMat)))/180*pi;
                    pars.lambdaMat = 1./sigma.^2;
                    pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                elseif ismember(model,{'CP','CPG'})
                    if ismember(key.exp_id, exps_gauss)
                        xMat = stimuli' + normrnd(0,1/sqrt(pars.lambda),[pars.setsizes,nTrials]);
                    else
                        pars.lambda = varprecision.utils.mapJK(pars.lambda,jmap,kmap);
                        xMat = stimuli' + circ_vmrnd(zeros(pars.setsizes,nTrials),pars.lambda);
                    end
                elseif ismember(model,{'OP','OPG'})
                    sigma_baseline = 1/sqrt(pars.lambda); 
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimuli)));
                    if ismember(key.exp_id, exps_gauss)
                        pars.lambdaMat = 1./sigma.^2;
                        xMat = stimuli' + normrnd(0,pars.lambdaMat);
                    else
                        pars.lambdaMat = 1./sigma.^2*180^2/pi^2/4;
                        pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                        xMat = stimuli' + circ_vmrnd(0,pars.lambdaMat)/2;
                    end
                elseif ismember(model,{'OPVP','OPVPG'})
                    sigma_baseline = 1/sqrt(pars.lambda);
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus)));           
                    pars.lambdaMat = 1./sigma.^2;
                    pars.lambdaMat = gamrnd(pars.lambdaMat/pars.theta,pars.theta);
                    
                    if ismember(key.exp_id, exps_gauss)
                        xMat = stimuli' + normrnd(0,pars.lambdaMat);
                    else
                        pars.lambdaMat = pars.lambdaMat*180^2/pi^2/4;
                        pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                        xMat = stimuli' + circ_vmrnd(0,pars.lambdaMat)/2;
                    end
                end
                
                [~,response] = f_dr(xMat,pars);
                if ismember(model,{'CPG','VPG','XPG','OPG','OPVPG'})
                    response = varprecision.utils.addLapseTrials(response, pars.guess);
                end
                if key.exp_id<6
                    data = [target_stimuli,response'];
                elseif ismember(key.exp_id,[6,8]) 
                    data = [stimuli,response'];
                else
                    data = [stimuli,response',set_size'];
                end
            else
                
                [~,stimuli,set_size] = varprecision.utils.generateFakeStimuli(pars.exp_id,0,0,0);
                for iSetsize = 1:length(pars.setsizes)
                    setsize = pars.setsizes(iSetsize);
                    pars2 = pars;
                    pars2.lambda = pars.lambda(iSetsize);
                    stimuli_sub = stimuli(set_size==setsize);
                    if ismember(model, {'OPVP','OPVPG'})
                        sigma_baseline = 1/sqrt(pars2.lambda);
                        sigma = sigma_baseline*(1 + pars2.beta*abs(sin(2*stimuli)));
                        pars2.lambdaMat = 1./sigma.^2;
                        
                        pars2.lambdaMat = gamrnd(pars2.lambdaMat/pars2.theta,pars.theta);
                        pars2.lambdaMat = pars2.lambdaMat'*180^2/pi^2;
                        
                        xMat = stimuli' + circ_vmrnd(0,pars2.lambdaMat)/2;
                    end
                    [~,response_sub] = f_dr(xMat,pars2);
                end
                stimuliMat = [];
                responseMat = [];
                setsizeMat = [];
                ntrials = nTrials/length(pars.setsizes);
                for iSetsize = 1:length(pars.setsizes)
                    setsize = pars.setsizes(iSetsize);
                    pars2 = pars;
                    pars2.lambda = pars.lambda(iSetsize);
                    [target_stimuli,stimuli] = varprecision.utils.generateFakeStimuli(pars.exp_id,setsize,ntrials,max(pars.setsizes));
                    if ismember(model,{'VP','VPG'})
                        pars2.lambdaMat = gamrnd(pars2.lambda/pars2.theta, pars2.theta,[setsize,ntrials]);
                        xMat = stimuli' + normrnd(0,1./sqrt(pars2.lambdaMat));
                    elseif ismember(model,{'OPVP','OPVPG'})
                        sigma_baseline = 1/sqrt(pars2.lambda);
                        sigma = sigma_baseline*(1 + pars2.beta*abs(sin(2*stimuli)));
                        pars2.lambdaMat = 1./sigma.^2;
                        
                        pars2.lambdaMat = gamrnd(pars2.lambdaMat/pars2.theta,pars.theta);
                        pars2.lambdaMat = pars2.lambdaMat'*180^2/pi^2;
                        
                        xMat = stimuli' + circ_vmrnd(0,pars2.lambdaMat)/2;
                    else
                        xMat = stimuli' + normrnd(0,1/sqrt(pars2.lambda),[setsize,ntrials]);
                    end               
                    [~,response] = f_dr(xMat,pars2);
                    setsizeMat = [setsizeMat;repmat(setsize,ntrials,1)];
                    stimuliMat = [stimuliMat;target_stimuli];
                    responseMat = [responseMat;response'];
                end
                if ismember(model,{'CPG','VPG','OPVPG'})
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