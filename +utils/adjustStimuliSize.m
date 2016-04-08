function stimulusMat = adjustStimuliSize(exp_id,stimuli,setsize)
%ADJUSTSTIMULISIZE Adjust the size of the stimulus matrix 
%   Adjust the size of stimulus matrix to generate measurements, for
%   computing the pretables
%   size of the input: 1 x nStimuli
%   size of the output: N_items x nStimuli

assert(ismember(exp_id,[2,3,4,5]),'Invalid experiment id, please enter 2-5.')

if ismember(exp_id,[2,3])
    stimulusMat = repmat(stimuli,setsize,1);
else
    if setsize == 1;
        stimulusMat = stimuli;
    else
        stimulusMat = [stimuli; zeros(setsize-1,length(stimuli))];
    end
end