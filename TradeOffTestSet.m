%{
varprecision.TradeOffTestSet (computed) # generate fake data sub table to compute LL of each parameter combination, to keep it simple, only simulate of single data set
-> varprecision.TradeOffTest
-----
stimuli    : blob           # fake stimuli
response   : blob           # fake response
set_size   : blob            # set size for each trial
%}

classdef TradeOffTestSet < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.TradeOffTest
    end
	methods(Access=protected)

		function makeTuples(self, key)
            
            tuple = key;
            % get a stimulus set from real subject
            subjs = fetch(varprecision.Subject & 'subj_type = "real"');
            keys_data = fetch(varprecision.Data & key & subjs);
            [stimuli, set_size] = fetch1(varprecision.Data & keys_data(1),'stimuli','set_size');
            
            exp_id = key.exp_id;
            if ismember(exp_id, [3,5,7])
                exp_id = exp_id-1;
            end
            f_dr = eval(['@varprecision.decisionrule.exp' num2str(exp_id)]);
            
            model = fetch1(varprecision.TradeOffTest & key,'gene_model');
            gene_pars = fetch1(varprecision.TradeOffTest & key, 'gene_pars');
            
            % fix prior to be 0.5 in this analysis
            pars.p_right = 0.5;
            pars.lambda = gene_pars(1);
            switch model
                case 'OP'
                    pars.beta = gene_pars(2);
                case 'VP'
                    pars.theta = gene_pars(2);
            end


            [pars.setsizes, pars.sigma_s] = fetch1(varprecision.Experiment & key, 'setsize', 'sigma_s');
            nTrials = 3000;
            pars.pre = 0;
            pars.model_name = model;
            
            exps_gauss = [1:5,8:10];
            [jmap,kmap] = fetch1(varprecision.JbarKappaMap & 'jkmap_id=2','jmap','kmap');
            key.stimuli = stimuli;
            % only works for gaussian experiments
            if length(pars.setsizes)>1
                setsize = 4;
                pars.setsizes = 4;
                set_size = ones(size(stimuli))*setsize;
                stimuli = varprecision.utils.adjustStimuliSize(key.exp_id,stimuli,setsize);             
            end
            
            if ismember(model,{'VP','VPG'})
                pars.lambdaMat = gamrnd(pars.lambda/pars.theta, pars.theta,[pars.setsizes,nTrials]);
                if ismember(key.exp_id, exps_gauss)
                    xMat = stimuli' + normrnd(0,1./sqrt(pars.lambdaMat));
                else
                    pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                    xMat = stimuli' + circ_vmrnd(0,pars.lambdaMat)/2;
                end
            elseif ismember(model,{'CP','CPG'})
                if ismember(key.exp_id, exps_gauss)
                    xMat = stimuli' + normrnd(0,1/sqrt(pars.lambda),[pars.setsizes,nTrials]);
                else
                    pars.lambda = varprecision.utils.mapJK(pars.lambda,jmap,kmap);
                    xMat = stimuli' + circ_vmrnd(zeros(pars.setsizes,nTrials),pars.lambda);
                end
            elseif ismember(model,{'OP','OPG'})
                sigma_baseline = 1/sqrt(pars.lambda);      
                if ismember(key.exp_id, exps_gauss)
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimuli*pi/180)));
                    pars.lambdaMat = 1./sigma.^2;
                    xMat = stimuli' + normrnd(0,pars.lambdaMat);
                else
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimuli)));
                    pars.lambdaMat = 1./sigma.^2*180^2/pi^2/4;
                    pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                    xMat = stimuli' + circ_vmrnd(0,pars.lambdaMat)/2;
                end
            elseif ismember(model,{'OPVP','OPVPG'})
                sigma_baseline = 1/sqrt(pars.lambda);  
                if ismember(key.exp_id, exps_gauss)
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus*pi/180)));           
                    pars.lambdaMat = 1./sigma.^2;
                    pars.lambdaMat = gamrnd(pars.lambdaMat/pars.theta,pars.theta);
                    xMat = stimuli' + normrnd(0,pars.lambdaMat);
                else
                    sigma = sigma_baseline*(1 + pars.beta*abs(sin(2*stimulus)));           
                    pars.lambdaMat = 1./sigma.^2;
                    pars.lambdaMat = gamrnd(pars.lambdaMat/pars.theta,pars.theta);
                    pars.lambdaMat = pars.lambdaMat*180^2/pi^2/4;
                    pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
                    xMat = stimuli' + circ_vmrnd(0,pars.lambdaMat)/2;
                end
            end

            [~,response] = f_dr(xMat,pars);
                                
            if ismember(model,{'CPG','VPG','OPG','OPVPG'})
                response = varprecision.utils.addLapseTrials(response, pars.guess);
            end
           
            key.response = response;
            key.set_size = set_size;
			self.insert(key)
            
            % insert parameter combination index in the sub table
            [test_pars_ub, test_pars_lb, nsteps] = fetch1(varprecision.TradeOffTest & key, 'test_pars_ub','test_pars_lb','nsteps');
            test_pars_range = test_pars_ub - test_pars_lb;
            
            for ii = 1:prod(nsteps)
                tuple.pars_idx = ii;
                tuple.pars_idx_vec = ind2subVect(nsteps,ii);
                tuple.test_pars = test_pars_lb + test_pars_range./nsteps.*tuple.pars_idx_vec;
                insert(varprecision.TradeOffTestPars,tuple);
            end
            
		end
	end

end