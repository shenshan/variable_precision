function stimulusMat = adjustStimuliSize(exp_id,stimuli,setsize,tag)
%ADJUSTSTIMULISIZE Adjust the size of the stimulus matrix 
%   Adjust the size of stimulus matrix to generate measurements, for
%   computing the pretables
%   size of the input: nStimuli x 1
%   size of the output: nStimuli x N_items

if ~exist('tag','var')
    tag = 'single';
end
assert(ismember(tag,{'single','full'}), 'please select one of the following: single, full')

if strcmp(tag,'single')
    if ismember(exp_id,[2,3])
        stimulusMat = repmat(stimuli,1,setsize);
    elseif ismember(exp_id,[4,5])
        if setsize == 1;
            stimulusMat = stimuli;
        else
            stimulusMat = [stimuli, zeros(length(stimuli),setsize-1)];
        end
    elseif ismember(exp_id,[1,9])
        stimulusMat = stimuli;
    elseif ismember(exp_id,[7,11])
        stimulusMat = stimuli(:,1:setsize)*pi/180;
    elseif exp_id == 6
        stimulusMat = stimuli*pi/180;
    elseif exp_id == 10
        stimulusMat = stimuli(:,1:setsize);
    end
else
    if ismember(exp_id,[2,3])
        stimulusMat = repmat(stimuli,1,max(setsize));
    elseif ismember(exp_id,[4,5])
        stimulusMat = [stimuli, zeros(length(stimuli),max(setsize)-1)];
    else
        stimulusMat = stimuli;
    end
end