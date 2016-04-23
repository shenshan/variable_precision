function generateFakeData(exp,model,mode)
%GENERATEFAKEDATA generate fake data based on the parameters and insert both the data
%and the paramters of the data into the database
% function generateFakeData(exp,model,mode,fake_idx)
% exp takes the form "exp_id=", and model takes the form "model_name="
% mode specifies the way to generate the parameters, either based on
% parameters of real subjects, or randomly drawn from the parameter set.

assert(ismember(mode,{'real','random'}),'Invalid mode input, please enter real or random.')
exps = fetch(varprecision.Experiment & exp);

for iexp = exps'
    exp = fetch(varprecision.Experiment & iexp, '*');
    models = fetch(varprecision.Model & model & iexp);
    exp_id = exp.exp_id;
    if ismember(exp_id, [3,5,7])
        exp_id = exp_id-1;
    end
    f_dr = eval(['@varprecision.decisionrule.exp' num2str(exp_id)]);
    
    for imodel = models'
        subjs = fetch(varprecision.Subject & ['model_name="' imodel.model_name '"']);
        for iSubj = subjs'
            % generate fake parameters
            pars = varprecision.utils.generateFakeParams(mode,imodel);
            pars.exp_id = iexp.exp_id;
            pars.subj_initial = iSubj.subj_initial;
            pars.method = mode;
            
            % insert fake pars into fakeparams table
            insert(varprecision.FakeDataParams,pars)
 
            % insert recording info to recording table
            rec.exp_id = iexp.exp_id;
            rec.subj_initial = iSubj.subj_initial;
            insert(varprecision.Recording,rec)
            % generate or load fake stimuli
            nTrials = 3000;
            pars.setsizes = exp.setsize;
            pars.pre = 0;
            pars.model_name = imodel.model_name;
            pars.sigma_s = fetch1(varprecision.Experiment & iexp, 'sigma_s');
            if length(exp.setsize)==1
                [target_stimuli,stimuli] = varprecision.utils.generateFakeStimuli(exp.exp_id,exp.setsize,nTrials);
                if ismember(imodel.model_name,{'VP','VPG'})
                    pars.lambdaMat = gamrnd(pars.lambda/pars.theta, pars.theta,[pars.setsizes,nTrials]);
                    xMat = stimuli' + normrnd(0,1./sqrt(pars.lambdaMat));
                else
                    xMat = stimuli' + normrnd(0,1/sqrt(pars.lambda),[pars.setsizes,nTrials]);
                end
                
                [~,response] = f_dr(xMat,pars);
                if ismember(imodel.model_name,{'CPG','VPG'})
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
                    [target_stimuli,stimuli] = varprecision.utils.generateFakeStimuli(exp.exp_id,setsize,ntrials,max(pars.setsizes));
                    if ismember(imodel.model_name,{'VP','VPG'})
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
                if ismember(imodel.model_name,{'CPG','VPG'})
                    responseMat = varprecision.utils.addLapseTrials(responseMat, pars.guess);
                end
                data = [stimuliMat,responseMat,setsizeMat];
            end
            
            % save data locally
            path = [fetch1(varprecision.Experiment & iexp, 'data_path') '_fake' ];
            
            if ~exist(path,'dir')
                mkdir(path)
            end
            save([path '/' iSubj.subj_initial '.mat'],'data')
        end
    end
end


