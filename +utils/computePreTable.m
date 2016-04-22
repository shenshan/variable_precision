function pretable = computePreTable(pars,stimuli)
%COMPUTEPRETABLE takes the stimuli and generate measurements x and feed
%xMat to the decision rule functions
%   pars is a struct composed of all parameters, including the model name.
%   stimluli is a stimuli vector with length of 19. 
%   setsizes are set sizes included in the task.
pars2 = pars;

exp_id = pars.exp_id;
if ismember(exp_id, [3,5,7])
    exp_id = exp_id - 1;
end
% decision rule function that will be called
f_dr = eval(['@varprecision.decisionrule.exp' num2str(exp_id)]);

if ismember(pars.model_name,{'CP','CPG'})
    if length(pars.setsizes) == 1
        pretable = zeros(length(stimuli),length(pars.p_right),length(pars.lambda));
        for ii = 1:length(pars.lambda)
            pars2.lambda = pars.lambda(ii);
            noiseMat = normrnd(0,1/sqrt(pars2.lambda),[pars.setsizes,length(stimuli),pars.trial_num_sim]);
            stimulusMat = varprecision.utils.adjustStimuliSize(pars.exp_id,stimuli,pars.setsizes);
            xMat = repmat(stimulusMat',[1,1,pars.trial_num_sim]) + noiseMat;
            pretable(:,:,ii) = f_dr(xMat,pars2);
        end
        
    else
        pretable = zeros(length(pars.setsizes),length(stimuli),length(pars.p_right),length(pars.lambda));
        for ii = 1:length(pars.setsizes)
            pars2.setsize = pars.setsizes(ii);
            for jj = 1:length(pars.lambda)
                pars2.lambda = pars.lambda(jj);
                noiseMat = normrnd(0,1/sqrt(pars2.lambda),[pars2.setsize,length(stimuli),pars.trial_num_sim]);
                stimulusMat = varprecision.utils.adjustStimuliSize(pars.exp_id,stimuli,pars2.setsize);
                xMat = repmat(stimulusMat',[1,1,pars.trial_num_sim]) + noiseMat;
                pretable(ii,:,:,jj) = f_dr(xMat,pars2);
            end
        end
    end
   
elseif ismember(pars.model_name,{'VP','VPG'})
    if length(pars.setsizes) == 1
        pretable = zeros(length(stimuli),length(pars.p_right),length(pars.lambda),length(pars.theta));
        for ii = 1:length(pars.lambda)
            for jj = 1:length(pars.theta)
               pars2.lambdaMat = gamrnd(pars.lambda(ii)/pars.theta(jj),pars.theta(jj),[pars.setsizes,length(stimuli),pars.trial_num_sim]);
               noiseMat = normrnd(0,1/sqrt(pars2.lambdaMat));
               stimulusMat = varprecision.utils.adjustStimuliSize(pars.exp_id,stimuli,pars.setsizes);
               xMat = repmat(stimulusMat',[1,1,pars.trial_num_sim]) + noiseMat;
               pretable(:,:,ii,jj) = f_dr(xMat,pars2);
            end
        end
    else
        pretable = zeros(length(pars.setsizes),length(stimuli),length(pars.p_right),length(pars.lambda),length(pars.theta));
        
        for ii = 1:length(pars.setsizes)
            pars2.setsize = pars.setsizes(ii);
            for jj = 1:length(pars.lambda)
                for kk = 1:length(pars.theta)
                   pars2.lambdaMat = gamrnd(pars.lambda(jj)/pars.theta(kk),pars.theta(kk),[pars2.setsize,length(stimuli),pars.trial_num_sim]);
                   noiseMat = normrnd(0,1/sqrt(pars2.lambdaMat));
                   stimulusMat = varprecision.utils.adjustStimuliSize(pars.exp_id,stimuli,pars2.setsize);
                   xMat = repmat(stimulusMat',[1,1,pars.trial_num_sim]) + noiseMat;
                   pretable(ii,:,:,jj,kk) = f_dr(xMat,pars2);
                end
            end
        end
        
    end
   
end


