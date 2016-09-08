function stimulusMat = adjustStimuliSize(exp_id,stimuli,setsize)
%ADJUSTSTIMULISIZE Adjust the size of the stimulus matrix 
%   Adjust the size of stimulus matrix to generate measurements, for
%   computing the pretables
%   size of the input: nStimuli x 1
%   size of the output: nStimuli x N_items

if ismember(exp_id,[2,3])
    stimulusMat = repmat(stimuli,1,setsize);
elseif ismember(exp_id,[4,5])
    if setsize == 1;
        stimulusMat = stimuli;
    else
        stimulusMat = [stimuli, zeros(length(stimuli),setsize-1)];
    end
else
    stimulusMat = stimuli;
end