function stimulusMat = adjustStimuliSize(exp_id,stimuli,setsize)
%ADJUSTSTIMULISIZE Adjust the size of the stimulus matrix 
%   Adjust the size of stimulus matrix to generate measurements, for
%   computing the pretables
%   size of the input: nStimuli x 1
%   size of the output: nStimuli x N_items

assert(ismember(exp_id,[1,2,3,4,5]),'Invalid experiment id, please enter 1-5.')

if exp_id==1
    stimulusMat = stimuli;
elseif ismember(exp_id,[2,3])
    stimulusMat = repmat(stimuli,1,setsize);
else
    if setsize == 1;
        stimulusMat = stimuli;
    else
        stimulusMat = [stimuli, zeros(length(stimuli),setsize-1)];
    end
end