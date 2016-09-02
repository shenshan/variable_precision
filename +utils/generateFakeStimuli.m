function [target_stimuli, stimuli, set_size, stimuli_adj] = generateFakeStimuli(exp_id,setsize,nTrials,setsize_max)
%GENERATEFAKESTIMULI Generate fake stimuli based on the real stimuli that
%shown to the subjects
%   setsize specifies the set size of the stimuli, should be a scalar
%   nTrials specifies the number of trials
%   output matrix size: stimuli, nTrials x setsize
%                       stimuli, nTrials x setsize_max

assert(numel(setsize)==1,'setsize has to be a scalar.')

if ismember(exp_id,1:5)
    keys = fetch(varprecision.DataStats & ['exp_id=' num2str(exp_id)]);
    stims = fetch1(varprecision.DataStats & keys(1),'stims');
    
    target_stimuli = stims(randi(length(stims),[nTrials,1]));
    
    if exp_id==1
        stimuli = target_stimuli;
    else
        stimuli = varprecision.utils.adjustStimuliSize(exp_id,target_stimuli,setsize);
    end
    % dummy, will not be used when called
    set_size = 0;
    % fill the blanks with zeros if there are multiple set sizes
    if exist('setsize_max','var')
        dummy = zeros(nTrials,setsize_max-setsize);
        stimuli_adj = [stimuli,dummy];
    else
        stimuli_adj = stimuli;
    end
else
    % for exps 6-11, take the stimuli of a random subject as the stimuli for fake data sets
    subjs = fetch(varprecision.Subject & 'subj_type="real"');
    [stimuli, set_size] = fetch1(varprecision.Data & randKey(varprecision.Recording & subjs & ['exp_id=' num2str(exp_id)]),'stimuli','set_size');
    % dummy, will not be used when called
    stimuli_adj = stimuli;
    target_stimuli = stimuli(:,1);
end

