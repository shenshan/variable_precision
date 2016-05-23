function minDiff = getMinDiff(stimuli)
%GETMINDIFF computes the minimal orientation difference between target and distractors 
%   function minDiff = getMinDiff(stimuli)
%   stimuli is a matrix nTrials x nItems
stimuli(stimuli==0) = 1000;
abs_stimuli = abs(stimuli);
minDiff = min(abs_stimuli,[],2);


